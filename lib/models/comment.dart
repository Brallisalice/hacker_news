class Comment {
  final int id;
  final String by;
  final int time;
  final String? text;
  final int parent;
  final String type;
  final List<int>? kids;
  Comment({
    required this.id,
    required this.by,
    required this.time,
    this.text,
    required this.parent,
    required this.type,
    this.kids,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] ?? 0,
      by: json['by'] ?? 'Unknown',
      time: json['time'] ?? 0,
      text: json['text'],
      parent: json['parent'] ?? 0,
      type: json['type'] ?? 0,
      kids: json['kids'] != null ? List<int>.from(json['kids']) : null,
    );
  }
}
