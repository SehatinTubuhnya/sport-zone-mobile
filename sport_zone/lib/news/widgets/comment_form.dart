import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:sport_zone/news/screens/menu.dart';

class CommentForm extends StatefulWidget {
    const CommentForm({super.key});

    @override
    State<CommentForm> createState() => _CommentFormState();
}

class _CommentFormState extends State<CommentForm> {
    final _formKey = GlobalKey<FormState>();
    String _content = "";

    @override
    Widget build(BuildContext context) {
        final request = context.watch<CookieRequest>();
        return Container(
          color: Colors.white,
          // child: Padding(padding: EdgeInsetsGeometry.all(20),
            child: Form(
              key: _formKey,
              // filled: true,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    // === Content ===
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: "Tuliskan komentar anda ...",
                          labelText: "Komentar",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _content = value!;
                          });
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Isi berita tidak boleh kosong!";
                          }
                          return null;
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
                                          Text('Isi: $_content'),
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
                                              "http://localhost:8000/create-flutter/",
                                              jsonEncode({
                                                "content": _content,
                                              }),
                                            );
                                            if (context.mounted) {
                                              if (response['status'] == 'success') {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                  content: Text("News successfully saved!"),
                                                ));
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => MyHomePage()),
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
          // ),
        );
    }
}