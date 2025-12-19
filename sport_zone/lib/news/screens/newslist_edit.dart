import 'package:flutter/material.dart';
import 'package:sport_zone/news/screens/news_entry_list.dart';

import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:sport_zone/news/models/news_entry.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class NewsEditPage extends StatefulWidget {
    final NewsEntry news;
    const NewsEditPage({super.key, required this.news});

    @override
    State<NewsEditPage> createState() => _NewsEditPageState();
}

class _NewsEditPageState extends State<NewsEditPage> {
    final _formKey = GlobalKey<FormState>();
    String _category = "Update"; // default
    bool _isFeatured = false; // default

    final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();
    final TextEditingController thumbnailController = TextEditingController();

    final List<String> _categories = [
      'Transfer',
      'Update',
      'Exclusive',
      'Match',
      'Rumor',
      'Analysis',
    ];

    @override
    void initState() {
      super.initState();
      // Initialize the state variable with the attribute's default value
      _category = widget.news.fields.category;
      _isFeatured = widget.news.fields.isFeatured;
      titleController.text = widget.news.fields.title;
      contentController.text = widget.news.fields.content;
      thumbnailController.text = widget.news.fields.thumbnail;
    }

    @override
    void dispose() {
      titleController.dispose();
      contentController.dispose();
      thumbnailController.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        final request = context.watch<CookieRequest>();
        return Scaffold(
          appBar: AppBar(
            title: Text(
                'Edit',
              ),
            
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  // === Title ===
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: "Judul Berita",
                        labelText: "Judul Berita",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Judul tidak boleh kosong!";
                        }
                        return null;
                      },
                    ),
                  ),

                  // === Content ===
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: contentController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: "Isi Berita",
                        labelText: "Isi Berita",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Isi berita tidak boleh kosong!";
                        }
                        return null;
                      },
                    ),
                  ),

                  // === Category ===
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Kategori",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      initialValue: _category,
                      items: _categories
                          .map((cat) => DropdownMenuItem(
                                value: cat,
                                child: Text(
                                    cat[0].toUpperCase() + cat.substring(1)),
                              ))
                          .toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _category = newValue!;
                        });
                      },
                    ),
                  ),

                  // === Thumbnail URL ===
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: thumbnailController,
                      decoration: InputDecoration(
                        hintText: "URL Thumbnail (opsional)",
                        labelText: "URL Thumbnail",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ),

                  // === Is Featured ===
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SwitchListTile(
                      title: const Text("Tandai sebagai Berita Unggulan"),
                      value: _isFeatured,
                      onChanged: (bool value) {
                        setState(() {
                          _isFeatured = value;
                        });
                      },
                    ),
                  ),

                  // === Tombol Simpan ===
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.indigo),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Berita berhasil disimpan!'),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Judul: ${titleController.text}'),
                                        Text('Isi: ${contentController.text}'),
                                        Text('Kategori: $_category'),
                                        Text('Thumbnail: ${thumbnailController.text}'),
                                        Text('Unggulan: ${_isFeatured ? "Ya" : "Tidak"}'),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text('OK'),
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          // TODO: Replace the URL with your app's URL
                                          // To connect Android emulator with Django on localhost, use URL http://10.0.2.2/
                                          // If you using chrome,  use URL http://localhost:8000
                                          
                                          final response = await request.postJson(
                                            "http://localhost:8000/articles/edit-news-flutter/",
                                            jsonEncode({
                                              "title": titleController.text,
                                              "content": contentController.text,
                                              "thumbnail": thumbnailController.text,
                                              "category": _category,
                                              "is_featured": _isFeatured,
                                              "news_id": widget.news.pk
                                            }),
                                          );
                                          if (context.mounted) {
                                            if (response['status'] == 'success') {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                content: Text("News successfully edited!"),
                                              ));
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => NewsEntryListPage()
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                content: Text("Something went wrong, please try again."),
                                              ));
                                            }
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: const Text(
                          "Simpan",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ),
          ),
        );
    }
}