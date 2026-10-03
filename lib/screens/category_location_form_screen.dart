import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../models/location_model.dart';

class CategoryLocationFormScreen extends StatefulWidget {
  final CategoryModel? category;
  final LocationModel? location;
  final bool isCategory;

  const CategoryLocationFormScreen({
    super.key,
    this.category,
    this.location,
    required this.isCategory,
  });

  @override
  State<CategoryLocationFormScreen> createState() =>
      _CategoryLocationFormScreenState();
}

class _CategoryLocationFormScreenState
    extends State<CategoryLocationFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _codeController;
  late TextEditingController _descOrPicController;
  late TextEditingController _noteController;

  String _selectedTypeOrZone = 'Barang Bergerak';
  bool _isActive = true;

  final List<String> _categoryTypes = [
    'Barang Bergerak',
    'Barang Tetap',
    'Fasilitas Umum',
    'Elektronik',
  ];

  final List<String> _locationZones = [
    'Lantai 1',
    'Lantai 2',
    'Lantai 3',
    'Lantai 4',
    'Lantai Dasar',
    'Lantai 1 - 3',
    'Lantai 1 - 4',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.isCategory) {
      _nameController = TextEditingController(
        text: widget.category?.name ?? '',
      );
      _codeController = TextEditingController(
        text: widget.category?.code ?? 'CAT-${DateTime.now().millisecond}',
      );
      _descOrPicController = TextEditingController(
        text: widget.category?.description ?? '',
      );
      _noteController = TextEditingController(
        text: widget.category?.referenceNote ?? 'Kategori standar fasilitas SIGAP',
      );
      _selectedTypeOrZone = widget.category?.type ?? 'Barang Bergerak';
      _isActive = widget.category?.isActive ?? true;
    } else {
      _nameController = TextEditingController(
        text: widget.location?.name ?? '',
      );
      _codeController = TextEditingController(
        text: widget.location?.code ?? 'LOC-${DateTime.now().millisecond}',
      );
      _descOrPicController = TextEditingController(
        text: widget.location?.pic ?? '',
      );
      _noteController = TextEditingController(
        text: widget.location?.referenceNote ?? 'Gedung utama kampus',
      );
      _selectedTypeOrZone = widget.location?.zoneOrFloor ?? 'Lantai 1';
      _isActive = widget.location?.isActive ?? true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _descOrPicController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      if (widget.isCategory) {
        final resultCategory = CategoryModel(
          id: widget.category?.id ?? 'CAT-${DateTime.now().millisecondsSinceEpoch}',
          name: _nameController.text,
          code: _codeController.text,
          type: _selectedTypeOrZone,
          description: _descOrPicController.text,
          referenceNote: _noteController.text,
          isActive: _isActive,
        );
        Navigator.pop(context, resultCategory);
      } else {
        final resultLocation = LocationModel(
          id: widget.location?.id ?? 'LOC-${DateTime.now().millisecondsSinceEpoch}',
          name: _nameController.text,
          code: _codeController.text,
          zoneOrFloor: _selectedTypeOrZone,
          pic: _descOrPicController.text,
          referenceNote: _noteController.text,
          isActive: _isActive,
        );
        Navigator.pop(context, resultLocation);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.category != null || widget.location != null;
    final titleType = widget.isCategory ? 'Kategori Fasilitas' : 'Lokasi Gedung';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Ubah $titleType' : 'Tambah $titleType',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.isCategory
                    ? 'Formulir Master Data Kategori'
                    : 'Formulir Master Data Gedung',
                style: const TextStyle(
                  color: Color(0xFF0F766E),
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Lengkapi minimal 5 field di bawah ini untuk mengelola data referensi.',
                style: TextStyle(
                  color: Color(0xFF627D98),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 24),

              // Field 1: Nama
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: widget.isCategory ? 'Nama Kategori Fasilitas *' : 'Nama Lokasi Gedung *',
                  hintText: widget.isCategory ? 'Contoh: Elektronik & Audio' : 'Contoh: Gedung D - Fakultas Hukum',
                  prefixIcon: Icon(
                    widget.isCategory ? Icons.category_rounded : Icons.apartment_rounded,
                  ),
                ),
                validator: (val) => (val == null || val.isEmpty)
                    ? 'Nama tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 16),

              // Field 2: Kode
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Kode Kategori / Gedung *',
                  hintText: 'Contoh: CAT-ELV atau LOC-REC',
                  prefixIcon: Icon(Icons.code_rounded),
                ),
                validator: (val) => (val == null || val.isEmpty)
                    ? 'Kode tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 16),

              // Field 3: Dropdown Jenis Fasilitas / Zona Lantai
              DropdownButtonFormField<String>(
                initialValue: _selectedTypeOrZone,
                decoration: InputDecoration(
                  labelText: widget.isCategory ? 'Jenis Fasilitas *' : 'Zona / Lantai Gedung *',
                  prefixIcon: Icon(
                    widget.isCategory ? Icons.list_alt_rounded : Icons.layers_rounded,
                  ),
                ),
                items: (widget.isCategory ? _categoryTypes : _locationZones)
                    .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedTypeOrZone = val!),
              ),
              const SizedBox(height: 16),

              // Field 4: Deskripsi / Penanggung Jawab
              TextFormField(
                controller: _descOrPicController,
                maxLines: widget.isCategory ? 3 : 1,
                decoration: InputDecoration(
                  labelText: widget.isCategory ? 'Deskripsi Kategori *' : 'Penanggung Jawab Gedung *',
                  hintText: widget.isCategory ? 'Deskripsi fungsi fasilitas...' : 'Contoh: Dr. Ahmad Fauzi, M.Kom.',
                  prefixIcon: Icon(
                    widget.isCategory ? Icons.description_outlined : Icons.person_outline_rounded,
                  ),
                ),
                validator: (val) => (val == null || val.isEmpty)
                    ? 'Field ini tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 16),

              // Field 5: Catatan Referensi / Keterangan
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Catatan Referensi / Keterangan (Field 5) *',
                  hintText: 'Catatan standar referensi...',
                  prefixIcon: Icon(Icons.note_alt_outlined),
                ),
                validator: (val) => (val == null || val.isEmpty)
                    ? 'Keterangan tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 20),

              // Switch: Status Aktif Master Data
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFD9E2E2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.toggle_on_outlined, color: Color(0xFF0F766E)),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Status Aktif Master Data',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Data aktif dan dapat dipilih dalam laporan',
                            style: TextStyle(fontSize: 12, color: Color(0xFF627D98)),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _isActive,
                      activeThumbColor: const Color(0xFF0F766E),
                      onChanged: (val) => setState(() => _isActive = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Button Simpan
              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save_rounded),
                label: const Text('SIMPAN MASTER DATA'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  backgroundColor: const Color(0xFF0F766E),
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
}
