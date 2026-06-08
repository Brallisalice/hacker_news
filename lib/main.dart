import 'package:flutter/material.dart';
import 'package:hacker_news/providers/bookmark_provider.dart';
import 'package:provider/provider.dart';
import 'screens/hacker_news_list.dart';
import 'package:hacker_news/themes/app_theme.dart';
import 'package:hacker_news/providers/search_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BookmarkProvider>(
          create: (context) => BookmarkProvider(),
        ),
        ChangeNotifierProvider<SearchProvider>(
          create: (context) => SearchProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: HackerNewsList(),
      ),
    );
  }
}
