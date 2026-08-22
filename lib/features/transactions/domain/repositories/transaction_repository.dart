import 'package:expense_tracker/core/error/result.dart';
import 'package:expense_tracker/features/home/domain/entities/finance_transaction.dart';
import 'package:expense_tracker/features/settings/domain/entities/settings_snapshot.dart';
import 'package:expense_tracker/features/transactions/domain/entities/transaction_filter.dart';

abstract interface class TransactionRepository {
  /// Categories + base currency needed to render and filter the list.
  ResultFuture<SettingsSnapshot> loadFilterOptions();

  ResultFuture<List<FinanceTransaction>> getTransactions({
    required TransactionFilter filter,
    required int limit,
    required int offset,
  });

  ResultVoid deleteTransaction(int id);
}
