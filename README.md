SIGAP - Sistem Informasi Gangguan & Pengaduan Kerusakan Fasilitas Kampus
Aplikasi Mobile Flutter untuk pelaporan dan pengelolaan perbaikan fasilitas kampus (Kelompok QRF).
👥 Pembagian Kontribusi Tim & Pembagian Tugas (Kontributor)
No
Nama Anggota
Peran & Modul Utama
Tanggung Jawab & Layar yang Dibuat
1
Rian
Anggota 1: UI/UX & Tampilan Utama
• Landing Page / Dashboard (Ringkasan & Statistik)
• Halaman Login / SSO Kampus
• Halaman Profil & Pengaturan, Ubah Data Diri
• Layout Utama (MainLayout dengan Bottom Navigation)
2
Qisthan
Anggota 2: Developer Modul CRUD 1 (Main Module)
• Pengelolaan Laporan Kerusakan Utama
• Layar Daftar Laporan & Filter Status
• Layar Form Pelaporan (Upload Foto & Urgensi)
• Layar Detail Laporan & Timeline Penanganan
3
Fernando
Anggota 3: Developer Modul CRUD 2 & Mock Data
• Pengelolaan Kategori Barang & Lokasi Gedung (Reference Module)
• 20 Record Laporan Kerusakan & 5 Record Referensi (Relasi ID)
• Layar Daftar & Detail Kategori/Gedung
• Layar Form Master Data, Simulasi State (Loading/Kosong/Gagal)
🔄 3 Alur Pengguna Utama (User Flow)
1.
Alur Pelaporan Barang Rusak:
◦
Pengguna masuk (Login) $\rightarrow$ Membuka Dashboard $\rightarrow$ Mengetuk "Buat laporan baru" $\rightarrow$ Mengisi form (Judul, Lokasi Fakultas, Kategori, Urgensi, Foto Bukti) $\rightarrow$ Laporan terkirim dan masuk ke sistem.
2.
Alur Mengecek Status Tindak Lanjut Laporan:
◦
Pengguna membuka tab Riwayat (HistoryView) atau melihat laporan terbaru di Beranda $\rightarrow$ Memantau status laporan (Diajukan, Menunggu, Diproses, Selesai).
3.
Alur Pembaruan Profil & Riwayat Laporan:
◦
Pengguna membuka menu Profil $\rightarrow$ Memilih "Ubah data diri" (EditProfileView) untuk memperbarui nama dan program studi $\rightarrow$ Melihat daftar riwayat laporan pribadi.
📊 Data Dummy & Simulasi (Mock Data & Reference Module)
•
5 Record Referensi Kategori Fasilitas: Elektronik & Audio Visual, Pendingin Ruangan (AC), Mebel Kelas, Sanitasi/Toilet, Jaringan & IT.
•
5 Record Referensi Lokasi Fakultas & Area Kampus: Fakultas Ilmu Komputer (FIK), Fakultas Teknik (FT), Fakultas Ekonomi & Bisnis (FEB), Gedung Rektorat, Perpustakaan Pusat & PKM.
•
20 Record Utama Laporan Kerusakan: Data simulasi kerusakan infrastruktur yang terhubung dengan kategoriId dan lokasiId.
🚀 Panduan Setup & Perintah Run
1.
Prasyarat: Flutter SDK (^3.13.2+) dan Emulator/Android Studio.
2.
Instal Dependensi:
flutter pub get
3.
Menjalankan Aplikasi:
flutter run
