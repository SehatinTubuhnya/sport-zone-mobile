import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sport_zone/products/models/products_entry.dart';

class EditProductDialog extends StatefulWidget {
  final Product product;

  const EditProductDialog({
    super.key,
    required this.product,
  });

  @override
  State<EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _thumbnailController;
  late final TextEditingController _descriptionController;

  late String _selectedCategory;
  late bool _isFeatured;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final p = widget.product;

    _nameController = TextEditingController(text: p.name);
    _priceController = TextEditingController(text: p.price.toString());
    _thumbnailController = TextEditingController(text: p.thumbnail ?? '');
    _descriptionController = TextEditingController(text: p.description ?? '');

    // category dari backend: 'apparel' / 'equipment' / 'ball'
    _selectedCategory = p.category.name.toLowerCase();
    _isFeatured = p.isFeatured ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _thumbnailController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Edit Produk",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _isSubmitting ? null : () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),

            // FORM
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label("Nama Produk"),
                  _textField(
                    controller: _nameController,
                    hint: "Masukkan nama produk",
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? "Nama wajib diisi" : null,
                  ),

                  _label("Harga (Rp)"),
                  _textField(
                    controller: _priceController,
                    hint: "Masukkan harga",
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return "Harga wajib diisi";
                      final parsed = int.tryParse(v.trim());
                      if (parsed == null) return "Harga harus angka";
                      if (parsed < 0) return "Harga tidak boleh negatif";
                      return null;
                    },
                  ),

                  _label("Kategori"),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: _decoration(),
                    items: const [
                      DropdownMenuItem(value: 'equipment', child: Text('Equipment')),
                      DropdownMenuItem(value: 'apparel', child: Text('Apparel')),
                      DropdownMenuItem(value: 'ball', child: Text('Ball')),
                    ],
                    onChanged: _isSubmitting
                        ? null
                        : (value) => setState(() => _selectedCategory = value!),
                  ),

                  _label("URL Thumbnail (Opsional)"),
                  _textField(
                    controller: _thumbnailController,
                    hint: "https://...",
                    keyboardType: TextInputType.url,
                  ),

                  _label("Deskripsi"),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: _decoration(hint: "Deskripsi produk"),
                  ),

                  const SizedBox(height: 8),

                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text("Featured"),
                    value: _isFeatured,
                    onChanged: _isSubmitting
                        ? null
                        : (value) => setState(() => _isFeatured = value ?? false),
                  ),
                ],
              ),
            ),

            const Divider(),

            // BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isSubmitting ? null : () => Navigator.pop(context),
                  child: const Text("Batal"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("Simpan"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final request = context.read<CookieRequest>();

      final url =
          "http://localhost:8000/products/api/products/${widget.product.id}/update/";

      final response = await request.post(url, {
        "name": _nameController.text.trim(),
        "price": _priceController.text.trim(),
        "category": _selectedCategory,
        "description": _descriptionController.text.trim(),
        "thumbnail": _thumbnailController.text.trim(),
        "is_featured": _isFeatured.toString(), // "true"/"false"
      });

      if (response["success"] == true) {
        if (!mounted) return;
        Navigator.pop(context, true); // ✅ return true buat refresh list
        return;
      }

      final msg = response["error"]?.toString() ?? "Gagal edit produk";
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // UI helpers
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: _decoration(hint: hint),
    );
  }

  InputDecoration _decoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      isDense: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
