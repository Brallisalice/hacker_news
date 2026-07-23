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
import 'package:share_plus/share_plus.dart';
import 'package:hacker_news/widgets/shimmer_wrapper.dart';

class ArticleDetailScreen extends StatelessWidget {
  const ArticleDetailScreen({super.key, required this.article});

  final Article article;

  Future<void> _launchUrl(BuildContext context) async {
    if (article.url == null) return;

    final Uri url = Uri.parse(article.url!);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch browser')),
        );
      }
    }
  }

  // Search results don't include comment IDs (kids), so re-fetch the full article if missing
  Future<List<Comment>> _fetchComments(NewsService newsService) async {
    List<int>? commentIds = article.kids;

    if (commentIds == null || commentIds.isEmpty) {
      final parsedId = int.tryParse(article.id) ?? 0;
      final fullArticle = await newsService.fetchArticle(parsedId);
      commentIds = fullArticle.kids;
    }

    if (commentIds == null || commentIds.isEmpty) {
      return [];
    }

    // Fetch all top-level comments in parallel
    return await Future.wait(
      commentIds.map((id) => newsService.fetchComment(id)).toList(),
    );
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
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              if (article.url != null) {
                SharePlus.instance.share(
                  ShareParams(uri: Uri.parse(article.url!)),
                );
              } else {
                SharePlus.instance.share(ShareParams(text: article.title));
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            '${article.score} points by: ${article.by}  ${DateFormatter.timeAgo(article.time)}',
          ),
          const Divider(
            height: 10,
          ), // If the article has text (like an "Ask HN" post), show it.
          if (article.text != null && article.text!.isNotEmpty) ...[
            Text(TextFormatter.parseHtmlString(article.text ?? '')),
            const SizedBox(height: 24),
          ],
          Text('${article.descendants} Comments'),
          const Divider(),

          // Display comments safely regardless of whether the article came from home or search
          FutureBuilder<List<Comment>>(
            future: _fetchComments(newsService),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CommentSkeleton();
              }

              if (snapshot.hasError) {
                return const Text('Could not load comments');
              }

              final comments = snapshot.data ?? [];

              if (comments.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('No comments yet.'),
                );
              }

              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
