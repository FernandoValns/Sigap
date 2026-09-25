# SIGAP - Sistem Informasi Gangguan & Pengaduan Kerusakan Fasilitas Kampus

Aplikasi Mobile Flutter untuk pelaporan dan pengelolaan perbaikan fasilitas kampus.

---

## 🛠️ Setup & Persiapan
1. Pastikan **Flutter SDK** (`^3.13.2`+) dan emulator Android/iOS telah terinstal.
2. Buka terminal pada direktori proyek root.
3. Jalankan perintah untuk mengunduh semua dependensi (`image_picker`, material icons, dll.):
   ```bash
   get flutter pub get
   ```

---

## 🚀 Perintah Run (Menjalankan Aplikasi)
Untuk menjalankan aplikasi ke perangkat atau emulator yang terhubung, gunakan perintah:
```bash
flutter run
```
Atau jika menggunakan baris perintah khusus debug:
```bash
flutter run -d chrome
# atau di emulator Android
flutter run -d emulator
```

---

## 📊 Data Dummy (Mock Data)
Sistem ini dilengkapi dengan data simulasi operasional:
- **5 Kategori Fasilitas Referensi**: Elektronik & Audio Visual, Pendingin Ruangan (AC), Mebel Kelas, Sanitasi/Toilet, Jaringan & IT.
- **5 Lokasi Fakultas & Area Kampus**: Fakultas Ilmu Komputer (FIK), Fakultas Teknik (FT), Fakultas Ekonomi & Bisnis (FEB), Gedung Rektorat, Perpustakaan Pusat & PKM.
- **20 Record Laporan Kerusakan**: Data riwayat aduan kerusakan fasilitas kampus yang berelasi dengan `kategoriId` dan `lokasiId`.

---

## 🔄 Skenario Interaksi & Simulasi State
1. **Skenario Pelaporan**:
   - Pengguna masuk (Login) $\rightarrow$ Beranda (`DashboardView`) $\rightarrow$ Mengisi form pengaduan (Judul, Lokasi Fakultas, Kategori, Urgensi, Foto Bukti) $\rightarrow$ Laporan terkirim dan otomatis tersinkron ke **Riwayat** (`HistoryView`).
2. **Skenario Pengujian State (Test State di Profil)**:
   - Pengguna masuk ke tab **Profil** $\rightarrow$ Memilih menu **"Uji Simulasi State (Test State)"** $\rightarrow$ Menguji tombol **Loading** (indikator pemuatan), **Kosong** (empty state dengan petunjuk), dan **Gagal** (error state dengan tombol "Coba Lagi").
3. **Skenario Master Data & Aksi Destruktif**:
   - Mengelola kategori dan gedung, memvalidasi form input (minimal 5 field, pencegahan *double submit*), serta menguji **dialog konfirmasi hapus**.
