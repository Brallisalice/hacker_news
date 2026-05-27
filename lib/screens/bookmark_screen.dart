import 'package:flutter/material.dart';
import 'package:hacker_news/widgets/news_tile.dart';
import 'package:provider/provider.dart';
import 'package:hacker_news/providers/bookmark_provider.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookmarkProvider = context
        .watch<
          BookmarkProvider
        >(); // Every time the provider notifies, this screen rebuilds because of context.watch
    return Scaffold(
      appBar: AppBar(title: Text('Saved Articles')),
      body: bookmarkProvider.bookmarkedArticles.isEmpty
          ? Center(child: Text('No saved articles yet'))
          : ListView.builder(
              itemCount: bookmarkProvider.bookmarkedArticles.length,
              itemBuilder: (context, index) {
                final article = bookmarkProvider.bookmarkedArticles[index];
                return NewsTile(article: article);
              },
            ),
    );
  }
}
