import 'package:flutter/material.dart';
import 'package:sport_zone/news/models/news_entry.dart';

// class NewsEntryCard extends StatelessWidget {
//   final NewsEntry news;
//   final VoidCallback onTap;

//   const NewsEntryCard({
//     super.key,
//     required this.news,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       child: InkWell(
//         onTap: onTap,
//         child: Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8.0),
//             side: BorderSide(color: Colors.grey.shade300),
//           ),
//           elevation: 2,
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Thumbnail
//                 Expanded(
//                   flex: 5,
//                   child: AspectRatio(
//                     aspectRatio: 3,
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(6),
//                       child: Image.network(
//                         'http://localhost:8000/articles/proxy-image/?url=${Uri.encodeComponent(news.fields.thumbnail)}',
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) => Container(
//                           color: Colors.grey[300],
//                           child: const Center(child: Icon(Icons.broken_image)),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
                
//                 Expanded(
//                   flex: 5,
//                   child: const SizedBox(height: 8),
//                 ),
                

//                 // Title
//                 Expanded(
//                   flex: 5,
//                   child: Text(
//                     news.fields.title,
//                     style: const TextStyle(
//                       fontSize: 18.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
                
//                 Expanded(
//                   flex: 5,
//                   child: const SizedBox(height: 6),
//                 ),

//                 // Category
//                 Expanded(
//                 flex: 5,
//                 child: Text('Category: ${news.fields.category}'),
//                 ),

//                 Expanded(
//                   flex: 5,
//                   child: const SizedBox(height: 6),
//                 ),
                
//                 // Content preview
//                 Expanded(
//                   flex: 5,
//                   child: Text(
//                     news.fields.content.length > 100
//                         ? '${news.fields.content.substring(0, 100)}...'
//                         : news.fields.content,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(color: Colors.black54),
//                   ),
//                 ),
                
//                 Expanded(
//                   flex: 5,
//                   child: const SizedBox(height: 6),
//                 ),

//                 // Featured indicator
//                 if (news.fields.isFeatured)
//                   Expanded(
//                     flex: 5,
//                     child: const Text(
//                         'Featured',
//                         style: TextStyle(
//                           color: Colors.amber,
//                           fontWeight: FontWeight.bold
//                         ),
//                       ),
//                     ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              /// --- IMAGE ---
              AspectRatio(
                aspectRatio: 2.7, // slightly shorter for nicer balance
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    'http://localhost:8000/articles/proxy-image/?url=${Uri.encodeComponent(news.fields.thumbnail)}',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      child: const Center(child: Icon(Icons.broken_image)),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 6),

              /// --- TITLE ---
              Text(
                news.fields.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,          // 🔥 smaller text
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              /// --- CATEGORY ---
              Text(
                news.fields.category,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 8,          // 🔥 smaller
                  color: Colors.grey[700],
                ),
              ),

              const SizedBox(height: 4),

              /// --- DESCRIPTION ---
              Text(
                news.fields.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 8,          // 🔥 smaller
                  color: Colors.black54,
                ),
              ),

              if (news.fields.isFeatured) ...[
                const SizedBox(height: 4),
                const Text(
                  'FEATURED',
                  style: TextStyle(
                    fontSize: 8,        // 🔥 smaller
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
