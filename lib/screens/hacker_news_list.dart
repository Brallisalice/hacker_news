import 'package:flutter/material.dart';
import 'package:hacker_news/screens/bookmark_screen.dart';
import 'package:hacker_news/screens/search_screen.dart';
import 'package:hacker_news/service/news_service.dart';
import 'package:hacker_news/widgets/news_tile.dart';
import 'package:hacker_news/models/article.dart';
import 'package:hacker_news/widgets/shimmer_wrapper.dart';

class HackerNewsList extends StatefulWidget {
  const HackerNewsList({super.key});

  @override
  State<HackerNewsList> createState() => _HackerNewsListState();
}

class _HackerNewsListState extends State<HackerNewsList> {
  List<dynamic> newsItems = [];
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
      appBar: AppBar(
        title: Text('Hacker News'),
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookmarkScreen()),
              );
            },
            tooltip: 'View Saved Articles',
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? ArticleListSkeleton()
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
