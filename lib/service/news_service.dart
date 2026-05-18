import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hacker_news/models/article.dart';
import 'package:hacker_news/models/comment.dart';

class NewsService {
  final String _baseUrl = 'https://hacker-news.firebaseio.com/v0';

  Future<Article> fetchArticle(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/item/$id.json'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return Article.fromJson(json);
    } else {
      throw Exception('Failed to get comments');
    }
  }

  Future<List<Article>> fetchTopStories() async {
    final response = await http.get(Uri.parse('$_baseUrl/topstories.json'));

    if (response.statusCode == 200) {
      List<dynamic> ids = jsonDecode(response.body);

      final topIds = ids.take(20).cast<int>();

      final articles = await Future.wait(topIds.map((id) => fetchArticle(id)));
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
