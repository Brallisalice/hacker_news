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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. The main parent comment
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 4.0,
          ),
          title: Text(
            '${comment.by} • ${DateFormatter.timeAgo(comment.time)}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(TextFormatter.parseHtmlString(comment.text!)),
          ),
        ),

        // 2. THE RECURSION: If this comment has replies (kids), fetch and render them
        if (comment.kids != null && comment.kids!.isNotEmpty)
          Padding(
            // This 16-pixel indentation on the left creates the visual tree hierarchy
            padding: const EdgeInsets.only(left: 16.0),
            child: FutureBuilder<List<Comment>>(
              future: Future.wait(
                comment.kids!
                    .map((id) => _newsService.fetchComment(id))
                    .toList(),
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // A subtle, discrete loading indicator for child replies
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

                // The widget calls itself here (Recursion).
                // Each reply renders as a new CommentTile, which in turn checks for its own replies.
                return Column(
                  children: childComments
                      .map((childComment) => CommentTile(comment: childComment))
                      .toList(),
                );
              },
            ),
          ),
        const Divider(
          height: 1,
        ), // A thin line separating main conversation threads
      ],
    );
  }
}
