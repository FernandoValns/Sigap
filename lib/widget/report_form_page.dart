import 'package:flutter/material.dart';

class ReportFormPage extends StatelessWidget {
  const ReportFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Laporan Baru'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.construction, size: 80, color: Colors.orange),
            SizedBox(height: 16),
            Text(
              'Halaman Form Pelaporan\nSedang Dikerjakan oleh Anggota 2',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
