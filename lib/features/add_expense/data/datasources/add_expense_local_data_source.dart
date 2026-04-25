import 'package:expense_tracker/core/database/dao/expense_dao.dart';
import 'package:expense_tracker/core/database/tables/expense_table.dart';
import 'package:expense_tracker/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:expense_tracker/features/settings/domain/entities/settings_snapshot.dart';

import '../../../../core/database/app_database.dart';

class AddExpenseLocalDataSource {
  AddExpenseLocalDataSource(
    this._expenseDao,
    this._settingsLocalDataSource,
  );

  final ExpenseDao _expenseDao;
  final SettingsLocalDataSource _settingsLocalDataSource;

  Future<SettingsSnapshot> loadFormData() {
    return _settingsLocalDataSource.loadSettings();
  }

  Future<Expense?> getExpense(int id) {
    return _expenseDao.getExpenseById(id);
  }

  Future<void> addExpense({
    required double amount,
    String? title,
    required int categoryId,
    required String currencyCode,
    DateTime? date,
  }) async {
    await _expenseDao.addExpense(
      amount: amount,
      title: title,
      categoryId: categoryId,
      currency: _currencyFromCode(currencyCode),
      date: date,
    );
  }

  Future<void> updateExpense({
    required int id,
    required double amount,
    String? title,
    required int categoryId,
    required String currencyCode,
    DateTime? date,
  }) async {
    await _expenseDao.updateExpenseValues(
      id: id,
      amount: amount,
      title: title,
      categoryId: categoryId,
      currency: _currencyFromCode(currencyCode),
      date: date,
    );
  }

  Currency _currencyFromCode(String currencyCode) {
    return switch (currencyCode.toLowerCase()) {
      'usd' => Currency.usd,
      'eur' => Currency.eur,
      _ => Currency.inr,
    };
  }
}
