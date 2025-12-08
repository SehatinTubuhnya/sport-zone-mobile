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

    if (diff.inSeconds < 60) return "just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes}m ago";
    if (diff.inHours < 24) return "${diff.inHours}h ago";
    if (diff.inDays < 7) return "${diff.inDays}d ago";

    // Weeks
    final weeks = (diff.inDays / 7).floor();
    if (weeks < 4) return "${weeks}w ago";

    // Months (approx)
    final months = (diff.inDays / 30).floor();
    if (months < 12) return "${months}mo ago";

    // Years
    final years = (diff.inDays / 365).floor();
    return "${years}y ago";
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
                      Text(comment.fields.username),
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