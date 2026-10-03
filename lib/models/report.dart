import 'package:flutter/material.dart';

class Report {
  final String id;
  String title;
  String location;
  String category;
  String urgency;
  String description;
  String date;
  String status; // 'Menunggu Verifikasi', 'Diproses', 'Selesai'
  Color statusColor;
  String? imagePath; // Simpan path/file foto bukti kerusakan
  String? categoryId; // Relasi ID Kategori Referensi (Modul Anggota 3)
  String? locationId; // Relasi ID Lokasi Referensi (Modul Anggota 3)

  Report({
    required this.id,
    required this.title,
    required this.location,
    required this.category,
    required this.urgency,
    required this.description,
    required this.date,
    required this.status,
    required this.statusColor,
    this.imagePath,
    this.categoryId,
    this.locationId,
  });
}
