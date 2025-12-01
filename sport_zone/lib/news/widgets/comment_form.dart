import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:sport_zone/news/screens/menu.dart';

class CommentForm extends StatefulWidget {
    final newsId;
    const CommentForm({super.key, required this.newsId});

    @override
    State<CommentForm> createState() => _CommentFormState();
}

class _CommentFormState extends State<CommentForm> {
    final TextEditingController _controller = TextEditingController();
    bool isFocused = false;
    String _content = "";

    Future<void> _submitComment(CookieRequest request) async {                     
        final response = await request.postJson(
          "http://localhost:8000/articles/create-comment-flutter/",
          jsonEncode({
            "news_id": widget.newsId,
            "content": _content,
          }),
        );
        if (context.mounted) {
          if (response['status'] == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Comment successfully added!"),
              )
            );

            setState(() {
              isFocused = false;
              _controller.clear();
              _content = "";
            });

          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Something went wrong, please try again."
                ),
              )
            );
          }
        }
    }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

    @override
    Widget build(BuildContext context) {
        final request = context.watch<CookieRequest>();
        return Container(
          color: Colors.white,
          // child: Padding(padding: EdgeInsetsGeometry.all(20),
            child:  
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    // === Content ===
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _controller,
                        onTap: () => setState(() => isFocused = true),
                        decoration: InputDecoration(
                          hintText: "Tuliskan komentar anda ...",
                          border: InputBorder.none
                        ),
                        maxLines: isFocused? 3 : 1,
                        onChanged: (value) => setState(() => _content = value),
                      ),
                    ),

                    if (isFocused) 
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                isFocused = false;
                                _controller.clear();
                                _content = "";
                              });
                            }, 
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: _content.trim().isEmpty 
                              ? null 
                              : () => _submitComment(request),
                            child: const Text("Comment"),
                          ),
                        ],
                      ),
                    
                  ],
                )
              ),
        );
    }
}