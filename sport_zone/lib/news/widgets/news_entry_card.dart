// // import 'package:flutter/material.dart';
// // import 'package:sport_zone/news/models/news_entry.dart';
// // import 'package:auto_size_text/auto_size_text.dart';


// // // class NewsEntryCard extends StatelessWidget {
// // //   final NewsEntry news;
// // //   final VoidCallback onTap;

// // //   const NewsEntryCard({
// // //     super.key,
// // //     required this.news,
// // //     required this.onTap,
// // //   });

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Container(
// // //       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// // //       child: InkWell(
// // //         onTap: onTap,
// // //         child: Card(
// // //           shape: RoundedRectangleBorder(
// // //             borderRadius: BorderRadius.circular(8.0),
// // //             side: BorderSide(color: Colors.grey.shade300),
// // //           ),
// // //           elevation: 2,
// // //           child: Padding(
// // //             padding: const EdgeInsets.all(16.0),
// // //             child: Column(
// // //               mainAxisAlignment: MainAxisAlignment.start,
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               children: [
// // //                 // Thumbnail
// // //                 Expanded(
// // //                   flex: 5,
// // //                   child: AspectRatio(
// // //                     aspectRatio: 3,
// // //                     child: ClipRRect(
// // //                       borderRadius: BorderRadius.circular(6),
// // //                       child: Image.network(
// // //                         'http://localhost:8000/articles/proxy-image/?url=${Uri.encodeComponent(news.fields.thumbnail)}',
// // //                         fit: BoxFit.cover,
// // //                         errorBuilder: (context, error, stackTrace) => Container(
// // //                           color: Colors.grey[300],
// // //                           child: const Center(child: Icon(Icons.broken_image)),
// // //                         ),
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ),
                
// // //                 Expanded(
// // //                   flex: 5,
// // //                   child: const SizedBox(height: 8),
// // //                 ),
                

// // //                 // Title
// // //                 Expanded(
// // //                   flex: 5,
// // //                   child: Text(
// // //                     news.fields.title,
// // //                     style: const TextStyle(
// // //                       fontSize: 18.0,
// // //                       fontWeight: FontWeight.bold,
// // //                     ),
// // //                   ),
// // //                 ),
                
// // //                 Expanded(
// // //                   flex: 5,
// // //                   child: const SizedBox(height: 6),
// // //                 ),

// // //                 // Category
// // //                 Expanded(
// // //                 flex: 5,
// // //                 child: Text('Category: ${news.fields.category}'),
// // //                 ),

// // //                 Expanded(
// // //                   flex: 5,
// // //                   child: const SizedBox(height: 6),
// // //                 ),
                
// // //                 // Content preview
// // //                 Expanded(
// // //                   flex: 5,
// // //                   child: Text(
// // //                     news.fields.content.length > 100
// // //                         ? '${news.fields.content.substring(0, 100)}...'
// // //                         : news.fields.content,
// // //                     maxLines: 2,
// // //                     overflow: TextOverflow.ellipsis,
// // //                     style: const TextStyle(color: Colors.black54),
// // //                   ),
// // //                 ),
                
// // //                 Expanded(
// // //                   flex: 5,
// // //                   child: const SizedBox(height: 6),
// // //                 ),

// // //                 // Featured indicator
// // //                 if (news.fields.isFeatured)
// // //                   Expanded(
// // //                     flex: 5,
// // //                     child: const Text(
// // //                         'Featured',
// // //                         style: TextStyle(
// // //                           color: Colors.amber,
// // //                           fontWeight: FontWeight.bold
// // //                         ),
// // //                       ),
// // //                     ),
// // //               ],
// // //             ),
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // class NewsEntryCard extends StatelessWidget {
// //   final NewsEntry news;
// //   final VoidCallback onTap;

// //   const NewsEntryCard({
// //     super.key,
// //     required this.news,
// //     required this.onTap,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return InkWell(
// //       onTap: onTap,
// //       child: Card(
// //         shape: RoundedRectangleBorder(
// //           borderRadius: BorderRadius.circular(8.0),
// //           side: BorderSide(color: Colors.grey.shade300),
// //         ),
// //         elevation: 2,
// //         child: Padding(
// //           padding: const EdgeInsets.all(8.0),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
              
// //               /// --- IMAGE ---
// //               AspectRatio(
// //                 aspectRatio: 2.7, // slightly shorter for nicer balance
// //                 child: ClipRRect(
// //                   borderRadius: BorderRadius.circular(6),
// //                   child: Image.network(
// //                     'http://localhost:8000/articles/proxy-image/?url=${Uri.encodeComponent(news.fields.thumbnail)}',
// //                     fit: BoxFit.cover,
// //                     errorBuilder: (context, error, stackTrace) => Container(
// //                       color: Colors.grey[300],
// //                       child: const Center(child: Icon(Icons.broken_image)),
// //                     ),
// //                   ),
// //                 ),
// //               ),

// //               const SizedBox(height: 6),

// //               // Flexible(
// //               //   fit: FlexFit.loose,
// //               //   child: 
// //                 Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     /// --- TITLE ---
// //                       AutoSizeText(
// //                         news.fields.title,
// //                         maxLines: 2,
// //                         minFontSize: 12,
// //                         overflow: TextOverflow.ellipsis,
// //                         style: const TextStyle(
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                       ),

