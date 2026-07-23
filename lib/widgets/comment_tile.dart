import 'package:flutter/material.dart';
import 'package:hacker_news/models/comment.dart';
import 'package:hacker_news/service/news_service.dart';
import 'package:hacker_news/utils/text_formatter.dart';
import 'package:hacker_news/utils/date_formatter.dart';

class CommentTile extends StatelessWidget {
  final Comment comment;

  // Instance of NewsService so each tile can independently fetch its own replies
  final NewsService _newsService = NewsService();

  CommentTile({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    // If the comment has been deleted by Hacker News moderators, skip rendering it
    if (comment.text == null || comment.text!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. The main parent comment with vertical line
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 2.0,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${comment.by} • ${DateFormatter.timeAgo(comment.time)}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        TextFormatter.parseHtmlString(comment.text!),
                        style: const TextStyle(fontSize: 14, height: 1.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. THE RECURSION: If this comment has replies (kids), fetch and render them
          if (comment.kids != null && comment.kids!.isNotEmpty)
            Padding(
              // This 12-pixel indentation creates the clean visual tree hierarchy
              padding: const EdgeInsets.only(left: 12.0, top: 4.0),
              child: FutureBuilder<List<Comment>>(
                future: Future.wait(
                  comment.kids!
                      .map((id) => _newsService.fetchComment(id))
                      .toList(),
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.only(left: 8.0, top: 4.0),
                      child: SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  final childComments = snapshot.data!;

                  return Column(
                    children: childComments
                        .map(
                          (childComment) => CommentTile(comment: childComment),
                        )
                        .toList(),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
