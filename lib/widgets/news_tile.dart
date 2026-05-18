import 'package:flutter/material.dart';
import 'package:hacker_news/models/article.dart';
import 'package:hacker_news/screens/article_detail_screen.dart';
import 'package:hacker_news/utils/date_formatter.dart';

class NewsTile extends StatelessWidget {
  const NewsTile({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.article),
      title: Text(article.title),
      subtitle: Text(
        '${article.score} points by: ${article.by}  ${DateFormatter.timeAgo(article.time)} | ${article.descendants}',
      ),
      trailing: article.url != null ? Icon(Icons.link, size: 18) : null,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailScreen(article: article),
          ),
        );
      },
    );
  }
}
