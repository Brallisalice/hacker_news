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

  Future<List<Article>> fetchStories(String type) async {
    final response = await http.get(Uri.parse('$_baseUrl/${type}stories.json'));

    if (response.statusCode == 200) {
      List<dynamic> ids = jsonDecode(response.body);

      final storyIds = ids.take(20).cast<int>();

      final articles = await Future.wait(
        storyIds.map((id) => fetchArticle(id)),
      );
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

  Future<List<Article>> searchArticles(String query) async {
    // Return early if the query is empty to avoid unnecessary network requests
    if (query.isEmpty) return [];

    // Construct the URL safely. 'tags': 'story' filters out raw comments
    // ensuring we only get actual news articles in the search results.
    final url = Uri.https('hn.algolia.com', '/api/v1/search', {
      'query': query,
      'tags': 'story',
    });
    try {
      print(url.toString());
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print(data);
        // Algolia wraps all matching search results in a list called 'hits'
        final List<dynamic> hits = data['hits'];

        // Map each search hit using our Article model which handles the Algolia structure
        return hits.map((hit) => Article.fromJson(hit)).toList();
      } else {
        throw Exception('Failed to load search results');
      }
    } catch (e) {
      // Log the error for debugging purposes without crashing the app
      print('Search error: $e');
      return [];
    }
  }
}
