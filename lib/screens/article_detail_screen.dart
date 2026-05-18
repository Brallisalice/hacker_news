import 'package:flutter/material.dart';
import 'package:hacker_news/models/article.dart';
import 'package:hacker_news/models/comment.dart';
import 'package:hacker_news/service/news_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hacker_news/utils/date_formatter.dart';

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
            Text(article.text!),
            const SizedBox(height: 24),
          ],
          Text('${article.descendants} Comments'),
          Divider(),
          if (article.kids != null && article.kids!.isNotEmpty)
            FutureBuilder<Comment>(
              future: NewsService().fetchComment(article.kids!.first),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Text('Could not load comments');
                }

                final comment = snapshot.data!;
                return Text(comment.text!);
              },
            ),
        ],
      ),
    );
  }
}
