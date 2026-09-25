import 'package:flutter/material.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Riwayat Laporan',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          const Text(
            'Pantau progres laporanmu',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          const Text(
            'Semua laporan yang pernah kamu kirim akan muncul di sini.',
            style: TextStyle(color: Color(0xFF627D98)),
          ),
          const SizedBox(height: 20),
          _buildHistoryCard(
            'AC Rusak & Bocor',
            'Gedung B - Ruang 204',
            'Menunggu',
            Colors.orange,
            '17 Sep 2026',
          ),
          const SizedBox(height: 12),
          _buildHistoryCard(
            'Proyektor Redup',
            'Lab Komputer 3',
            'Diproses',
            Colors.blue,
            '15 Sep 2026',
          ),
          const SizedBox(height: 12),
          _buildHistoryCard(
            'Keran Air Toilet Patah',
            'Gedung A - Lantai 1',
            'Selesai',
            Colors.green,
            '10 Sep 2026',
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(
    String title,
    String location,
    String status,
    Color color,
    String date,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.image, color: Colors.grey[500]),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(location, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Text(date, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onTap: () {},
      ),
    );
  }
}
