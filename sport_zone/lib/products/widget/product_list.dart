import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import 'package:sport_zone/products/models/products_entry.dart';
import 'package:sport_zone/products/widget/products_card.dart';
import 'package:sport_zone/products/widget/add_product_dialog.dart';

class ProductList extends StatefulWidget {
  final bool isSellerOrAdmin;

  const ProductList({
    super.key,
    this.isSellerOrAdmin = true,
  });

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final TextEditingController _searchController = TextEditingController();

  late Future<List<Product>> _productsFuture;

  // ================= FETCH DATA =================
  Future<List<Product>> fetchProducts(CookieRequest request) async {
    final response =
        await request.get('http://localhost:8000/products/json/');

    return _mapProducts(response['products']);
  }

  List<Product> _mapProducts(List<dynamic> list) {
    return List<Product>.from(
      list.map((x) => Product.fromJson(x)),
    );
  }

  // ================= INIT =================
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // fetch hanya sekali saat widget muncul
    if (!mounted) return;

    final request = context.read<CookieRequest>();
    _productsFuture = fetchProducts(request);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DAFTAR PRODUK'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {},
          ),
        ],
      ),

      floatingActionButton: widget.isSellerOrAdmin
          ? FloatingActionButton.extended(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text('Jual Produk'),
              onPressed: () => _showAddProductModal(context),
            )
          : null,

      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          // ===== LOADING =====
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ===== ERROR =====
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Terjadi kesalahan:\n${snapshot.error}",
                textAlign: TextAlign.center,
              ),
            );
          }

          // ===== EMPTY =====
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada produk",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final products = snapshot.data!;

          return Column(
            children: [
              // ===== SEARCH BAR (UI SAJA, API BELUM) =====
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari produk...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // ===== GRID PRODUK =====
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return ProductCard(
                      data: products[index],
                      isOwner: widget.isSellerOrAdmin,
                      onChanged: () {
                        final request = context.read<CookieRequest>();
                        setState(() {
                          _productsFuture = fetchProducts(request);
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ================= MODAL TAMBAH PRODUK =================
  Future<void> _showAddProductModal(BuildContext context) async {
    final result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AddProductDialog(),
    );

    // 🔥 REFRESH LIST SETELAH TAMBAH PRODUK
    if (result == true && mounted) {
      final request = context.read<CookieRequest>();
      setState(() {
        _productsFuture = fetchProducts(request);
      });
    }
  }
}
