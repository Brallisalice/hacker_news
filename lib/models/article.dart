class Article {
  final String title;
  final String by;
  final String? url;
  final String? text;
  final int id;
  final List<int>? kids;
  final int score;
  final int time;
  final int descendants;

  Article({
    required this.title,
    required this.by,
    this.url,
    required this.id,
    this.text,
    this.kids,
    required this.score,
    required this.time,
    required this.descendants,
  });

  // Convert JSON → Dart
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'No title',
      by: json['by'] ?? 'Unknown',
      url: json['url'],
      text: json['text'],
      id: json['id'] ?? 0,
      kids: json['kids'] != null ? List<int>.from(json['kids']) : [],
      score: json['score'] ?? 0,
      time: json['time'] ?? 0,
      descendants: json['descendants'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'by': by,
      'url': url,
      'text': text,
      'id': id,
      'kids': kids,
      'score': score,
      'time': time,
      'descendants': descendants,
    };
  }
}
