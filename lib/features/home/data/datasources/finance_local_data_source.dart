import 'dart:async';

import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/core/database/dao/expense_dao.dart';
import 'package:expense_tracker/core/utils/date_helper.dart';
import 'package:expense_tracker/features/home/domain/entities/finance_category_breakdown.dart';
import 'package:expense_tracker/features/home/domain/entities/finance_snapshot.dart';
import 'package:expense_tracker/features/home/domain/entities/finance_transaction.dart';
import 'package:expense_tracker/features/home/domain/entities/time_range.dart';
import 'package:expense_tracker/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:expense_tracker/features/settings/domain/entities/settings_category.dart';
import 'package:expense_tracker/core/domain/entities/currency.dart';
import 'package:rxdart/rxdart.dart';

class FinanceLocalDataSource {
  FinanceLocalDataSource(this._expenseDao, this._settingsLocalDataSource);

  final ExpenseDao _expenseDao;
  final SettingsLocalDataSource _settingsLocalDataSource;

  /// Watches expenses, categories, and settings tables.
  /// Three tables can fire simultaneously during a single mutation, so debounce
  /// to coalesce bursts into one dashboard recomputation.
  Stream<FinanceSnapshot> watchDashboard({TimeRange range = TimeRange.monthly}) {
    return Rx.merge<void>([
      _expenseDao.watchAllExpenses().map<void>((_) {}),
      _expenseDao.watchAllCategories().map<void>((_) {}),
      _settingsLocalDataSource.watchSettings(),
    ])
        .debounceTime(const Duration(milliseconds: 80))
        .asyncMap((_) => loadDashboard(range: range));
  }

  Future<FinanceSnapshot> loadDashboard({TimeRange range = TimeRange.monthly}) async {
    final settings = await _settingsLocalDataSource.loadSettings();
    final baseCurrency = Currency.fromCode(settings.baseCurrencyCode);
    final now = DateTime.now();
    
    // spendings are returned in INR from DAO (sum of baseAmount)
    final dailySpentInr = await _expenseDao.getTotalExpense(
      DateHelper.startOfToday,
      now,
    );
    final weeklySpentInr = await _expenseDao.getTotalExpense(
      DateHelper.startOfThisWeek,
      now,
    );
    final monthlySpentInr = await _expenseDao.getTotalExpense(
      DateHelper.startOfThisMonth,
      now,
    );
    final monthlyComparison = await _expenseDao.getMonthlyComparison();
    
    final (rangeStart, rangeEnd) = _getDatesForRange(range, now);
    final rangeExpenses = await _expenseDao.getExpensesInRange(
      rangeStart,
      rangeEnd,
    );

    final recentExpenses = await _expenseDao.getRecentTransactions(10, 0);

    final categoryMap = _flattenCategories(settings.categories);
    final recentTransactions = recentExpenses
        .map(
          (expense) => _toTransaction(
            expense: expense,
            categories: categoryMap,
            targetCurrency: baseCurrency,
          ),
        )
        .toList();
        
    final breakdown = _buildCategoryBreakdown(
      expenses: rangeExpenses,
      categories: categoryMap,
      targetCurrency: baseCurrency,
    );

    return FinanceSnapshot(
      currencyCode: settings.baseCurrencyCode,
      currencySymbol: baseCurrency.symbol,
      dailySpent: Currency.inr.convertTo(dailySpentInr, baseCurrency),
      weeklySpent: Currency.inr.convertTo(weeklySpentInr, baseCurrency),
      monthlySpent: Currency.inr.convertTo(monthlySpentInr, baseCurrency),
      dailyLimit: settings.dailyLimit,
      weeklyLimit: settings.weeklyLimit,
      monthlyLimit: settings.monthlyLimit,
      monthlyComparison: monthlyComparison,
      recentTransactions: recentTransactions,
      categoryBreakdown: breakdown,
      timeRange: range,
    );
  }

  Future<List<FinanceTransaction>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
    List<int>? categoryIds,
    int? limit,
    int? offset,
  }) async {
    final settings = await _settingsLocalDataSource.loadSettings();
    final baseCurrency = Currency.fromCode(settings.baseCurrencyCode);
    final categoryMap = _flattenCategories(settings.categories);
    final expenses = await _expenseDao.getFilteredTransactions(
      startDate: startDate,
      endDate: endDate,
      categoryIds: categoryIds,
      limit: limit,
      offset: offset,
    );

    return expenses
        .map((e) => _toTransaction(
              expense: e,
              categories: categoryMap,
              targetCurrency: baseCurrency,
            ))
        .toList();
  }

  (DateTime, DateTime) _getDatesForRange(TimeRange range, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    return switch (range) {
      TimeRange.daily => (today, now),
      TimeRange.weekly => (DateHelper.startOfThisWeek, now),
      TimeRange.monthly => (DateHelper.startOfThisMonth, now),
      TimeRange.allTime => (DateTime(2000), now),
    };
  }

  Map<int, SettingsCategory> _flattenCategories(List<SettingsCategory> list) {
    final result = <int, SettingsCategory>{};
    for (final cat in list) {
      result[cat.id] = cat;
      for (final child in cat.children) {
        result[child.id] = child;
      }
    }

    return result;
  }

  FinanceTransaction _toTransaction({
    required Expense expense,
    required Map<int, SettingsCategory> categories,
    required Currency targetCurrency,
  }) {
    final category = categories[expense.categoryId];
    
    // We convert baseAmount (INR) to the target currency
    final amount = Currency.inr.convertTo(expense.baseAmount, targetCurrency).abs();

    String displayTitle = expense.title ?? '';
    if (displayTitle.isEmpty) {
      if (category != null) {
        if (category.parentId != null && category.parentId != 0) {
          final parent = categories[category.parentId!];
          displayTitle =
              parent != null ? '${parent.title} | ${category.title}' : category.title;
        } else {
          displayTitle = category.title;
        }
      } else {
        displayTitle = 'Expense';
      }
    }

    return FinanceTransaction(
      id: expense.id,
      title: displayTitle,
      subtitle: DateHelper.formatTransactionDate(expense.date),
      amount: amount,
      icon: category?.icon ?? 'receipt_long',
      color: category?.color ?? 0xFF64748B,
      date: expense.date,
    );
  }

  List<FinanceCategoryBreakdown> _buildCategoryBreakdown({
    required List<Expense> expenses,
    required Map<int, SettingsCategory> categories,
    required Currency targetCurrency,
  }) {
    final spendingPerCategory = <int, double>{};
    double totalSpend = 0;

    for (final expense in expenses) {
      final amount = Currency.inr.convertTo(expense.baseAmount, targetCurrency);
      totalSpend += amount;
      
      final cat = categories[expense.categoryId];
      if (cat == null) continue;

      // Group subcategories into their parents for the breakdown
      final rootId = (cat.parentId == null || cat.parentId == 0) ? cat.id : cat.parentId!;
      spendingPerCategory[rootId] = (spendingPerCategory[rootId] ?? 0) + amount;
    }

    return spendingPerCategory.entries
        .where((entry) => entry.value > 0)
        .map<FinanceCategoryBreakdown>((entry) {
      final cat = categories[entry.key]!;
      return FinanceCategoryBreakdown(
        categoryId: cat.id,
        title: cat.title,
        amount: entry.value,
        percentage: totalSpend > 0 ? (entry.value / totalSpend) : 0,
        color: cat.color,
        icon: cat.icon,
      );
    }).toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));
  }
}
