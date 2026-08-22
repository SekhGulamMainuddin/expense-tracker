import 'package:expense_tracker/core/database/dao/expense_dao.dart';
import 'package:expense_tracker/core/domain/entities/currency.dart';
import 'package:expense_tracker/core/exchange/domain/repositories/exchange_rate_repository.dart';
import 'package:expense_tracker/features/home/data/mappers/finance_transaction_mapper.dart';
import 'package:expense_tracker/features/home/domain/entities/finance_transaction.dart';
import 'package:expense_tracker/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:expense_tracker/features/settings/domain/entities/settings_category.dart';
import 'package:expense_tracker/features/settings/domain/entities/settings_snapshot.dart';
import 'package:expense_tracker/features/transactions/domain/entities/transaction_filter.dart';

class TransactionLocalDataSource {
  TransactionLocalDataSource(
    this._expenseDao,
    this._settingsLocalDataSource,
    this._exchangeRateRepository,
  );

  final ExpenseDao _expenseDao;
  final SettingsLocalDataSource _settingsLocalDataSource;
  final ExchangeRateRepository _exchangeRateRepository;

  Future<SettingsSnapshot> loadFilterOptions() =>
      _settingsLocalDataSource.loadSettings();

  Future<List<FinanceTransaction>> getTransactions({
    required TransactionFilter filter,
    required int limit,
    required int offset,
  }) async {
    final settings = await _settingsLocalDataSource.loadSettings();
    final baseCurrency = Currency.fromCode(settings.baseCurrencyCode);
    final categoryMap = flattenCategories(settings.categories);
    final rates = await _exchangeRateRepository.currentRates();

    final (start, end) = filter.resolveDateRange(DateTime.now());

    final expenses = await _expenseDao.getFilteredTransactions(
      startDate: start,
      endDate: end,
      categoryIds: _expandCategoryIds(filter.categoryIds, settings.categories),
      searchQuery: filter.searchQuery,
      limit: limit,
      offset: offset,
    );

    return expenses
        .map((e) => mapExpenseToTransaction(
              expense: e,
              categories: categoryMap,
              targetCurrency: baseCurrency,
              rates: rates,
            ))
        .toList();
  }

  Future<void> deleteTransaction(int id) => _expenseDao.deleteExpense(id);

  /// Selecting a parent category implicitly selects its subcategories, since
  /// expenses are always attached to the deepest node.
  List<int>? _expandCategoryIds(
    Set<int> selected,
    List<SettingsCategory> categories,
  ) {
    if (selected.isEmpty) return null;

    final lookup = flattenCategories(categories);
    final expanded = <int>{};
    for (final id in selected) {
      expanded.add(id);
      final category = lookup[id];
      if (category == null) continue;
      for (final child in category.children) {
        expanded.add(child.id);
      }
    }
    return expanded.toList();
  }
}
