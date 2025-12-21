import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class AddProductDialog extends StatefulWidget {
  const AddProductDialog({super.key});

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _thumbnailController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedCategory = 'Equipment';
  bool _isFeatured = false;
  bool _isLoading = false;

  final List<String> categories = [
    'Apparel',
    'Equipment',
    'Ball',
  ];

  void _submit() async {
  if (!_formKey.currentState!.validate()) return;

  final request = context.read<CookieRequest>();

  final response = await request.post(
    'http://localhost:8000/products/api/products/create/',
    {
      'name': _nameController.text,
      'price': _priceController.text,
      'category': _selectedCategory, // equipment / apparel / ball
      'description': _descriptionController.text,
      'thumbnail': _thumbnailController.text,
      'is_featured': _isFeatured.toString(),
    },
  );

  if (response['success'] == true) {
    Navigator.pop(context, true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Produk berhasil ditambahkan')),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response['error'] ?? 'Gagal')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tambah Produk Baru',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                _buildTextField('Nama Produk', _nameController),
                _buildTextField(
                  'Harga (Rp)',
                  _priceController,
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 12),
                const Text('Kategori'),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: categories
                      .map((c) =>
                          DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _selectedCategory = value!),
                ),

                _buildTextField(
                    'URL Thumbnail (opsional)', _thumbnailController),
                _buildTextField(
                  'Deskripsi',
                  _descriptionController,
                  maxLines: 3,
                ),

                CheckboxListTile(
                  value: _isFeatured,
                  onChanged: (value) =>
                      setState(() => _isFeatured = value!),
                  title: const Text('Featured'),
                  controlAffinity: ListTileControlAffinity.leading,
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed:
                          _isLoading ? null : () => Navigator.pop(context),
                      child: const Text('Batal'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Simpan'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: (value) =>
            value == null || value.isEmpty ? 'Wajib diisi' : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
