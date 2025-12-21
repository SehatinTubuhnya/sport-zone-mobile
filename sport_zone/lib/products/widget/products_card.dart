import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:sport_zone/products/models/products_entry.dart';
import 'package:sport_zone/products/widget/edit_product_dialog.dart';

class ProductCard extends StatelessWidget {
  final Product data;
  final bool isOwner;

  /// dipanggil setelah edit berhasil (buat refresh list)
  final VoidCallback? onChanged;

  const ProductCard({
    super.key,
    required this.data,
    required this.isOwner,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

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
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    (data.thumbnail == null || data.thumbnail!.isEmpty)
                        ? 'https://via.placeholder.com/600x600?text=No+Image'
                        : data.thumbnail!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey.shade200,
                      child: const Center(child: Icon(Icons.image_not_supported)),
                    ),
                  ),
                ),

                // Badge Kategori
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      productCategoryToString(data.category),
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
                  data.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  currencyFormatter.format(data.price),
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),

                Row(
                  children: [
                    const Icon(Icons.store, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        "Seller ID: ${data.sellerId ?? 'Unknown'}",
                        style:
                            const TextStyle(fontSize: 11, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                isOwner
                    ? Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () async {
                                final result = await showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) =>
                                      EditProductDialog(product: data),
                                );

                                if (result == true) {
                                  onChanged?.call(); // refresh list
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 30),
                                side: BorderSide(color: Colors.grey.shade300),
                              ),
                              child: const Text(
                                'Edit',
                                style: TextStyle(
                                    fontSize: 11, color: Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                // delete belakangan
                              },
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 30),
                                side: const BorderSide(color: Colors.red),
                                backgroundColor: Colors.red.shade50,
                              ),
                              child: const Text(
                                'Hapus',
                                style:
                                    TextStyle(fontSize: 11, color: Colors.red),
                              ),
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
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                          ),
                          child: const Text('Beli',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12)),
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

/// helper kategori yang aman untuk String / enum / nullable
String productCategoryToString(dynamic category) {
  if (category == null) return '';
  if (category is String) {
    switch (category.toLowerCase()) {
      case 'equipment':
        return 'equipment';
      case 'apparel':
        return 'apparel';
      case 'ball':
        return 'ball';
      default:
        return category;
    }
  }

  final c = category.toString().split('.').last.toLowerCase();
  switch (c) {
    case 'equipment':
      return 'equipment';
    case 'apparel':
      return 'apparel';
    case 'ball':
      return 'ball';
    default:
      return c;
  }
}
