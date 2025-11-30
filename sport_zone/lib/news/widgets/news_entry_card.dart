import 'package:flutter/material.dart';
import 'package:sport_zone/news/models/news_entry.dart';
import 'package:auto_size_text/auto_size_text.dart';

class NewsEntryCard extends StatelessWidget {
  final NewsEntry news;
  final VoidCallback onTap;

  const NewsEntryCard({
    super.key,
    required this.news,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- IMAGE --- stays fixed
            AspectRatio(
              aspectRatio: 2.7,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                child: Image.network(
                  'http://localhost:8000/articles/proxy-image/?url=${Uri.encodeComponent(news.fields.thumbnail)}',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: Colors.grey[300]),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsetsGeometry.only(left: 10, right: 10, top: 6), 
              child: AutoSizeText(
                news.fields.title,
                maxLines: 2,
                minFontSize: 12,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            // --- TEXT --- scrollable
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      news.fields.category,
                      maxLines: 1,
                      minFontSize: 8,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 6),
                    AutoSizeText(
                      news.fields.content,
                      maxLines: 10, // will scroll if content is long
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 6),
                    if (news.fields.isFeatured)
                      const AutoSizeText(
                        'FEATURED',
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
