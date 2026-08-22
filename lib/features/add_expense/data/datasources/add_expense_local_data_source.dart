import 'package:expense_tracker/core/database/dao/expense_dao.dart';
import 'package:expense_tracker/core/domain/entities/currency.dart';
import 'package:expense_tracker/core/exchange/domain/repositories/exchange_rate_repository.dart';
import 'package:expense_tracker/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:expense_tracker/features/add_expense/domain/entities/editable_expense.dart';
import 'package:expense_tracker/features/settings/domain/entities/settings_snapshot.dart';


class AddExpenseLocalDataSource {
  AddExpenseLocalDataSource(
    this._expenseDao,
    this._settingsLocalDataSource,
    this._exchangeRateRepository,
  );

  final ExpenseDao _expenseDao;
  final SettingsLocalDataSource _settingsLocalDataSource;
  final ExchangeRateRepository _exchangeRateRepository;

  Future<SettingsSnapshot> loadFormData() {
    return _settingsLocalDataSource.loadSettings();
  }

  /// Loads an expense with its amount converted back into the current base
  /// currency, so the edit form can display it directly.
  Future<EditableExpense?> getExpense(int id) async {
    final expense = await _expenseDao.getExpenseById(id);
    if (expense == null) return null;

    final settings = await _settingsLocalDataSource.loadSettings();
    final baseCurrency = Currency.fromCode(settings.baseCurrencyCode);
    final rates = await _exchangeRateRepository.currentRates();

    return EditableExpense(
      id: expense.id,
      amount: rates.fromBase(expense.baseAmount, baseCurrency),
      title: expense.title,
      categoryId: expense.categoryId,
      date: expense.date,
    );
  }

  Future<void> addExpense({
    required double amount,
    String? title,
    required int categoryId,
    required String currencyCode,
    DateTime? date,
  }) async {
    final currency = _currencyFromCode(currencyCode);
    await _expenseDao.addExpense(
      amount: amount,
      baseAmount: await _toBaseAmount(amount, currency),
      title: title,
      categoryId: categoryId,
      currency: currency,
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
    final currency = _currencyFromCode(currencyCode);
    await _expenseDao.updateExpenseValues(
      id: id,
      amount: amount,
      baseAmount: await _toBaseAmount(amount, currency),
      title: title,
      categoryId: categoryId,
      currency: currency,
      date: date,
    );
  }

  Future<void> deleteExpense(int id) async {
    await _expenseDao.deleteExpense(id);
  }

  /// Normalizes into the INR storage base at the rate in force when the row
  /// is written, so past entries are not retroactively repriced.
  Future<double> _toBaseAmount(double amount, Currency currency) async {
    final rates = await _exchangeRateRepository.currentRates();
    return rates.toBase(amount, currency);
  }

  Currency _currencyFromCode(String currencyCode) {
    return Currency.fromCode(currencyCode);
  }
}
