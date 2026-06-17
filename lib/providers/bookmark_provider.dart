import 'dart:collection';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:hacker_news/models/article.dart';

class BookmarkProvider with ChangeNotifier {
  List<Article> _bookmarkedArticles = [];

  // Protect the list from being modified directly from the outside
  UnmodifiableListView<Article> get bookmarkedArticles =>
      UnmodifiableListView(_bookmarkedArticles);

  int get size => _bookmarkedArticles.length;

  BookmarkProvider() {
    loadBookmarks();
  }

  Future<void> addBookmark(Article article) async {
    _bookmarkedArticles.add(article);
    final prefs = await SharedPreferences.getInstance();
    // SharedPreferences can only save text, so we convert the list of objects to a JSON string
    final String jsonString = jsonEncode(
      _bookmarkedArticles.map((a) => a.toJson()).toList(),
    );
    await prefs.setString('bookmark', jsonString);
    notifyListeners();
  }

  Future<void> removeBookmark(Article article) async {
    // Remove the article by matching its unique ID
    _bookmarkedArticles.removeWhere((a) => a.id == article.id);
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(
      _bookmarkedArticles.map((a) => a.toJson()).toList(),
    );
    await prefs.setString('bookmark', jsonString);
    notifyListeners();
  }

  void toggleBookmark(Article article) {
    // Check if the article is already saved based on its ID
    final isSaved = _bookmarkedArticles.any((a) => a.id == article.id);
    if (isSaved) {
      removeBookmark(article);
    } else {
      addBookmark(article);
    }
  }

  Future<void> loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString('bookmark');

    if (jsonString != null) {
      // Convert the raw JSON string back into a list of real Article objects
      final List<dynamic> decodedList = jsonDecode(jsonString);
      _bookmarkedArticles = decodedList
          .map((item) => Article.fromJson(item))
          .toList();
    } else {
      _bookmarkedArticles = [];
    }

    notifyListeners();
  }
}
