import 'package:flutter/material.dart';

class Report {
  final String id;
  String title;
  String location;
  String locationId;
  String category;
  String categoryId;
  String urgency;
  String description;
  String date;
  String status; // 'Menunggu Verifikasi', 'Diproses', 'Selesai'
  Color statusColor;
  String? imagePath; // Simpan path/file foto bukti kerusakan
  double? latitude;
  double? longitude;

  Report({
    required this.id,
    required this.title,
    required this.location,
    required this.locationId,
    required this.category,
    required this.categoryId,
    required this.urgency,
    required this.description,
    required this.date,
    required this.status,
    required this.statusColor,
    this.imagePath,
    this.latitude,
    this.longitude
  });
}
