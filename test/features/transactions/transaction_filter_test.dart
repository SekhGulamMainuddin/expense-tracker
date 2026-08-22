import 'package:expense_tracker/features/transactions/domain/entities/transaction_filter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // A mid-month afternoon, so day arithmetic can't accidentally pass by
  // landing on a month boundary.
  final now = DateTime(2026, 8, 22, 14, 30);
  final startOfDay = DateTime(2026, 8, 22);

  group('resolveDateRange', () {
    test('today spans midnight to now', () {
      const filter = TransactionFilter(dateFilter: DateFilterType.today);

      expect(filter.resolveDateRange(now), (startOfDay, now));
    });

    test('last 7 days counts back from midnight today', () {
      const filter = TransactionFilter(dateFilter: DateFilterType.last7Days);

      final (start, end) = filter.resolveDateRange(now);
      expect(start, DateTime(2026, 8, 15));
      expect(end, now);
    });

    test('last 30 days crosses the month boundary', () {
      const filter = TransactionFilter(dateFilter: DateFilterType.last30Days);

      final (start, _) = filter.resolveDateRange(now);
      expect(start, DateTime(2026, 7, 23));
    });

    test('custom range extends the end date to the last instant of that day',
        () {
      final filter = TransactionFilter(
        dateFilter: DateFilterType.custom,
        customStartDate: DateTime(2026, 8, 1),
        customEndDate: DateTime(2026, 8, 10),
      );

      final (start, end) = filter.resolveDateRange(now);
      expect(start, DateTime(2026, 8, 1));
      // A picker returns midnight; without this an expense logged at 18:00 on
      // the 10th would fall outside the user's own selection.
      expect(end, DateTime(2026, 8, 10, 23, 59, 59, 999));
    });

    test('custom range with nothing picked yet is unbounded', () {
      const filter = TransactionFilter(dateFilter: DateFilterType.custom);

      expect(filter.resolveDateRange(now), (null, null));
    });
  });

  group('defaults', () {
    test('starts on last 30 days with no category or search filter', () {
      const filter = TransactionFilter();

      expect(filter.dateFilter, DateFilterType.last30Days);
      expect(filter.categoryIds, isEmpty);
      expect(filter.searchQuery, isEmpty);
    });
  });

  group('copyWith', () {
    test('replaces only the named field', () {
      const filter = TransactionFilter(
        dateFilter: DateFilterType.today,
        categoryIds: {1, 2},
      );

      final updated = filter.copyWith(searchQuery: 'coffee');

      expect(updated.searchQuery, 'coffee');
      expect(updated.dateFilter, DateFilterType.today);
      expect(updated.categoryIds, {1, 2});
    });
  });
}
