import 'package:flutter/material.dart';

import 'login_page.dart';
import 'edit_profile_view.dart';
import 'history_view.dart';
import 'category_location_list_screen.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String name = 'Riyan Ansari Harahap';
  String study = 'S-1 Ilmu Komputer';
  String nim = '241401003';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil & Pengaturan',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE1E8E8)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 36,
                  backgroundColor: Color(0xFFD7F1ED),
                  child: Icon(
                    Icons.person_rounded,
                    size: 38,
                    color: Color(0xFF0F766E),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Mahasiswa • $study',
                        style: const TextStyle(color: Color(0xFF627D98)),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'NIM $nim',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF829AB1),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.verified_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Akun saya',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          _buildMenuTile(
            icon: Icons.person_outline_rounded,
            title: 'Ubah data diri',
            subtitle: 'Perbarui nama, program studi, dan foto profil',
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileView(
                    initialName: name,
                    initialStudy: study,
                  ),
                ),
              );
              if (result != null && result is Map) {
                if (!mounted) return;
                setState(() {
                  name = result['name'] ?? name;
                  study = result['study'] ?? study;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Perubahan profil berhasil disimpan')),
                );
              }
            },
          ),
          _buildMenuTile(
            icon: Icons.history_rounded,
            title: 'Riwayat laporan pribadi',
            subtitle: 'Lihat perkembangan laporan yang pernah dibuat',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryView()),
              );
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Master Data & Referensi',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          _buildMenuTile(
            icon: Icons.folder_shared_rounded,
            title: 'Kategori & Lokasi Gedung',
            subtitle: 'Kelola jenis fasilitas dan barang inventaris kampus yang dapat diinformasikan',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CategoryLocationListScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Sesi aplikasi',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          _buildMenuTile(
            icon: Icons.logout_rounded,
            title: 'Keluar dari akun',
            subtitle: 'Kembali ke halaman masuk SIGAP',
            color: const Color(0xFFB42318),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? color,
  }) {
    final foreground = color ?? const Color(0xFF102A43);
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: foreground.withValues(alpha: 0.1),
          child: Icon(icon, color: foreground),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w700, color: foreground),
        ),
        subtitle: Text(subtitle),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: color ?? const Color(0xFF829AB1),
        ),
        onTap: onTap,
      ),
    );
  }
}
