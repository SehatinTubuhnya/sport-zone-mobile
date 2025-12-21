import 'package:flutter/material.dart';
import '../models/products_entry.dart';

class EditProductDialog extends StatefulWidget {
  final Product product;
  const EditProductDialog({super.key, required this.product});

  @override
  State<EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  late TextEditingController name;
  late TextEditingController price;
  late TextEditingController thumbnail;
  late TextEditingController desc;
  late String category;
  late bool featured;

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.product.name);
    price = TextEditingController(text: widget.product.price.toString());
    thumbnail = TextEditingController(text: widget.product.thumbnail ?? "");
    desc = TextEditingController(text: widget.product.description);
    category = widget.product.category;
    featured = widget.product.isFeatured;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: 600,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Edit Produk",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              _input("Nama Produk", name),
              _input("Harga (Rp)", price, isNumber: true),

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

              _input("URL Thumbnail", thumbnail),
              _input("Deskripsi", desc, maxLines: 3),

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
                      Navigator.pop(
                        context,
                        Product(
                          id: widget.product.id,
                          name: name.text,
                          price: int.parse(price.text),
                          category: category,
                          description: desc.text,
                          thumbnail: thumbnail.text.isEmpty ? null : thumbnail.text,
                          isFeatured: featured,
                          sellerId: widget.product.sellerId,
                        ),
                      );
                    },
                    child: const Text("Simpan"),
                  ),
                ],
              )
            ],
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
