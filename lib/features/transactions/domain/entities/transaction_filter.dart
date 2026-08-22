enum DateFilterType { today, last7Days, last30Days, custom }

/// The query the transaction list is currently showing. Kept in the domain
/// layer so both the cubit and the repository speak the same filter language.
class TransactionFilter {
  const TransactionFilter({
    this.dateFilter = DateFilterType.last30Days,
    this.customStartDate,
    this.customEndDate,
    this.categoryIds = const {},
    this.searchQuery = '',
  });

  final DateFilterType dateFilter;
  final DateTime? customStartDate;
  final DateTime? customEndDate;

  /// Empty means "all categories".
  final Set<int> categoryIds;
  final String searchQuery;

  /// Resolves the filter into a concrete date window. A custom range with no
  /// dates picked yet is treated as unbounded.
  (DateTime?, DateTime?) resolveDateRange(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    return switch (dateFilter) {
      DateFilterType.today => (today, now),
      DateFilterType.last7Days => (today.subtract(const Duration(days: 7)), now),
      DateFilterType.last30Days => (today.subtract(const Duration(days: 30)), now),
      DateFilterType.custom => (customStartDate, _endOfDay(customEndDate)),
    };
  }

  /// A date-range picker returns midnight for the end date, which would drop
  /// everything logged that day. Push it to the last instant instead.
  static DateTime? _endOfDay(DateTime? date) {
    if (date == null) return null;
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  TransactionFilter copyWith({
    DateFilterType? dateFilter,
    DateTime? customStartDate,
    DateTime? customEndDate,
    Set<int>? categoryIds,
    String? searchQuery,
  }) {
    return TransactionFilter(
      dateFilter: dateFilter ?? this.dateFilter,
      customStartDate: customStartDate ?? this.customStartDate,
      customEndDate: customEndDate ?? this.customEndDate,
      categoryIds: categoryIds ?? this.categoryIds,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
