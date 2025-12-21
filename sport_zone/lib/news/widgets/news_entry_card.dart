import 'package:flutter/material.dart';
import 'package:sport_zone/news/models/news_entry.dart';
import 'package:intl/intl.dart';
import 'package:sport_zone/news/screens/newslist_edit.dart';
import 'package:sport_zone/config.dart';
// import 'package:sport_zone/news/widgets/confirm_delete.dart';
import 'package:sport_zone/news/screens/news_entry_list.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'dart:convert';

class NewsEntryCard extends StatelessWidget {
  final NewsEntry news;
  final String currentUsername;
  final VoidCallback onTap;

  const NewsEntryCard({
    super.key,
    required this.news,
    required this.currentUsername,
    required this.onTap,
  });

  String getDate(DateTime date) {
    DateFormat formatter = DateFormat('dd MMM yyyy');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        elevation: 2,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- IMAGE --- stays fixed
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1.2,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    child: Image.network(
                      '$SPORTZONE_URL/articles/proxy-image/?url=${Uri.encodeComponent(news.fields.thumbnail)}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(color: Colors.grey[300]),
                    ),
                  ),
                ),

                if (news.fields.isFeatured)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    margin: const EdgeInsets.only(top: 6, left: 6),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: const Text(
                      'FEATURED',
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 6,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),

            Padding(
              padding: EdgeInsetsGeometry.only(
                left: 10,
                right: 10,
                top: 6,
                bottom: 6,
              ),
              child: Text(
                news.fields.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),

            // --- TEXT --- scrollable
            Expanded(
              child: Padding(
                padding: EdgeInsetsGeometry.only(
                  left: 10,
                  right: 10,
                  bottom: 5,
                ),
                child:
                    // SingleChildScrollView(
                    // padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    // child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          news.fields.category,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 10,
                          ),
                        ),

                        Text(
                          getDate(news.fields.createdAt),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(height: 5),

                        if (news.fields.username == currentUsername)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          NewsEditPage(news: news),
                                    ),
                                  ),
                                },
                                child: Text(
                                  "Edit",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),

                              InkWell(
                                onTap: () => {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.grey.shade100,
                                        title: Text('Konfirmasi delete'),
                                        content: Text(
                                          'Are you sure you want to delete this?',
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              backgroundColor:
                                                  Colors.blue.shade900,
                                              foregroundColor: Colors.white,
                                            ),
                                            child: const Text("Cancel"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),

                                          TextButton(
                                            style: TextButton.styleFrom(
                                              backgroundColor:
                                                  Colors.red.shade600,
                                              foregroundColor: Colors.white,
                                            ),
                                            child: const Text("OK"),
                                            onPressed: () async {
                                              final response = await request
                                                  .postJson(
                                                    '$SPORTZONE_URL/articles/delete-news-flutter/',
                                                    jsonEncode({
                                                      'news_id': news.pk,
                                                    }),
                                                  );
                                              if (context.mounted) {
                                                if (response['status'] ==
                                                    'success') {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        "News successfully deleted!",
                                                      ),
                                                    ),
                                                  );
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          NewsEntryListPage(),
                                                    ),
                                                  );
                                                } else {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        "Something went wrong, please try again.",
                                                      ),
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                },
                                child: Text(
                                  "Delete",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 10,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                // ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
