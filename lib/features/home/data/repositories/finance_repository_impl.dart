import 'package:expense_tracker/core/error/result.dart';
import 'package:expense_tracker/features/home/data/datasources/finance_local_data_source.dart';
import 'package:expense_tracker/features/home/domain/entities/finance_snapshot.dart';
import 'package:expense_tracker/features/home/domain/entities/finance_category_breakdown.dart';
import 'package:expense_tracker/features/home/domain/entities/time_range.dart';
import 'package:expense_tracker/features/home/domain/repositories/finance_repository.dart';

final class FinanceRepositoryImpl implements FinanceRepository {
  FinanceRepositoryImpl(this._localDataSource);

  final FinanceLocalDataSource _localDataSource;

  @override
  ResultFuture<FinanceSnapshot> loadDashboard({TimeRange range = TimeRange.monthly}) async {
    try {
      final snapshot = await _localDataSource.loadDashboard(range: range);
      return Success(snapshot);
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }

  @override
  Stream<FinanceSnapshot> watchDashboard({TimeRange range = TimeRange.monthly}) {
    return _localDataSource.watchDashboard(range: range);
  }
}