// //                       const SizedBox(height: 4),

// //                       /// --- CATEGORY ---
// //                       AutoSizeText(
// //                         news.fields.category,
// //                         maxLines: 1,
// //                         overflow: TextOverflow.ellipsis,
// //                         style: TextStyle(
// //                           color: Colors.grey[700],
// //                         ),
// //                       ),

// //                       const SizedBox(height: 4),

// //                       /// --- DESCRIPTION ---
// //                       AutoSizeText(
// //                         news.fields.content,
// //                         maxLines: 2,
// //                         overflow: TextOverflow.ellipsis,
// //                         style: const TextStyle(
// //                           color: Colors.black54,
// //                         ),
// //                       ),

// //                       if (news.fields.isFeatured) ...[
// //                         const SizedBox(height: 4),
// //                         const AutoSizeText(
// //                           'FEATURED',
// //                           style: TextStyle(
// //                             fontWeight: FontWeight.bold,
// //                             color: Colors.amber,
// //                           ),
// //                         )
// //                       ]
// //                   ],
// //                 )
// //               // )
              
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:sport_zone/news/models/news_entry.dart';
// import 'package:auto_size_text/auto_size_text.dart';

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
//     return InkWell(
//       onTap: onTap,
//       child: Card(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8.0),
//           side: BorderSide(color: Colors.grey.shade300),
//         ),
//         elevation: 2,
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [

//               // --- IMAGE ---
//               AspectRatio(
//                 aspectRatio: 2.7, // Controls image height relative to width
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(6),
//                   child: Image.network(
//                     'http://localhost:8000/articles/proxy-image/?url=${Uri.encodeComponent(news.fields.thumbnail)}',
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) => Container(
//                       color: Colors.grey[300],
//                       child: const Center(child: Icon(Icons.broken_image)),
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 6),

//               // --- TITLE ---
//               AutoSizeText(
//                 news.fields.title,
//                 maxLines: 2,
//                 minFontSize: 12,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),

//               const SizedBox(height: 4),

//               // --- CATEGORY ---
//               AutoSizeText(
//                 news.fields.category,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(
//                   color: Colors.grey[700],
//                 ),
//               ),

//               const SizedBox(height: 4),

//               // --- CONTENT PREVIEW ---
//               AutoSizeText(
//                 news.fields.content,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(
//                   color: Colors.black54,
//                 ),
//               ),

//               if (news.fields.isFeatured) ...[
//                 const SizedBox(height: 4),
//                 const AutoSizeText(
//                   'FEATURED',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.amber,
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:sport_zone/news/models/news_entry.dart';
// import 'package:auto_size_text/auto_size_text.dart';

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
//     return InkWell(
//       onTap: onTap,
//       child: Card(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8.0),
//           side: BorderSide(color: Colors.grey.shade300),
//         ),
//         elevation: 2,
//         child: Padding(
//           padding: const EdgeInsets.all(10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [

