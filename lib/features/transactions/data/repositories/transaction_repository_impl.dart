import 'package:expense_tracker/core/error/result.dart';
import 'package:expense_tracker/features/home/domain/entities/finance_transaction.dart';
import 'package:expense_tracker/features/settings/domain/entities/settings_snapshot.dart';
import 'package:expense_tracker/features/transactions/data/datasources/transaction_local_data_source.dart';
import 'package:expense_tracker/features/transactions/domain/entities/transaction_filter.dart';
import 'package:expense_tracker/features/transactions/domain/repositories/transaction_repository.dart';

final class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl(this._localDataSource);

  final TransactionLocalDataSource _localDataSource;

  @override
  ResultFuture<SettingsSnapshot> loadFilterOptions() async {
    try {
      return Success(await _localDataSource.loadFilterOptions());
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }

  @override
  ResultFuture<List<FinanceTransaction>> getTransactions({
    required TransactionFilter filter,
    required int limit,
    required int offset,
  }) async {
    try {
      return Success(await _localDataSource.getTransactions(
        filter: filter,
        limit: limit,
        offset: offset,
      ));
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }

  @override
  ResultVoid deleteTransaction(int id) async {
    try {
      await _localDataSource.deleteTransaction(id);
      return const Success(null);
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }
}
