class LocationModel {
  final String id;
  String name;
  String code;
  String zoneOrFloor; // Zona / Lantai Gedung
  String pic; // Penanggung Jawab Gedung
  String referenceNote; // Catatan Referensi / Keterangan (Field 5)
  bool isActive; // Status Aktif Master Data

  LocationModel({
    required this.id,
    required this.name,
    required this.code,
    required this.zoneOrFloor,
    required this.pic,
    this.referenceNote = 'Gedung utama kampus',
    this.isActive = true,
  });
}
