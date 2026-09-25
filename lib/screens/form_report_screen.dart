import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/report.dart';

class FormReportScreen extends StatefulWidget {
  final Report? report;

  const FormReportScreen({super.key, this.report});

  @override
  State<FormReportScreen> createState() => _FormReportScreenState();
}

class _FormReportScreenState extends State<FormReportScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;

  String _selectedCategory = 'Fasilitas Kelas';
  String _selectedUrgency = 'Sedang';

  // State untuk menyimpan foto yang dipilih
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  final List<String> _categories = [
    'Fasilitas Kelas',
    'Elektronik',
    'Toilet',
    'Lainnya',
  ];
  final List<String> _urgencies = ['Rendah', 'Sedang', 'Tinggi'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.report?.title ?? '');
    _locationController = TextEditingController(
      text: widget.report?.location ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.report?.description ?? '',
    );

    if (widget.report != null) {
      _selectedCategory = widget.report!.category;
      _selectedUrgency = widget.report!.urgency;
      if (widget.report!.imagePath != null) {
        _selectedImage = File(widget.report!.imagePath!);
      }
    }
  }

  // Fungsi Memilih Foto dari Kamera atau Galeri (FR-03 & Alur 5.2)
  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 80, // Mengurangi ukuran file foto
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _saveForm() {
    // 1. Validasi Teks
    final isValid = _formKey.currentState!.validate();

    // 2. Validasi Khusus Foto (Wajib Diunggah)
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
      final newReport = Report(
        id:
            widget.report?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        location: _locationController.text,
        category: _selectedCategory,
        urgency: _selectedUrgency,
        description: _descriptionController.text,
        date: widget.report?.date ?? '25 Sep 2026',
        status: widget.report?.status ?? 'Menunggu Verifikasi',
        statusColor: widget.report?.statusColor ?? Colors.orange,
        imagePath: _selectedImage!.path, // Menyimpan file path gambar
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
              // --- AREA UNGGAH & PRATINJAU FOTO ---
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

              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Lokasi / Gedung*',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Lokasi tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Kategori Kerusakan',
                  border: OutlineInputBorder(),
                ),
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedCategory = val!),
              ),
              const SizedBox(height: 16),

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

  // Dialog Pilihan Sumber Foto (Kamera / Galeri)
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
                _pickImage(
                  ImageSource.camera,
                ); // Menggunakan kamera langsung (FR-03 & Alur 5.2)
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
