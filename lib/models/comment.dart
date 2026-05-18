class Comment {
  final int id;
  final String by;
  final int time;
  final String? text;
  Comment({required this.id, required this.by, required this.time, this.text});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] ?? 0,
      by: json['by'] ?? 'Unknown',
      time: json['time'] ?? 0,
      text: json['text'],
    );
  }
}
