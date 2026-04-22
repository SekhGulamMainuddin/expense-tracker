import 'package:expense_tracker/core/error/result.dart';
import 'package:expense_tracker/features/add_expense/data/datasources/add_expense_local_data_source.dart';
import 'package:expense_tracker/features/add_expense/domain/repositories/add_expense_repository.dart';
import 'package:expense_tracker/features/settings/domain/entities/settings_snapshot.dart';

final class AddExpenseRepositoryImpl implements AddExpenseRepository {
  AddExpenseRepositoryImpl(this._localDataSource);

  final AddExpenseLocalDataSource _localDataSource;

  @override
  ResultFuture<SettingsSnapshot> loadFormData() async {
    try {
      final snapshot = await _localDataSource.loadFormData();
      return Success(snapshot);
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }

  @override
  ResultVoid addExpense({
    required double amount,
    String? title,
    required int categoryId,
    required String currencyCode,
    DateTime? date,
  }) async {
    try {
      await _localDataSource.addExpense(
        amount: amount,
        title: title,
        categoryId: categoryId,
        currencyCode: currencyCode,
        date: date,
      );
      return const Success(null);
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }
}
