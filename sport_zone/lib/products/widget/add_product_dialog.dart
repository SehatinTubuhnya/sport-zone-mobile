import 'package:flutter/material.dart';
import '../models/products_entry.dart';

class AddProductDialog extends StatefulWidget {
  const AddProductDialog({super.key});

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final thumbnailController = TextEditingController();
  final descController = TextEditingController();

  String category = "equipment";
  bool featured = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: 600,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Tambah Produk Baru",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                _input("Nama Produk", nameController),
                _input("Harga (Rp)", priceController, isNumber: true),

                const SizedBox(height: 12),
                const Text("Kategori"),
                DropdownButtonFormField<String>(
                  value: category,
                  items: const [
                    DropdownMenuItem(value: "equipment", child: Text("Equipment")),
                    DropdownMenuItem(value: "apparel", child: Text("Apparel")),
                  ],
                  onChanged: (v) => setState(() => category = v!),
                ),

                _input("URL Thumbnail (opsional)", thumbnailController),
                _input("Deskripsi", descController, maxLines: 3),

                CheckboxListTile(
                  value: featured,
                  onChanged: (v) => setState(() => featured = v!),
                  title: const Text("Featured"),
                  contentPadding: EdgeInsets.zero,
                ),

                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Batal"),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        final product = Product(
                          id: DateTime.now().millisecondsSinceEpoch,
                          name: nameController.text,
                          price: int.parse(priceController.text),
                          category: category,
                          description: descController.text,
                          thumbnail: thumbnailController.text.isEmpty
                              ? null
                              : thumbnailController.text,
                          isFeatured: featured,
                          sellerId: 1,
                        );
                        Navigator.pop(context, product);
                      },
                      child: const Text("Simpan"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _input(String label, TextEditingController c,
      {bool isNumber = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        maxLines: maxLines,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
