class Article {
  final String title;
  final String by;
  final String? url;

  Article({required this.title, required this.by, this.url});

  // Convert JSON → Dart
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'No title',
      by: json['by'] ?? 'Unknown',
      url: json['url'],
    );
  }
}
