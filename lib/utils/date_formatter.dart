class DateFormatter {
  static String timeAgo(int timeStamp) {
    // shows the right timestamp
    if (timeStamp == 0) return '';
    final postTime = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    final now = DateTime.now();
    final difference = now.difference(postTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? "day" : "days"} ago';
    }

    if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? "hour" : "hours"} ago';
    }

    if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? "minute" : "minutes"} ago';
    }

    return 'just now';
  }
}
