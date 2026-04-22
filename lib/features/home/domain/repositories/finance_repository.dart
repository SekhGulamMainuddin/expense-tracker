import 'package:expense_tracker/core/error/result.dart';
import 'package:expense_tracker/features/home/domain/entities/finance_snapshot.dart';

abstract interface class FinanceRepository {
  ResultFuture<FinanceSnapshot> loadDashboard();

  /// Reactive stream that emits a new snapshot whenever the underlying
  /// expense or category data changes.
  Stream<FinanceSnapshot> watchDashboard();
}
