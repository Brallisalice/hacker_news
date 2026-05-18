import 'package:flutter/material.dart';
import 'package:hacker_news/service/news_service.dart';
import 'package:hacker_news/widgets/news_tile.dart';
import 'package:hacker_news/models/article.dart';

class HackerNewsList extends StatefulWidget {
  const HackerNewsList({super.key});

  @override
  State<HackerNewsList> createState() => _HackerNewsListState();
}

class _HackerNewsListState extends State<HackerNewsList> {
  List<dynamic> newsItems = []; // skapar en lista för att spara nyheterna
  final NewsService _newsService = NewsService();
  List<Article> _articles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getNews();
  }

  Future<void> getNews() async {
    try {
      final articles = await _newsService.fetchTopStories();
      setState(() {
        _articles = articles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Could not load news')));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hacker News')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: getNews,
              child: ListView.builder(
                itemCount: _articles.length,
                itemBuilder: (context, index) {
                  return NewsTile(article: _articles[index]);
                },
              ),
            ),
    );
  }
}
