import 'dart:io';

import 'package:flutter/material.dart';

import 'models/report.dart';
import 'screens/form_report_screen.dart';
import 'screens/detail_report_screen.dart';
import 'screens/login_screen.dart';

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF001FA1),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F8F8),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F8F8),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
            borderSide: BorderSide.none,
          ),
        ),
        cardTheme: const CardThemeData(
          color: Colors.white,
          elevation: 0,
          margin: EdgeInsets.zero,
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
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
  String _userName = 'Sian Ansari';
  String _studyProgram = 'Sistem Informasi';
  bool _notificationsEnabled = true;

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
        title: Text(
          _currentIndex == 0
              ? 'Dashboard'
              : _currentIndex == 1
              ? 'Riwayat Laporan'
              : 'Profil Saya',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            tooltip: 'Notifikasi',
            onPressed: () =>
                setState(() => _notificationsEnabled = !_notificationsEnabled),
            icon: Icon(
              _notificationsEnabled
                  ? Icons.notifications_none_rounded
                  : Icons.notifications_off_outlined,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _currentIndex == 0
          ? SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF001FA1), Color(0xFF0068BD)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'SELAMAT DATANG KEMBALI',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Bantu kampus jadi lebih nyaman hari ini.',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF001FA1),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // RINGKASAN STATUS
                  Row(
                    children: [
                      _buildStatusCard(
                        'Menunggu',
                        '$countPending',
                        Colors.orange,
                        Icons.schedule_rounded,
                      ),
                      const SizedBox(width: 8),
                      _buildStatusCard(
                        'Diproses',
                        '$countProgress',
                        Colors.blue,
                        Icons.sync_rounded,
                      ),
                      const SizedBox(width: 8),
                      _buildStatusCard(
                        'Selesai',
                        '$countDone',
                        Colors.green,
                        Icons.check_circle_outline_rounded,
                      ),
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
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
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
            )
          : _currentIndex == 1
          ? _buildHistory()
          : _buildProfile(),
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

  Widget _buildStatusCard(
    String title,
    String count,
    Color color,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 6),
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

  Widget _buildHistory() {
    return reports.isEmpty
        ? const Center(child: Text('Belum ada riwayat laporan.'))
        : ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('Pantau perkembangan laporan fasilitas kampusmu.'),
              const SizedBox(height: 16),
              ...reports.map(
                (report) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    onTap: () => _navigateToDetail(report),
                    leading: CircleAvatar(
                      backgroundColor: report.statusColor.withValues(
                        alpha: 0.15,
                      ),
                      child: Icon(Icons.assignment, color: report.statusColor),
                    ),
                    title: Text(report.title),
                    subtitle: Text('${report.location}\n${report.status}'),
                    isThreeLine: true,
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ),
              ),
            ],
          );
  }

  Widget _buildProfile() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const CircleAvatar(radius: 42, child: Icon(Icons.person, size: 48)),
        const SizedBox(height: 12),
        Center(
          child: Text(
            _userName,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        Center(child: Text('Mahasiswa • $_studyProgram')),
        const SizedBox(height: 24),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Ubah data diri'),
                subtitle: const Text('Perbarui nama dan program studi'),
                trailing: const Icon(Icons.chevron_right),
                onTap: _showEditProfileDialog,
              ),
              const Divider(height: 1),
              SwitchListTile(
                secondary: const Icon(Icons.notifications_none),
                title: const Text('Notifikasi'),
                value: _notificationsEnabled,
                onChanged: (value) =>
                    setState(() => _notificationsEnabled = value),
              ),
              const Divider(height: 1),
              const ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('Tentang SIGAP'),
                trailing: Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showEditProfileDialog() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return EditProfileDialog(
          initialName: _userName,
          initialStudy: _studyProgram,
          onSave: (newName, newStudy) {
            setState(() {
              _userName = newName;
              _studyProgram = newStudy;
            });
          },
        );
      },
    );
  }
}

class EditProfileDialog extends StatefulWidget {
  final String initialName;
  final String initialStudy;
  final Function(String name, String study) onSave;

  const EditProfileDialog({
    super.key,
    required this.initialName,
    required this.initialStudy,
    required this.onSave,
  });

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late TextEditingController _nameController;
  late TextEditingController _studyController;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Inisialisasi Controller saat dialog dibuka
    _nameController = TextEditingController(text: widget.initialName);
    _studyController = TextEditingController(text: widget.initialStudy);
  }

  @override
  void dispose() {
    // Controller dihancurkan secara aman sesuai lifecycle widget dialog
    _nameController.dispose();
    _studyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ubah data diri'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Nama lengkap'),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _studyController,
            decoration: const InputDecoration(labelText: 'Program studi'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () {
            final nameText = _nameController.text.trim();
            final studyText = _studyController.text.trim();

            if (nameText.isEmpty || studyText.isEmpty) {
              setState(() {
                _errorMessage = 'Data diri wajib diisi.';
              });
              return;
            }

            // Simpan perubahan ke parent widget
            widget.onSave(nameText, studyText);
            Navigator.pop(context);
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
