import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/search_provider.dart';
import '../screens/article_detail_screen.dart';
import 'package:hacker_news/widgets/shimmer_wrapper.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchController _searchController = SearchController();

  @override
  void initState() {
    super.initState();
    // Listen to every keystroke and send the text straight to the Provider.
    // context.read is used here because we are triggering an action, not rebuilding the UI.
    _searchController.addListener(() {
      context.read<SearchProvider>().onSearchChanged(_searchController.text);
    });
  }

  @override
  void dispose() {
    // Always dispose controllers to clean up memory and prevent memory leaks.
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Hacker News')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SearchAnchor(
              searchController: _searchController,
              builder: (context, controller) => SearchBar(
                controller: controller,
                onTap: () => controller.openView(),
                leading: const Icon(Icons.search),
                hintText: 'Search stories...',
              ),
              suggestionsBuilder: (context, controller) {
                return [
                  // Consumer acts as a listener. It bypasses SearchAnchor's limitations
                  // and forces ONLY this block to rebuild the instant notifyListeners() is called.
                  Consumer<SearchProvider>(
                    builder: (context, searchProvider, child) {
                      if (searchProvider.isLoading) {
                        return const ArticleListSkeleton();
                      }

                      if (searchProvider.searchResults.isEmpty &&
                          controller.text.isNotEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Center(child: Text('No stories found.')),
                        );
                      }
                      // Map the list of Article models into a list of ListTile widgets
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: searchProvider.searchResults.map((article) {
                          return ListTile(
                            title: Text(article.title),
                            subtitle: Text(
                              'by ${article.by} • ${article.score} points',
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ArticleDetailScreen(article: article),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),
                ];
              },
            ),
          ],
        ),
      ),
    );
  }
}
