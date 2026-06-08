class Article {
  final String title;
  final String
  by; // We keep this name in Dart, but map it from 'by' or 'author'
  final String? url;
  final String? text;
  final String id; // Changed from int to String to handle Algolia safely
  final List<int>? kids;
  final int score; // Maps from 'score' or 'points'
  final int time;
  final int descendants; // Maps from 'descendants' or 'num_comments'

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

  // Convert JSON → Dart (Handles both official HN API and Algolia Search API)
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'No title',

      // If 'by' is missing (Algolia), look for 'author'
      by: json['by'] ?? json['author'] ?? 'Unknown',

      url: json['url'],
      text: json['text'],

      // Convert official int ID to String, or pick Algolia's 'objectID' String directly
      id: json['id']?.toString() ?? json['objectID']?.toString() ?? '0',

      kids: json['kids'] != null ? List<int>.from(json['kids']) : [],

      // If 'score' is missing (Algolia), look for 'points'
      score: json['score'] ?? json['points'] ?? 0,

      time: json['time'] ?? 0,

      // If 'descendants' is missing (Algolia), look for 'num_comments'
      descendants: json['descendants'] ?? json['num_comments'] ?? 0,
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
