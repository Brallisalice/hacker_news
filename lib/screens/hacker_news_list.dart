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

enum NewsCategory { top, best, newStories }

class _HackerNewsListState extends State<HackerNewsList> {
  List<dynamic> newsItems = [];
  final NewsService _newsService = NewsService();
  List<Article> _articles = [];
  bool _isLoading = true;
  NewsCategory _currentCategory = NewsCategory.top;

  @override
  void initState() {
    super.initState();
    getNews(_currentCategory);
  }

  Future<void> getNews(NewsCategory category) async {
    try {
      String categoryType = 'top';

      switch (category) {
        case NewsCategory.top:
          categoryType = 'top';
          break;
        case NewsCategory.best:
          categoryType = 'best';
          break;
        case NewsCategory.newStories:
          categoryType = 'new';
          break;
      }
      final articles = await _newsService.fetchStories(categoryType);
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            onTap: (int index) {
              if (_isLoading) return;
              NewsCategory selectedCategory = NewsCategory.top;

              switch (index) {
                case 0:
                  selectedCategory = NewsCategory.top;
                  break;
                case 1:
                  selectedCategory = NewsCategory.best;
                  break;
                case 2:
                  selectedCategory = NewsCategory.newStories;
                  break;
              }
              setState(() {
                _isLoading = true;
                _currentCategory = selectedCategory;
              });
              getNews(selectedCategory);
            },
            tabs: [
              Tab(text: 'TOP'),
              Tab(text: 'BEST'),
              Tab(text: 'NEW'),
            ],
          ),
        ),
        body: _isLoading
            ? ArticleListSkeleton()
            : RefreshIndicator(
                onRefresh: () => getNews(_currentCategory),
                child: ListView.builder(
                  itemCount: _articles.length,
                  itemBuilder: (context, index) {
                    return NewsTile(article: _articles[index]);
                  },
                ),
              ),
      ),
    );
  }
}
