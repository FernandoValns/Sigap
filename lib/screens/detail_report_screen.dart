import 'dart:io';

import 'package:flutter/material.dart';

import '../models/report.dart';
import 'form_report_screen.dart';

class DetailReportScreen extends StatelessWidget {
  final Report report;

  const DetailReportScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Laporan'),
        actions: [
          // Tombol Edit (Update) - Hanya jika status masih 'Menunggu Verifikasi'
          if (report.status == 'Menunggu Verifikasi')
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final updatedReport = await Navigator.push<Report>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FormReportScreen(report: report),
                  ),
                );
                if (updatedReport != null) {
                  Navigator.pop(context, {
                    'action': 'update',
                    'data': updatedReport,
                  });
                }
              },
            ),
          // Tombol Hapus (Delete)
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              // Dialog konfirmasi hapus
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Hapus Laporan'),
                  content: const Text(
                    'Apakah Anda yakin ingin membatalkan/menghapus laporan ini?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx); // Tutup dialog
                        Navigator.pop(context, {
                          'action': 'delete',
                          'id': report.id,
                        }); // Kembali dengan flag hapus
                      },
                      child: const Text(
                        'Hapus',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            report.imagePath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(report.imagePath!),
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    height: 180,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, size: 80),
                  ),
            const SizedBox(height: 16),
            Text(
              report.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Lokasi: ${report.location}',
              style: TextStyle(color: Colors.grey[700]),
            ),
            Text(
              'Kategori: ${report.category}',
              style: TextStyle(color: Colors.grey[700]),
            ),
            Text(
              'Urgensi: ${report.urgency}',
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 16),
            const Text(
              'Deskripsi:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(report.description),
            const Spacer(),
            Chip(
              label: Text(
                report.status,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: report.statusColor,
            ),
          ],
        ),
      ),
    );
  }
}
