class DateHelper {
  static DateTime get startOfToday =>
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  static DateTime get startOfThisWeek {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    return startOfToday.subtract(Duration(days: now.weekday - 1));
  }

  static DateTime get startOfThisMonth =>
      DateTime(DateTime.now().year, DateTime.now().month, 1);

  static String formatTransactionDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    final diff = today.difference(dateOnly).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
