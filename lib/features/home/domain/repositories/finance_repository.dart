import 'package:expense_tracker/core/error/result.dart';
import 'package:expense_tracker/features/home/domain/entities/finance_snapshot.dart';
import 'package:expense_tracker/features/home/domain/entities/time_range.dart';

abstract interface class FinanceRepository {
  ResultFuture<FinanceSnapshot> loadDashboard({TimeRange range = TimeRange.monthly});

  /// Reactive stream that emits a new snapshot whenever the underlying
  /// expense or category data changes.
  Stream<FinanceSnapshot> watchDashboard({TimeRange range = TimeRange.monthly});
}
