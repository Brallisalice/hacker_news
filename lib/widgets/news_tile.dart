import 'package:flutter/material.dart';
import 'package:hacker_news/models/article.dart';

class NewsTile extends StatelessWidget {
  const NewsTile({super.key, required this.onLaunch, required this.article});

  final Function(Uri) onLaunch;
  final Article article;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.article),
      title: Text(article.title),
      subtitle: Text('By: ${article.by}'),
      onTap: () async {
        String? articleUrl = article.url;

        if (articleUrl != null && articleUrl.isNotEmpty) {
          final Uri url = Uri.parse(articleUrl);
          try {
            await onLaunch(url);
          } catch (e) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Could not open the link')));
          }
        }
      },
    );
  }
}
