import 'package:expense_tracker/core/error/result.dart';
import 'package:expense_tracker/features/home/data/datasources/finance_local_data_source.dart';
import 'package:expense_tracker/features/home/domain/entities/finance_snapshot.dart';
import 'package:expense_tracker/features/home/domain/repositories/finance_repository.dart';

final class FinanceRepositoryImpl implements FinanceRepository {
  FinanceRepositoryImpl(this._localDataSource);

  final FinanceLocalDataSource _localDataSource;

  @override
  ResultFuture<FinanceSnapshot> loadDashboard() async {
    try {
      final snapshot = await _localDataSource.loadDashboard();
      return Success(snapshot);
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }

  @override
  Stream<FinanceSnapshot> watchDashboard() {
    return _localDataSource.watchDashboard();
  }
}
