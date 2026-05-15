import 'package:flutter/material.dart';
import 'package:hacker_news/models/article.dart';
import 'package:hacker_news/screens/article_detail_screen.dart';

class NewsTile extends StatelessWidget {
  const NewsTile({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.article),
      title: Text(article.title),
      subtitle: Text(
        '${article.score} points by: ${article.by}  ${timeAgo(article.time)} | ${article.descendants}',
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

String timeAgo(int timeStamp) {
  if (timeStamp == 0) return '';
  final postTime = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
  final now = DateTime.now();
  final difference = now.difference(postTime);

  if (difference.inDays > 0) {
    return '${difference.inDays} ${difference.inDays == 1 ? "day" : "days"} ago';
  }

  if (difference.inHours > 0) {
    return '${difference.inHours} ${difference.inHours == 1 ? "hour" : "hours"} ago';
  }

  if (difference.inMinutes > 0) {
    return '${difference.inMinutes} ${difference.inMinutes == 1 ? "minute" : "minutes"} ago';
  }

  return 'just now';
}
