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
}
