import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HackerNewsList extends StatefulWidget {
  const HackerNewsList({super.key});

  @override
  State<HackerNewsList> createState() => _HackerNewsListState();
}

class _HackerNewsListState extends State<HackerNewsList> {
  List<dynamic> newsItems = []; // skapar en lista för att spara nyheterna

  @override
  void initState() {
    super.initState();
    getNews();
  }

  Future<void> getNews() async {
    String url = 'https://hacker-news.firebaseio.com/v0/newstories.json';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> ids = jsonDecode(response.body);
      List<dynamic> first20Ids = ids.take(20).toList();

      List<dynamic> loadedNews = [];

      for (var id in first20Ids) {
        String itemUrl = 'https://hacker-news.firebaseio.com/v0/item/$id.json';
        final itemResponse = await http.get(Uri.parse(itemUrl));

        if (itemResponse.statusCode == 200) {
          var itemData = jsonDecode(itemResponse.body);
          loadedNews.add(itemData);
        }
      }

      setState(() {
        newsItems = loadedNews;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hacker News')),
      body: newsItems.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: newsItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.article),
                  title: Text(newsItems[index]['title'] ?? 'No title'),
                  subtitle: Text('By: ${newsItems[index]['by']}'),
                );
              },
            ),
    );
  }
}