//               // --- IMAGE ---
//               AspectRatio(
//                 aspectRatio: 2.7, // Controls image height relative to width
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(6),
//                   child: Image.network(
//                     'http://localhost:8000/articles/proxy-image/?url=${Uri.encodeComponent(news.fields.thumbnail)}',
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) => Container(
//                       color: Colors.grey[300],
//                       child: const Center(child: Icon(Icons.broken_image)),
//                     ),
//                   ),
//                 ),
//               ),

//               // const SizedBox(height: 4),

//               // --- TITLE ---
//               AutoSizeText(
//                 news.fields.title,
//                 maxLines: 2,
//                 minFontSize: 12,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),

//               // const SizedBox(height: 2),

//               // --- CATEGORY ---
//               AutoSizeText(
//                 news.fields.category,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(color: Colors.grey[700]),
//               ),

//               // const SizedBox(height: 2),

//               // --- CONTENT PREVIEW ---
//               AutoSizeText(
//                 news.fields.content,
//                 maxLines: 5,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(color: Colors.black54),
//               ),

//               if (news.fields.isFeatured) ...[
//                 const SizedBox(height: 2),
//                 const AutoSizeText(
//                   'FEATURED',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.amber,
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:sport_zone/news/models/news_entry.dart';
// import 'package:auto_size_text/auto_size_text.dart';

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
//     return InkWell(
//       onTap: onTap,
//       child: Card(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8.0),
//           side: BorderSide(color: Colors.grey.shade300),
//         ),
//         elevation: 2,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [

//             // --- IMAGE ---
//             AspectRatio(
//               aspectRatio: 2.7,
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(8),
//                   topRight: Radius.circular(8),
//                 ),
//                 child: Image.network(
//                   'http://localhost:8000/articles/proxy-image/?url=${Uri.encodeComponent(news.fields.thumbnail)}',
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) => Container(
//                     color: Colors.grey[300],
//                     child: const Center(child: Icon(Icons.broken_image)),
//                   ),
//                 ),
//               ),
//             ),

//             // --- TEXT SECTION ---
//             Flexible(
//               fit: FlexFit.loose,
//               child: Padding(
//                 padding: const EdgeInsets.all(10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Title
//                     AutoSizeText(
//                       news.fields.title,
//                       maxLines: 2,
//                       minFontSize: 12,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),

//                     // const SizedBox(height: 2),

//                     // Category
//                     AutoSizeText(
//                       news.fields.category,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(color: Colors.grey[700]),
//                     ),

//                     // const SizedBox(height: 2),

//                     // Content Preview
//                     AutoSizeText(
//                       news.fields.content,
//                       maxLines: 3,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(color: Colors.black54),
//                     ),

//                     // Featured Indicator
//                     if (news.fields.isFeatured) ...[
//                       // const SizedBox(height: 2),
//                       const AutoSizeText(
//                         'FEATURED',
//                         maxLines: 1,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.amber,
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:sport_zone/news/models/news_entry.dart';
// import 'package:auto_size_text/auto_size_text.dart';

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
//     return InkWell(
//       onTap: onTap,
//       child: Card(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8.0),
//           side: BorderSide(color: Colors.grey.shade300),
//         ),
//         elevation: 2,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Flexible image
//             Flexible(
//               flex: 4,
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(8),
//                   topRight: Radius.circular(8),
//                 ),
//                 child: Image.network(
//                   'http://localhost:8000/articles/proxy-image/?url=${Uri.encodeComponent(news.fields.thumbnail)}',
//                   fit: BoxFit.cover,
//                   width: double.infinity,
//                   errorBuilder: (context, error, stackTrace) =>
//                       Container(color: Colors.grey[300], child: const Icon(Icons.broken_image)),
//                 ),
//               ),
//             ),

//             // Text section
//             Flexible(
//               flex: 5,
//               child: Padding(
//                 padding: const EdgeInsets.all(6.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     AutoSizeText(
//                       news.fields.title,
//                       maxLines: 2,
//                       minFontSize: 12,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 2),
//                     AutoSizeText(
//                       news.fields.category,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(color: Colors.grey[700]),
//                     ),
//                     const SizedBox(height: 2),
//                     AutoSizeText(
//                       news.fields.content,
//                       maxLines: 5,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(color: Colors.black54),
//                     ),
//                     if (news.fields.isFeatured) ...[
//                       const SizedBox(height: 2),
//                       const AutoSizeText(
//                         'FEATURED',
//                         maxLines: 1,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.amber,
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:sport_zone/news/models/news_entry.dart';
// import 'package:auto_size_text/auto_size_text.dart';

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
//     return InkWell(
//       onTap: onTap,
//       child: Card(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8.0),
//           side: BorderSide(color: Colors.grey.shade300),
//         ),
//         elevation: 2,
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             final maxHeight = constraints.maxHeight;

//             // Decide how much space the image gets
//             final imageHeight = maxHeight * 0.45;

//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // IMAGE
//                 SizedBox(
//                   height: imageHeight,
//                   width: double.infinity,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(6),
//                     child: Image.network(
//                       'http://localhost:8000/articles/proxy-image/?url=${Uri.encodeComponent(news.fields.thumbnail)}',
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) =>
//                           Container(color: Colors.grey[300]),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 4),

//                 // TEXT
//                 Flexible(
//                   fit: FlexFit.loose,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         AutoSizeText(
//                           news.fields.title,
//                           maxLines: 2,
//                           minFontSize: 12,
//                           overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         AutoSizeText(
//                           news.fields.category,
//                           maxLines: 1,
//                           minFontSize: 8,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(color: Colors.grey[700]),
//                         ),
//                         AutoSizeText(
//                           news.fields.content,
//                           maxLines: 3,
//                           minFontSize: 8,
//                           overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(color: Colors.black54),
//                         ),
//                         if (news.fields.isFeatured)
//                           const AutoSizeText(
//                             'FEATURED',
//                             maxLines: 1,
//                             minFontSize: 8,
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.amber,
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

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
