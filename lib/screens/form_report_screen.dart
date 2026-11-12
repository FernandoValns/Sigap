import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../models/report.dart';
import '../data/mock_data.dart';

final Geocoding geocoding = Geocoding();

class FormReportScreen extends StatefulWidget {
  final Report? report;

  const FormReportScreen({super.key, this.report});

  @override
  State<FormReportScreen> createState() => _FormReportScreenState();
}

class _FormReportScreenState extends State<FormReportScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _gpsAddressController; // Menyimpan alamat dari GPS

  // State berbasis ID
  late String _selectedCategoryId;
  String? _selectedLocationId;
  String _selectedUrgency = 'Sedang';

  // State GPS
  double? _latitude;
  double? _longitude;
  bool _isLoadingLocation = false;

  // State Foto
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  final List<String> _urgencies = ['Rendah', 'Sedang', 'Tinggi'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.report?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.report?.description ?? '',
    );
    _gpsAddressController = TextEditingController(
      text: widget.report?.location ?? '',
    );

    // Inisialisasi ID Kategori
    _selectedCategoryId = MockData.categories.isNotEmpty
        ? MockData.categories.first.id
        : '';

    // Inisialisasi ID Lokasi (jika ada)
    if (MockData.locations.isNotEmpty) {
      _selectedLocationId = MockData.locations.first.id;
    }

    if (widget.report != null) {
      // Set kategori berdasarkan ID saat mode edit
      if (MockData.categories.any((c) => c.id == widget.report!.categoryId)) {
        _selectedCategoryId = widget.report!.categoryId;
      }
      // Set lokasi berdasarkan ID saat mode edit
      if (MockData.locations.any((l) => l.id == widget.report!.locationId)) {
        _selectedLocationId = widget.report!.locationId;
      } else {
        _selectedLocationId =
            'custom_gps'; // Jika lokasi berasal dari titik GPS kustom
      }

      _selectedUrgency = widget.report!.urgency;
      _latitude = widget.report!.latitude;
      _longitude = widget.report!.longitude;

      if (widget.report!.imagePath != null) {
        _selectedImage = File(widget.report!.imagePath!);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _gpsAddressController.dispose();
    super.dispose();
  }

  // --- FUNGSI DETEKSI LOKASI GPS ---
  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled)
        throw 'Layanan GPS tidak aktif. Silakan aktifkan GPS.';

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied)
          throw 'Izin lokasi ditolak.';
      }
      if (permission == LocationPermission.deniedForever) {
        throw 'Izin lokasi ditolak permanen. Ubah di pengaturan HP.';
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _latitude = position.latitude;
      _longitude = position.longitude;

      List<Placemark> placemarks = await geocoding.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String detectedAddress =
          'Titik GPS (${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)})';
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        detectedAddress =
            '${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}'
                .replaceAll(RegExp(r'^, |, $'), '');
      }

      setState(() {
        _selectedLocationId =
            'custom_gps'; // Tandai bahwa lokasi dipilih via GPS
        _gpsAddressController.text = detectedAddress;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoadingLocation = false);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _saveForm() {
    final isValid = _formKey.currentState!.validate();

    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto bukti kerusakan wajib diunggah!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (isValid) {
      // Ambil nama kategori berdasarkan ID yang dipilih
      final selectedCatObj = MockData.categories.firstWhere(
        (c) => c.id == _selectedCategoryId,
        orElse: () => MockData.categories.first,
      );

      // Tentukan nama lokasi yang akan disimpan
      String finalLocationName = _gpsAddressController.text;
      if (_selectedLocationId != 'custom_gps') {
        final selectedLocObj = MockData.locations.firstWhere(
          (l) => l.id == _selectedLocationId,
          orElse: () => MockData.locations.first,
        );
        finalLocationName = selectedLocObj.name;
      }

      final newReport = Report(
        id:
            widget.report?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        categoryId: _selectedCategoryId,
        category: selectedCatObj.name,
        locationId: _selectedLocationId ?? 'custom_gps',
        location: finalLocationName,
        urgency: _selectedUrgency,
        description: _descriptionController.text,
        date: widget.report?.date ?? '25 Sep 2026',
        status: widget.report?.status ?? 'Menunggu Verifikasi',
        statusColor: widget.report?.statusColor ?? Colors.orange,
        imagePath: _selectedImage!.path,
        latitude: _latitude,
        longitude: _longitude,
      );

      Navigator.pop(context, newReport);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.report != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Laporan' : 'Buat Laporan Baru'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // --- AREA FOTO ---
              const Text(
                'Foto Bukti Kerusakan*',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _showImagePickerDialog(),
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _selectedImage == null ? Colors.grey : Colors.teal,
                      width: 2,
                    ),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: kIsWeb
                              ? Image.network(
                                  _selectedImage!.path,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                )
                              : Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              size: 50,
                              color: Colors.teal,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Ketuk untuk ambil / pilih foto',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // --- JUDUL ---
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul Laporan*',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Judul tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 16),

              // --- DROPDOWN LOKASI / GEDUNG BERBASIS ID + TOMBOL GPS ---
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: _selectedLocationId,
                      decoration: const InputDecoration(
                        labelText: 'Lokasi / Gedung*',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        // Opsi gedung dari MockData
                        ...MockData.locations.map(
                          (loc) => DropdownMenuItem(
                            value: loc.id,
                            child: Text(
                              loc.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        // Opsi tambahan jika memakai titik GPS
                        const DropdownMenuItem(
                          value: 'custom_gps',
                          child: Text(
                            '📍 Lokasi Terdeteksi GPS',
                            style: TextStyle(color: Colors.teal),
                          ),
                        ),
                      ],
                      onChanged: (val) {
                        setState(() {
                          _selectedLocationId = val;
                          if (val != 'custom_gps') {
                            // Reset teks alamat kustom jika memilih gedung dari daftar
                            final loc = MockData.locations.firstWhere(
                              (l) => l.id == val,
                            );
                            _gpsAddressController.text = loc.name;
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Tombol pemicu GPS
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoadingLocation
                          ? null
                          : _getCurrentLocation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoadingLocation
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.my_location, color: Colors.white),
                    ),
                  ),
                ],
              ),

              // Jika memilih lokasi via GPS, tampilkan kolom detail alamat yang bisa diedit
              if (_selectedLocationId == 'custom_gps') ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _gpsAddressController,
                  decoration: InputDecoration(
                    labelText: 'Detail Alamat / Titik GPS*',
                    border: const OutlineInputBorder(),
                    helperText: (_latitude != null && _longitude != null)
                        ? 'Koordinat: ${_latitude!.toStringAsFixed(5)}, ${_longitude!.toStringAsFixed(5)}'
                        : null,
                  ),
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Detail lokasi wajib diisi'
                      : null,
                ),
              ],
              const SizedBox(height: 16),

              // --- DROPDOWN KATEGORI BERBASIS ID ---
              DropdownButtonFormField<String>(
                value: _selectedCategoryId,
                decoration: const InputDecoration(
                  labelText: 'Kategori Kerusakan',
                  border: OutlineInputBorder(),
                ),
                items: MockData.categories
                    .map(
                      (cat) => DropdownMenuItem(
                        value: cat.id,
                        child: Text(cat.name),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _selectedCategoryId = val!),
              ),
              const SizedBox(height: 16),

              // --- URGENSI ---
              DropdownButtonFormField<String>(
                value: _selectedUrgency,
                decoration: const InputDecoration(
                  labelText: 'Tingkat Urgensi',
                  border: OutlineInputBorder(),
                ),
                items: _urgencies
                    .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedUrgency = val!),
              ),
              const SizedBox(height: 16),

              // --- DESKRIPSI ---
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Kerusakan*',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Deskripsi tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _saveForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  minimumSize: const Size.fromHeight(50),
                ),
                child: Text(
                  isEditing ? 'SIMPAN PERUBAHAN' : 'KIRIM LAPORAN',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImagePickerDialog() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Kamera (Ambil Foto Langsung)'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeri HP'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
}
