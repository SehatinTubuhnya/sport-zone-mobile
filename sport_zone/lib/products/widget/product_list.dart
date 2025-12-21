import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../models/products_entry.dart';
import 'products_card.dart';
import 'add_product_dialog.dart';
import 'edit_product_dialog.dart';

class ProductList extends StatefulWidget {
  final bool isSellerOrAdmin;

  const ProductList({super.key, this.isSellerOrAdmin = true});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<Product> _products = [];

  Future<void> fetchProducts(CookieRequest request) async {
    final res = await request.get('http://localhost:8000/products/json/');
    setState(() {
      _products = (res['products'] as List)
          .map((e) => Product.fromJson(e))
          .toList();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchProducts(context.read<CookieRequest>());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("DAFTAR PRODUK")),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await showDialog<Product>(
            context: context,
            builder: (_) => const AddProductDialog(),
          );

          if (result != null) {
            setState(() => _products.insert(0, result));
          }
        },
        icon: const Icon(Icons.add),
        label: const Text("Jual Produk"),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _products.length,
        itemBuilder: (_, i) => ProductCard(
          data: _products[i],
          isOwner: widget.isSellerOrAdmin,
          onDelete: () {
            setState(() => _products.removeAt(i));
          },
          onEdit: () async {
            final updated = await showDialog<Product>(
              context: context,
              builder: (_) => EditProductDialog(product: _products[i]),
            );
            if (updated != null) {
              setState(() => _products[i] = updated);
            }
          },
        ),
      ),
    );
  }
}
