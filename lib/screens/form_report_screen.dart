import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/report.dart';
import '../data/mock_data.dart';

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

  // Sinkronisasi dengan Master Data Anggota 3 (MockData)
  final List<String> _categories = MockData.categories.map((c) => c.name).toList();
  final List<String> _locations = MockData.locations.map((l) => l.name).toList();
  final List<String> _urgencies = ['Rendah', 'Sedang', 'Tinggi'];

  late String _selectedCategory;
  late String _selectedLocation;
  String _selectedUrgency = 'Sedang';

  // State untuk menyimpan foto yang dipilih
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.report?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.report?.description ?? '',
    );

    _selectedCategory = (_categories.isNotEmpty) ? _categories.first : 'Fasilitas Umum';
    _selectedLocation = (_locations.isNotEmpty) ? _locations.first : 'Gedung Kuliah Bersama (GKB)';

    if (widget.report != null) {
      if (_categories.contains(widget.report!.category)) {
        _selectedCategory = widget.report!.category;
      }
      if (_locations.contains(widget.report!.location)) {
        _selectedLocation = widget.report!.location;
      }
      _selectedUrgency = widget.report!.urgency;
      if (widget.report!.imagePath != null) {
        _selectedImage = File(widget.report!.imagePath!);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Fungsi Memilih Foto dari Kamera atau Galeri
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
      // Temukan ID relasi kategori dan lokasi berdasarkan Master Data Anggota 3
      String? matchedCatId;
      try {
        matchedCatId = MockData.categories.firstWhere((c) => c.name == _selectedCategory).id;
      } catch (_) {
        matchedCatId = 'CAT-01';
      }

      String? matchedLocId;
      try {
        matchedLocId = MockData.locations.firstWhere((l) => l.name == _selectedLocation).id;
      } catch (_) {
        matchedLocId = 'LOC-01';
      }

      final newReport = Report(
        id: widget.report?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        location: _selectedLocation,
        category: _selectedCategory,
        urgency: _selectedUrgency,
        description: _descriptionController.text,
        date: widget.report?.date ?? '18 Sep 2026',
        status: widget.report?.status ?? 'Menunggu Verifikasi',
        statusColor: widget.report?.statusColor ?? Colors.orange,
        imagePath: _selectedImage!.path,
        categoryId: matchedCatId,
        locationId: matchedLocId,
      );

      Navigator.pop(context, newReport);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.report != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Laporan Kerusakan' : 'Buat Laporan Kerusakan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Formulir Pengaduan Fasilitas Kampus',
                style: TextStyle(
                  color: Color(0xFF0F766E),
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Laporkan fasilitas rusak atau tidak memadai dengan memilih kategori dan lokasi gedung yang tepat.',
                style: TextStyle(color: Color(0xFF627D98), fontSize: 12),
              ),
              const SizedBox(height: 20),

              // --- AREA UNGGAH & PRATINJAU FOTO ---
              const Text(
                'Foto Bukti Kerusakan*',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 8),

              GestureDetector(
                onTap: () => _showImagePickerDialog(),
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _selectedImage == null ? const Color(0xFFD9E2E2) : const Color(0xFF0F766E),
                      width: 2,
                    ),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.add_a_photo_rounded,
                              size: 46,
                              color: Color(0xFF0F766E),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Ketuk untuk ambil / unggah foto bukti',
                              style: TextStyle(color: Color(0xFF627D98), fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul Kerusakan *',
                  hintText: 'Contoh: AC Lab Komputer Tidak Dingin',
                  prefixIcon: Icon(Icons.title_rounded),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Judul tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 16),

              // Dropdown Lokasi Gedung (Sinkron dengan Master Data Lokasi Anggota 3)
              DropdownButtonFormField<String>(
                initialValue: _selectedLocation,
                decoration: const InputDecoration(
                  labelText: 'Pilih Lokasi Fakultas / Gedung *',
                  prefixIcon: Icon(Icons.apartment_rounded),
                ),
                items: _locations
                    .map((loc) => DropdownMenuItem(value: loc, child: Text(loc, overflow: TextOverflow.ellipsis)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedLocation = val!),
              ),
              const SizedBox(height: 16),

              // Dropdown Kategori Fasilitas (Sinkron dengan Master Data Kategori Anggota 3)
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Pilih Kategori Fasilitas *',
                  prefixIcon: Icon(Icons.category_rounded),
                ),
                items: _categories
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat, overflow: TextOverflow.ellipsis)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedCategory = val!),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _selectedUrgency,
                decoration: const InputDecoration(
                  labelText: 'Tingkat Urgensi *',
                  prefixIcon: Icon(Icons.warning_amber_rounded),
                ),
                items: _urgencies
                    .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedUrgency = val!),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Detail Kerusakan *',
                  hintText: 'Jelaskan kerusakan fasilitas secara rinci...',
                  prefixIcon: Icon(Icons.description_outlined),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Deskripsi tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 28),

              FilledButton.icon(
                onPressed: _saveForm,
                icon: const Icon(Icons.send_rounded),
                label: Text(
                  isEditing ? 'SIMPAN PERUBAHAN LAPORAN' : 'KIRIM LAPORAN KERUSAKAN',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0F766E),
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
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
              leading: const Icon(Icons.camera_alt, color: Color(0xFF0F766E)),
              title: const Text('Kamera (Ambil Foto Langsung)'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFF0F766E)),
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
