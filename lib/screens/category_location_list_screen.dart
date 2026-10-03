import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../models/location_model.dart';
import '../data/mock_data.dart';
import 'category_location_form_screen.dart';

class CategoryLocationListScreen extends StatefulWidget {
  const CategoryLocationListScreen({super.key});

  @override
  State<CategoryLocationListScreen> createState() =>
      _CategoryLocationListScreenState();
}

class _CategoryLocationListScreenState
    extends State<CategoryLocationListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<CategoryModel> categories = MockData.categories;
  List<LocationModel> locations = MockData.locations;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _navigateToAdd(bool isCategory) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryLocationFormScreen(isCategory: isCategory),
      ),
    );

    if (result != null) {
      setState(() {
        if (isCategory && result is CategoryModel) {
          categories.add(result);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kategori baru berhasil ditambahkan')),
          );
        } else if (!isCategory && result is LocationModel) {
          locations.add(result);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lokasi gedung baru berhasil ditambahkan')),
          );
        }
      });
    }
  }

  void _navigateToEditCategory(CategoryModel cat) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CategoryLocationFormScreen(category: cat, isCategory: true),
      ),
    );

    if (result != null && result is CategoryModel) {
      setState(() {
        final index = categories.indexWhere((c) => c.id == cat.id);
        if (index != -1) {
          categories[index] = result;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kategori berhasil diperbarui')),
          );
        }
      });
    }
  }

  void _navigateToEditLocation(LocationModel loc) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CategoryLocationFormScreen(location: loc, isCategory: false),
      ),
    );

    if (result != null && result is LocationModel) {
      setState(() {
        final index = locations.indexWhere((l) => l.id == loc.id);
        if (index != -1) {
          locations[index] = result;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lokasi gedung berhasil diperbarui')),
          );
        }
      });
    }
  }

  void _showCategoryDetail(CategoryModel cat) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.category_rounded, color: Color(0xFF0F766E)),
            const SizedBox(width: 10),
            Expanded(child: Text(cat.name, style: const TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Kode & ID: ${cat.code} (${cat.id})',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F766E))),
              const SizedBox(height: 10),
              Text('Jenis Fasilitas: ${cat.type}', style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              const Text('Deskripsi:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(cat.description),
              const SizedBox(height: 10),
              const Text('Catatan Referensi (Field 5):', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(cat.referenceNote, style: const TextStyle(color: Color(0xFF627D98))),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text('Status: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  Chip(
                    label: Text(cat.isActive ? 'Aktif' : 'Nonaktif', style: const TextStyle(color: Colors.white, fontSize: 11)),
                    backgroundColor: cat.isActive ? Colors.green : Colors.red,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _navigateToEditCategory(cat);
            },
            icon: const Icon(Icons.edit, size: 16),
            label: const Text('Edit'),
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFF0F766E)),
          ),
        ],
      ),
    );
  }

  void _showLocationDetail(LocationModel loc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.apartment_rounded, color: Color(0xFF0F766E)),
            const SizedBox(width: 10),
            Expanded(child: Text(loc.name, style: const TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Kode & ID: ${loc.code} (${loc.id})',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F766E))),
              const SizedBox(height: 10),
              Text('Zona / Lantai: ${loc.zoneOrFloor}', style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              Text('Penanggung Jawab: ${loc.pic}', style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              const Text('Catatan Referensi (Field 5):', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(loc.referenceNote, style: const TextStyle(color: Color(0xFF627D98))),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text('Status: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  Chip(
                    label: Text(loc.isActive ? 'Aktif' : 'Nonaktif', style: const TextStyle(color: Colors.white, fontSize: 11)),
                    backgroundColor: loc.isActive ? Colors.green : Colors.red,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _navigateToEditLocation(loc);
            },
            icon: const Icon(Icons.edit, size: 16),
            label: const Text('Edit'),
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFF0F766E)),
          ),
        ],
      ),
    );
  }

  void _deleteCategory(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Kategori'),
        content: const Text('Apakah Anda yakin ingin menghapus kategori fasilitas ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                categories.removeWhere((c) => c.id == id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Kategori berhasil dihapus')),
              );
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _deleteLocation(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Lokasi Gedung'),
        content: const Text('Apakah Anda yakin ingin menghapus lokasi gedung ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                locations.removeWhere((l) => l.id == id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Lokasi gedung berhasil dihapus')),
              );
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Master Data & Referensi',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF0F766E),
          unselectedLabelColor: const Color(0xFF627D98),
          indicatorColor: const Color(0xFF0F766E),
          tabs: const [
            Tab(text: 'Kategori Fasilitas', icon: Icon(Icons.category_outlined)),
            Tab(text: 'Lokasi Gedung', icon: Icon(Icons.apartment_outlined)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Kategori Fasilitas
          ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
            children: [
              const Text(
                'Daftar Kategori Fasilitas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              const Text(
                'Kelola jenis fasilitas dan barang inventaris kampus yang dapat dilaporkan.',
                style: TextStyle(color: Color(0xFF627D98)),
              ),
              const SizedBox(height: 16),
              ...categories.map((cat) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD7F1ED),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.category_rounded, color: Color(0xFF0F766E)),
                        ),
                        title: Text(
                          cat.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('Jenis: ${cat.type} • ${cat.code}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 2),
                            Text(cat.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: Color(0xFF627D98))),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, color: Color(0xFF0F766E), size: 20),
                              onPressed: () => _navigateToEditCategory(cat),
                              tooltip: 'Edit Kategori',
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Color(0xFFB42318), size: 20),
                              onPressed: () => _deleteCategory(cat.id),
                              tooltip: 'Hapus Kategori',
                            ),
                          ],
                        ),
                        onTap: () => _showCategoryDetail(cat),
                      ),
                    ),
                  )),
            ],
          ),
          // Tab 2: Lokasi Gedung
          ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
            children: [
              const Text(
                'Daftar Lokasi Gedung Kampus',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              const Text(
                'Kelola master data gedung, fakultas, dan area lingkungan kampus.',
                style: TextStyle(color: Color(0xFF627D98)),
              ),
              const SizedBox(height: 16),
              ...locations.map((loc) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD7F1ED),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.apartment_rounded, color: Color(0xFF0F766E)),
                        ),
                        title: Text(
                          loc.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('Zona: ${loc.zoneOrFloor} • ${loc.code}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 2),
                            Text('PJ: ${loc.pic}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: Color(0xFF627D98))),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, color: Color(0xFF0F766E), size: 20),
                              onPressed: () => _navigateToEditLocation(loc),
                              tooltip: 'Edit Lokasi',
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Color(0xFFB42318), size: 20),
                              onPressed: () => _deleteLocation(loc.id),
                              tooltip: 'Hapus Lokasi',
                            ),
                          ],
                        ),
                        onTap: () => _showLocationDetail(loc),
                      ),
                    ),
                  )),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final isCategoryTab = _tabController.index == 0;
          _navigateToAdd(isCategoryTab);
        },
        backgroundColor: const Color(0xFF0F766E),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(_tabController.index == 0 ? 'Tambah Kategori' : 'Tambah Lokasi'),
      ),
    );
  }
}
