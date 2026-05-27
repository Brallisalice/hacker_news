import 'package:flutter/material.dart';
import 'package:hacker_news/models/article.dart';
import 'package:hacker_news/models/comment.dart';
import 'package:hacker_news/service/news_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hacker_news/utils/date_formatter.dart';
import 'package:hacker_news/widgets/comment_tile.dart';
import 'package:hacker_news/utils/text_formatter.dart';
import 'package:hacker_news/providers/bookmark_provider.dart';
import 'package:provider/provider.dart';

class ArticleDetailScreen extends StatelessWidget {
  const ArticleDetailScreen({super.key, required this.article});

  final Article article;

  Future<void> _launchUrl(BuildContext context) async {
    if (article.url == null) return;

    final Uri url = Uri.parse(article.url!);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not launch browser')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final newsService = NewsService();
    final bookmarkProvider = context
        .watch<
          BookmarkProvider
        >(); // Every time the provider notifies, this screen rebuilds because of context.watch
    // Check if any saved article shares the same unique ID as this one
    final isBookmarked = bookmarkProvider.bookmarkedArticles.any(
      (a) => a.id == article.id,
    );
    // Check if this specific article is already saved
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
        actions: [
          if (article.url != null)
            IconButton(
              icon: const Icon(Icons.open_in_browser),
              onPressed: () => _launchUrl(context),
              tooltip: 'Open in browser',
            ),
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: isBookmarked ? Colors.amber : null,
            ), // Toggle icon look based on bookmark state
            onPressed: () {
              bookmarkProvider.toggleBookmark(article);
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Text(
            '${article.score} points by: ${article.by}  ${DateFormatter.timeAgo(article.time)}',
          ),
          Divider(
            height: 10,
          ), // If the article has text (like an "Ask HN" post), show it.
          if (article.text != null && article.text!.isNotEmpty) ...[
            Text(TextFormatter.parseHtmlString(article.text ?? '')),
            const SizedBox(height: 24),
          ],
          Text('${article.descendants} Comments'),
          Divider(),
          if (article.kids != null && article.kids!.isNotEmpty)
            FutureBuilder<List<Comment>>(
              // display all the comments with Future.wait
              future: Future.wait(
                article.kids!
                    .map((id) => newsService.fetchComment(id))
                    .toList(),
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Text('Could not load comments');
                }

                final comments = snapshot.data!;
                return ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: comments
                      .map((comment) => CommentTile(comment: comment))
                      .toList(),
                );
              },
            ),
        ],
      ),
    );
  }
}
