import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductList extends StatefulWidget {
  final bool isSellerOrAdmin; // Variabel untuk mengecek hak akses user

  const ProductList({
    super.key,
    this.isSellerOrAdmin = true // Default true untuk demo tombol Tambah Produk
  });

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  // State untuk Filter & Sort
  String _selectedSort = 'latest';
  final TextEditingController _searchController = TextEditingController();

  // Dummy Data (Sesuai main-product.html)
  final List<Map<String, dynamic>> _products = [
    {
      'id': '1',
      'name': 'Jersey Home 2024',
      'price': 750000,
      'seller': 'Toko Resmi',
      'image': 'https://placehold.co/400x400/png?text=Jersey',
      'category': 'Apparel'
    },
    {
      'id': '2',
      'name': 'Sepatu Bola Pro',
      'price': 1200000,
      'seller': 'SportStation',
      'image': 'https://placehold.co/400x400/png?text=Shoes',
      'category': 'Equipment'
    },
    {
      'id': '3',
      'name': 'Bola Piala Dunia',
      'price': 500000,
      'seller': 'Toko Resmi',
      'image': 'https://placehold.co/400x400/png?text=Ball',
      'category': 'Ball'
    },
    {
      'id': '4',
      'name': 'Dumbbell 5kg',
      'price': 150000,
      'seller': 'GymMaster',
      'image': 'https://placehold.co/400x400/png?text=Dumbbell',
      'category': 'Equipment'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DAFTAR PRODUK'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {},
          )
        ],
      ),
      // Tombol Tambah Produk (Hanya untuk Admin/Seller)
      floatingActionButton: widget.isSellerOrAdmin
          ? FloatingActionButton.extended(
        onPressed: () {
          // Navigasi ke Form Tambah Produk
          _showAddProductModal(context);
        },
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Jual Produk'),
      )
          : null,
      body: Column(
        children: [
          // 1. Search Bar & Filter Row
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            color: Colors.white,
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari produk...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Filter & Sort Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showFilterBottomSheet(context),
                        icon: const Icon(Icons.filter_list, size: 18),
                        label: const Text('Filter'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showSortModal(context),
                        icon: const Icon(Icons.sort, size: 18),
                        label: const Text('Urutkan'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 2. Product Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7, // Aspek rasio kartu (Tinggi > Lebar)
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                return ProductCard(
                    data: _products[index],
                    isOwner: widget.isSellerOrAdmin // Logic: Jika admin/owner, bisa edit/delete
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // === MODAL FILTER (Adaptasi dari Sidebar Filter HTML) ===
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Container(width: 40, height: 4, color: Colors.grey.shade300)),
                  const SizedBox(height: 20),
                  const Text('Filter Produk', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),

                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        // Kategori Checkbox
                        const Text('Kategori', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: ['Apparel', 'Equipment', 'Ball'].map((cat) {
                            return FilterChip(
                              label: Text(cat),
                              selected: false, // Logika state selection nanti disini
                              onSelected: (bool selected) {},
                              checkmarkColor: Colors.white,
                              selectedColor: Colors.black,
                              labelStyle: const TextStyle(color: Colors.black),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 24),

                        // Rentang Harga Input
                        const Text('Rentang Harga (Rp)', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'Min',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text('-'),
                            ),
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'Max',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Tombol Terapkan
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('TERAPKAN FILTER'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // === MODAL SORT ===
  void _showSortModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Urutkan Berdasarkan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            ListTile(
              title: const Text('Terbaru'),
              trailing: _selectedSort == 'latest' ? const Icon(Icons.check, color: Colors.black) : null,
              onTap: () {
                setState(() => _selectedSort = 'latest');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Harga Terendah'),
              trailing: _selectedSort == 'price_asc' ? const Icon(Icons.check, color: Colors.black) : null,
              onTap: () {
                setState(() => _selectedSort = 'price_asc');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Harga Tertinggi'),
              trailing: _selectedSort == 'price_desc' ? const Icon(Icons.check, color: Colors.black) : null,
              onTap: () {
                setState(() => _selectedSort = 'price_desc');
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  // === MODAL TAMBAH PRODUK (Mockup Form) ===
  void _showAddProductModal(BuildContext context) {
    // Bisa navigate ke halaman baru atau showModalFullScreen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Produk Baru'),
        content: const Text('Form tambah produk akan muncul di sini (Nama, Harga, Kategori, Foto).'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Simpan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))
          ),
        ],
      ),
    );
  }
}

// === WIDGET CARD PRODUK ===
class ProductCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isOwner;

  const ProductCard({super.key, required this.data, required this.isOwner});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Produk
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    data['image'],
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(color: Colors.grey.shade200, child: const Center(child: Icon(Icons.image_not_supported))),
                  ),
                ),
                // Badge Kategori
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      data['category'],
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Info Produk
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  currencyFormatter.format(data['price']),
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),

                // Seller Info
                Row(
                  children: [
                    const Icon(Icons.store, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        data['seller'],
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Tombol Aksi (Jika Owner/Admin: Edit/Delete, Jika User: Beli)
                isOwner
                    ? Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 30),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        child: const Text('Edit', style: TextStyle(fontSize: 11, color: Colors.black)),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 30),
                          side: const BorderSide(color: Colors.red),
                          backgroundColor: Colors.red.shade50,
                        ),
                        child: const Text('Hapus', style: TextStyle(fontSize: 11, color: Colors.red)),
                      ),
                    ),
                  ],
                )
                    : SizedBox(
                  width: double.infinity,
                  height: 32,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    child: const Text('Beli', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
