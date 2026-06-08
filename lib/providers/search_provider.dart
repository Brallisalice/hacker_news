import 'package:flutter/material.dart';
import '../models/article.dart';
import '../service/news_service.dart';
import '../utils/debouncer.dart';

class SearchProvider extends ChangeNotifier {
  final NewsService _newsService = NewsService();
  final _debouncer = Debouncer(delay: const Duration(milliseconds: 500));

  List<Article> _searchResults = [];
  bool _isLoading = false;

  // Getters to read the data from the UI
  List<Article> get searchResults => _searchResults;
  bool get isLoading => _isLoading;

  void onSearchChanged(String query) {
    if (query.trim().isEmpty) {
      _searchResults = [];
      _isLoading = false;
      notifyListeners(); // Tells the UI to rebuild
      return;
    }

    _debouncer.run(() => _performSearch(query));
  }

  Future<void> _performSearch(String query) async {
    _isLoading = true;
    notifyListeners();

    try {
      _searchResults = await _newsService.searchArticles(query);
    } catch (e) {
      debugPrint('Search failed: $e');
      _searchResults = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }
}
