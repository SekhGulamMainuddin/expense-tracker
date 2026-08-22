import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/core/domain/entities/currency.dart';
import 'package:expense_tracker/core/exchange/domain/entities/exchange_rates.dart';
import 'package:expense_tracker/core/utils/date_helper.dart';
import 'package:expense_tracker/features/home/domain/entities/finance_transaction.dart';
import 'package:expense_tracker/features/settings/domain/entities/settings_category.dart';

/// Shared expense -> [FinanceTransaction] mapping used by both the dashboard
/// and the transaction list, so the two never drift on title fallbacks or
/// currency normalization.

/// Collapses the two-level category tree into a flat id lookup.
Map<int, SettingsCategory> flattenCategories(List<SettingsCategory> list) {
  final result = <int, SettingsCategory>{};
  for (final cat in list) {
    result[cat.id] = cat;
    for (final child in cat.children) {
      result[child.id] = child;
    }
  }
  return result;
}

/// Resolves the root category id for a category, treating a null/0 parent as
/// "this is already a root".
int rootCategoryIdOf(SettingsCategory category) {
  final parentId = category.parentId;
  return (parentId == null || parentId == 0) ? category.id : parentId;
}

FinanceTransaction mapExpenseToTransaction({
  required Expense expense,
  required Map<int, SettingsCategory> categories,
  required Currency targetCurrency,
  required ExchangeRates rates,
}) {
  final category = categories[expense.categoryId];

  // baseAmount is the INR-normalized truth; convert it into the display currency.
  final amount = rates.fromBase(expense.baseAmount, targetCurrency).abs();

  return FinanceTransaction(
    id: expense.id,
    title: _displayTitle(expense, category, categories),
    subtitle: DateHelper.formatTransactionDate(expense.date),
    amount: amount,
    icon: category?.icon ?? 'receipt_long',
    color: category?.color ?? 0xFF64748B,
    date: expense.date,
  );
}

String _displayTitle(
  Expense expense,
  SettingsCategory? category,
  Map<int, SettingsCategory> categories,
) {
  final title = expense.title ?? '';
  if (title.isNotEmpty) return title;
  if (category == null) return 'Expense';

  final parentId = category.parentId;
  if (parentId != null && parentId != 0) {
    final parent = categories[parentId];
    return parent != null ? '${parent.title} | ${category.title}' : category.title;
  }
  return category.title;
}
