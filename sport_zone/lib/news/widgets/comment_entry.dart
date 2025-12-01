import 'package:flutter/material.dart';
import 'package:sport_zone/news/models/comment.dart';

class CommentEntry extends StatelessWidget {
  final Comment comment;

  const CommentEntry({
    super.key,
    required this.comment,
  });

  String timeAgo(DateTime date) {
    final Duration diff = DateTime.now().difference(date);

    if (diff.inSeconds < 60) return "Baru saja";
    if (diff.inMinutes < 60) return "${diff.inMinutes} menit yang lalu";
    if (diff.inHours < 24) return "${diff.inHours} jam yang lalu";
    if (diff.inDays < 2) return "Kemarin";
    if (diff.inDays < 7) return "${diff.inDays} hari yang lalu";

    // Weeks
    final weeks = (diff.inDays / 7).floor();
    if (weeks < 4) return "${weeks}  minggu yang lalu";

    // Months (approx)
    final months = (diff.inDays / 30).floor();
    if (months < 12) return "${months} bulan yang lalu";

    // Years
    final years = (diff.inDays / 365).floor();
    return "${years} tahun yang lalu";
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding (
      padding: EdgeInsetsGeometry.all(10),
      child: Container(
        height: 120,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                comment.fields.profilePic,
              ),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: Column (
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('@${comment.fields.username}'),
                      const SizedBox(width: 8),
                      Text("●"),
                      const SizedBox(width: 8),
                      Text(timeAgo(comment.fields.createdAt))
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    comment.fields.content
                  )
                ],
              ),
            )
          ],
        )
      )
    );
  }
}