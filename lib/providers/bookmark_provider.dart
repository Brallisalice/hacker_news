import 'dart:collection';

import 'package:flutter/material.dart';

class BookmarkProvider with ChangeNotifier {
  List<String> _bookmarkedIds = [];
  UnmodifiableListView<String> get bookmarkedIds =>
      UnmodifiableListView(_bookmarkedIds);
  get size => _bookmarkedIds.length;

  void addBookmark(String id) {
    _bookmarkedIds.add(id);
    notifyListeners();
  }

  void removeBookmark(String id) {
    _bookmarkedIds.remove(id);
    notifyListeners();
  }

  void toggleBookmark(String id) {
    if (_bookmarkedIds.contains(id)) {
      removeBookmark(id);
    } else {
      addBookmark(id);
    }
  }
}
