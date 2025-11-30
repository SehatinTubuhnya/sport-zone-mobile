import 'package:flutter/material.dart';
import 'package:sport_zone/news/models/news_entry.dart';
import 'package:sport_zone/news/models/comment.dart';
import 'package:sport_zone/news/widgets/comment_entry.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class CommentList extends StatefulWidget {
  final NewsEntry news;
  const CommentList({super.key, required this.news});

  @override
  State<CommentList> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  Future<List<Comment>> fetchComments(CookieRequest request) async {
    // TODO: Replace the URL with your app's URL and don't forget to add a trailing slash (/)!
    // To connect Android emulator with Django on localhost, use URL http://10.0.2.2/
    // If you using chrome,  use URL http://localhost:8000
    
    final response = await request.get('http://localhost:8000/articles/get-comment-by-id/${widget.news.pk}');
    // Decode response to json format
    var data = response;
    
    // Convert json data to NewsEntry objects
    List<Comment> listComments = [];
    for (var d in data) {
      if (d != null) {
        listComments.add(Comment.fromJson(d));
      }
    }
    return listComments;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return FutureBuilder (
      future: fetchComments(request),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Column(
            children: [
              Image.network(
                'https://cdn-icons-png.flaticon.com/512/4063/4063871.png',
                fit: BoxFit.cover
              ),
              Center(
                child: Text("Error: ${snapshot.error}")
              )
            ],
          );
        }

        // If data is returned but empty: []
        if (!snapshot.hasData || snapshot.data.isEmpty) {
          return  Center(
            child: Column(
              children: [
                Image.network(
                  'https://cdn-icons-png.flaticon.com/512/11696/11696730.png',
                  fit: BoxFit.cover
                ),
                Text(
                  "Belum ada komentar.",
                  style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                ),
              ],
            )
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (_, index) => CommentEntry(
            comment: snapshot.data![index],
          ),
        );
      },
    );
  }
}