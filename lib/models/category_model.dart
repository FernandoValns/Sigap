class CategoryModel {
  final String id;
  String name;
  String code;
  String type; // Jenis Fasilitas
  String description;
  String referenceNote; // Catatan Referensi / Keterangan (Field 5)
  bool isActive; // Status Aktif Master Data

  CategoryModel({
    required this.id,
    required this.name,
    required this.code,
    required this.type,
    required this.description,
    this.referenceNote = 'Kategori standar fasilitas SIGAP',
    this.isActive = true,
  });
}
