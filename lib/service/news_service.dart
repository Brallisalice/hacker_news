import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hacker_news/models/article.dart';
import 'package:hacker_news/models/comment.dart';

class NewsService {
  final String _baseUrl = 'https://hacker-news.firebaseio.com/v0';

  Future<List<Article>> fetchNewStories() async {
    final response = await http.get(Uri.parse('$_baseUrl/topstories.json'));

    if (response.statusCode == 200) {
      List<dynamic> ids = jsonDecode(response.body);
      List<dynamic> first20Ids = ids.take(20).toList();

      List<Article> articles = [];
      for (var id in first20Ids) {
        final itemResponse = await http.get(
          Uri.parse('$_baseUrl/item/$id.json'),
        );

        if (itemResponse.statusCode == 200) {
          articles.add(Article.fromJson(jsonDecode(itemResponse.body)));
        }
      }
      return articles;
    } else {
      throw Exception('Failed to get news');
    }
  }

  Future<Comment> fetchComment(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/item/$id.json'));

    if (response.statusCode == 200) {
      return Comment.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get comments');
    }
  }
}
