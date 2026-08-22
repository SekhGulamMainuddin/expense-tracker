import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/core/domain/entities/currency.dart';
import 'package:expense_tracker/core/exchange/domain/entities/exchange_rates.dart';
import 'package:expense_tracker/features/home/data/mappers/finance_transaction_mapper.dart';
import 'package:expense_tracker/features/settings/domain/entities/settings_category.dart';
import 'package:flutter_test/flutter_test.dart';

Expense _expense({
  int id = 1,
  String? title,
  double amount = 100,
  double baseAmount = 100,
  int categoryId = 1,
  DateTime? date,
}) {
  return Expense(
    id: id,
    title: title,
    amount: amount,
    baseAmount: baseAmount,
    date: date ?? DateTime(2026, 8, 22),
    categoryId: categoryId,
    currency: Currency.inr,
  );
}

const _food = SettingsCategory(
  id: 1,
  title: 'Food',
  icon: 'restaurant',
  color: 0xFFFF5722,
  children: [
    SettingsCategory(
      id: 2,
      title: 'Coffee',
      icon: 'coffee',
      color: 0xFF795548,
      parentId: 1,
    ),
  ],
);

/// A root stored with parentId 0 rather than null, which the seed data and
/// older rows both produce.
const _zeroParentRoot = SettingsCategory(
  id: 3,
  title: 'Shopping',
  icon: 'shopping_bag',
  color: 0xFF00BCD4,
  parentId: 0,
);

void main() {
  final rates = ExchangeRates(
    ratesToInr: {Currency.inr: 1.0, Currency.usd: 86.0},
    fetchedAt: DateTime(2026, 8, 22),
    isFallback: false,
  );

  group('flattenCategories', () {
    test('indexes roots and children in one map', () {
      final flat = flattenCategories([_food]);

      expect(flat.keys, containsAll([1, 2]));
      expect(flat[2]!.title, 'Coffee');
    });

    test('returns an empty map for no categories', () {
      expect(flattenCategories([]), isEmpty);
    });
  });

  group('rootCategoryIdOf', () {
    test('a child resolves to its parent', () {
      expect(rootCategoryIdOf(_food.children.first), 1);
    });

    test('a null-parent root resolves to itself', () {
      expect(rootCategoryIdOf(_food), 1);
    });

    test('a zero-parent root resolves to itself, not category 0', () {
      expect(rootCategoryIdOf(_zeroParentRoot), 3);
    });
  });

  group('mapExpenseToTransaction', () {
    final categories = flattenCategories([_food, _zeroParentRoot]);

    test('keeps a user-supplied title', () {
      final tx = mapExpenseToTransaction(
        expense: _expense(title: 'Morning latte', categoryId: 2),
        categories: categories,
        targetCurrency: Currency.inr,
        rates: rates,
      );

      expect(tx.title, 'Morning latte');
    });

    test('falls back to "Parent | Child" for an untitled subcategory expense',
        () {
      final tx = mapExpenseToTransaction(
        expense: _expense(categoryId: 2),
        categories: categories,
        targetCurrency: Currency.inr,
        rates: rates,
      );

      expect(tx.title, 'Food | Coffee');
    });

    test('falls back to the category title for an untitled root expense', () {
      final tx = mapExpenseToTransaction(
        expense: _expense(categoryId: 1),
        categories: categories,
        targetCurrency: Currency.inr,
        rates: rates,
      );

      expect(tx.title, 'Food');
    });

    test('does not prefix a zero-parent root with a phantom parent', () {
      final tx = mapExpenseToTransaction(
        expense: _expense(categoryId: 3),
        categories: categories,
        targetCurrency: Currency.inr,
        rates: rates,
      );

      expect(tx.title, 'Shopping');
    });

    test('treats an empty title the same as no title', () {
      final tx = mapExpenseToTransaction(
        expense: _expense(title: '', categoryId: 1),
        categories: categories,
        targetCurrency: Currency.inr,
        rates: rates,
      );

      expect(tx.title, 'Food');
    });

    test('survives an expense whose category was deleted', () {
      final tx = mapExpenseToTransaction(
        expense: _expense(categoryId: 999),
        categories: categories,
        targetCurrency: Currency.inr,
        rates: rates,
      );

      expect(tx.title, 'Expense');
      expect(tx.icon, 'receipt_long');
    });

    test('converts the stored base amount into the display currency', () {
      final tx = mapExpenseToTransaction(
        expense: _expense(baseAmount: 860, categoryId: 1),
        categories: categories,
        targetCurrency: Currency.usd,
        rates: rates,
      );

      expect(tx.amount, closeTo(10, 1e-9));
    });

    test('reports a magnitude even if a base amount was stored negative', () {
      final tx = mapExpenseToTransaction(
        expense: _expense(baseAmount: -250, categoryId: 1),
        categories: categories,
        targetCurrency: Currency.inr,
        rates: rates,
      );

      expect(tx.amount, 250);
    });

    test('carries the category icon and colour through', () {
      final tx = mapExpenseToTransaction(
        expense: _expense(categoryId: 2),
        categories: categories,
        targetCurrency: Currency.inr,
        rates: rates,
      );

      expect(tx.icon, 'coffee');
      expect(tx.color, 0xFF795548);
    });
  });
}
