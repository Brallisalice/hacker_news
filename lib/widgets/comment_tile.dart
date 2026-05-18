import 'package:flutter/material.dart';
import 'package:hacker_news/models/comment.dart';
import 'package:hacker_news/utils/date_formatter.dart';

class CommentTile extends StatelessWidget {
  final Comment comment;

  const CommentTile({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'By: ${comment.by}  ${DateFormatter.timeAgo(comment.time)}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(comment.text ?? ''),
          ],
        ),
      ),
    );
  }
}
