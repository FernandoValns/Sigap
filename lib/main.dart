import 'dart:io';

import 'package:flutter/material.dart';

import 'models/report.dart';
import 'screens/form_report_screen.dart';
import 'screens/detail_report_screen.dart';

void main() {
  runApp(const SigapApp());
}

class SigapApp extends StatelessWidget {
  const SigapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIGAP Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const DashboardMahasiswa(),
    );
  }
}

class DashboardMahasiswa extends StatefulWidget {
  const DashboardMahasiswa({super.key});

  @override
  State<DashboardMahasiswa> createState() => _DashboardMahasiswaState();
}

class _DashboardMahasiswaState extends State<DashboardMahasiswa> {
  int _currentIndex = 0;

  // READ: List dummy laporan awal
  List<Report> reports = [
    Report(
      id: '1',
      title: 'AC Rusak & Bocor',
      location: 'Gedung B - Ruang 204',
      category: 'Fasilitas Kelas',
      urgency: 'Tinggi',
      description: 'AC meneteskan air deras dan tidak dingin.',
      date: '17 Sep 2026',
      status: 'Menunggu Verifikasi',
      statusColor: Colors.orange,
    ),
    Report(
      id: '2',
      title: 'Proyektor Redup',
      location: 'Lab Komputer 3',
      category: 'Elektronik',
      urgency: 'Sedang',
      description: 'Tampilan proyektor sangat redup tidak terbaca.',
      date: '15 Sep 2026',
      status: 'Diproses',
      statusColor: Colors.blue,
    ),
  ];

  // CREATE: Fungsi Tambah Laporan
  void _navigateAndCreateReport() async {
    final newReport = await Navigator.push<Report>(
      context,
      MaterialPageRoute(builder: (context) => const FormReportScreen()),
    );

    if (newReport != null) {
      setState(() {
        reports.insert(0, newReport); // Tambahkan laporan baru di paling atas
      });
    }
  }

  // READ & DELETE & UPDATE: Navigasi ke Detail
  void _navigateToDetail(Report report) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailReportScreen(report: report),
      ),
    );

    if (result != null && result is Map) {
      if (result['action'] == 'delete') {
        // DELETE
        setState(() {
          reports.removeWhere((r) => r.id == result['id']);
        });
      } else if (result['action'] == 'update') {
        // UPDATE
        final updatedData = result['data'] as Report;
        setState(() {
          int index = reports.indexWhere((r) => r.id == updatedData.id);
          if (index != -1) {
            reports[index] = updatedData;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Hitung ringkasan status
    int countPending = reports
        .where((r) => r.status == 'Menunggu Verifikasi')
        .length;
    int countProgress = reports.where((r) => r.status == 'Diproses').length;
    int countDone = reports.where((r) => r.status == 'Selesai').length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SIGAP Mahasiswa',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Halo, Mahasiswa!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Laporkan kerusakan fasilitas kampusmu di sini.',
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),

            // CTA CREATE
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _navigateAndCreateReport,
                icon: const Icon(Icons.add_a_photo, color: Colors.white),
                label: const Text(
                  'BUAT LAPORAN BARU',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              ),
            ),
            const SizedBox(height: 24),

            // RINGKASAN STATUS
            Row(
              children: [
                _buildStatusCard('Menunggu', '$countPending', Colors.orange),
                const SizedBox(width: 8),
                _buildStatusCard('Diproses', '$countProgress', Colors.blue),
                const SizedBox(width: 8),
                _buildStatusCard('Selesai', '$countDone', Colors.green),
              ],
            ),
            const SizedBox(height: 24),

            // LIST READ
            const Text(
              'Laporan Terakhir',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final item = reports[index];
                return GestureDetector(
                  onTap: () => _navigateToDetail(item),
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: item.imagePath != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(item.imagePath!),
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(Icons.image, size: 40),
                      title: Text(
                        item.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${item.location}\nStatus: ${item.status}',
                      ),
                      trailing: Text(
                        item.date,
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  Widget _buildStatusCard(String title, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(title, style: TextStyle(fontSize: 12, color: color)),
          ],
        ),
      ),
    );
  }
}
