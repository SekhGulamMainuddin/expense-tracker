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
    final now = DateTime.now();
    
    // Limits and spendings for the top card (always showing these stats)
    final dailySpent = await _expenseDao.getTotalExpense(
      DateHelper.startOfToday,
      now,
    );
    final weeklySpent = await _expenseDao.getTotalExpense(
      DateHelper.startOfThisWeek,
      now,
    );
    final monthlySpent = await _expenseDao.getTotalExpense(
      DateHelper.startOfThisMonth,
      now,
    );
    final monthlyComparison = await _expenseDao.getMonthlyComparison();
    
    // Fetch expenses for the specific range for the breakdown
    final (rangeStart, rangeEnd) = _getDatesForRange(range, now);
    final rangeExpenses = await _expenseDao.getExpensesInRange(
      rangeStart,
      rangeEnd,
    );

    final recentExpenses = await _expenseDao.getRecentTransactions(8, 0);

    final categoryMap = _flattenCategories(settings.categories);
    final recentTransactions = recentExpenses
        .map(
          (expense) => _toTransaction(
            expense: expense,
            categories: categoryMap,
          ),
        )
        .toList();
        
    final breakdown = _buildCategoryBreakdown(
      expenses: rangeExpenses,
      categories: categoryMap,
    );

    return FinanceSnapshot(
      currencyCode: settings.baseCurrencyCode,
      currencySymbol: _currencySymbol(settings.baseCurrencyCode),
      dailySpent: dailySpent,
      weeklySpent: weeklySpent,
      monthlySpent: monthlySpent,
      dailyLimit: settings.dailyLimit,
      weeklyLimit: settings.weeklyLimit,
      monthlyLimit: settings.monthlyLimit,
      monthlyComparison: monthlyComparison,
      recentTransactions: recentTransactions,
      categoryBreakdown: breakdown,
      timeRange: range,
    );
  }

  (DateTime, DateTime) _getDatesForRange(TimeRange range, DateTime now) {
    return switch (range) {
      TimeRange.daily => (DateHelper.startOfToday, now),
      TimeRange.weekly => (DateHelper.startOfThisWeek, now),
      TimeRange.monthly => (DateHelper.startOfThisMonth, now),
    };
  }

  Map<int, SettingsCategory> _flattenCategories(List<SettingsCategory> roots) {
    final result = <int, SettingsCategory>{};

    void visit(SettingsCategory category) {
      result[category.id] = category;
      for (final child in category.children) {
        visit(child);
      }
    }

    for (final category in roots) {
      visit(category);
    }

    return result;
  }

  FinanceTransaction _toTransaction({
    required Expense expense,
    required Map<int, SettingsCategory> categories,
  }) {
    final category = categories[expense.categoryId];
    final amount = expense.amount.abs();
    return FinanceTransaction(
      id: expense.id,
      title: expense.title ?? category?.title ?? 'Expense',
      subtitle: _formatTransactionDate(expense.date),
      amount: amount,
      icon: category?.icon ?? 'more_horiz',
      color: category?.color ?? 0xFF64748B,
      date: expense.date,
    );
  }

  List<FinanceCategoryBreakdown> _buildCategoryBreakdown({
    required List<Expense> expenses,
    required Map<int, SettingsCategory> categories,
  }) {
    if (expenses.isEmpty) {
      return const [];
    }

    final totals = <int, double>{};
    for (final expense in expenses) {
      totals[expense.categoryId] = (totals[expense.categoryId] ?? 0) + expense.amount.abs();
    }

    final totalSpent = totals.values.fold<double>(0, (sum, value) => sum + value);
    if (totalSpent <= 0) {
      return const [];
    }

    final items = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return items.map((entry) {
      final category = categories[entry.key];
      return FinanceCategoryBreakdown(
        categoryId: entry.key,
        title: category?.title ?? 'Uncategorized',
        icon: category?.icon ?? 'more_horiz',
        color: category?.color ?? 0xFF64748B,
        amount: entry.value,
        percentage: entry.value / totalSpent,
      );
    }).toList();
  }

  String _currencySymbol(String currencyCode) {
    return switch (currencyCode.toLowerCase()) {
      'usd' => '\$',
      'eur' => '€',
      'inr' => '₹',
      _ => currencyCode.toUpperCase(),
    };
  }

  String _formatTransactionDate(DateTime date) {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final transactionDay = DateTime(date.year, date.month, date.day);

    if (transactionDay == startOfToday) {
      return 'Today, ${_formatTime(date)}';
    }

    if (transactionDay == startOfToday.subtract(const Duration(days: 1))) {
      return 'Yesterday, ${_formatTime(date)}';
    }

    return '${_monthName(date.month)} ${date.day}, ${date.year}';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final suffix = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $suffix';
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
