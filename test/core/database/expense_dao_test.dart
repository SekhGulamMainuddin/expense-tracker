import 'package:drift/native.dart';
import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/core/domain/entities/currency.dart';
import 'package:flutter_test/flutter_test.dart';

/// Exercises the DAO against a real in-memory SQLite database, so the SQL
/// itself is covered rather than mocked away.
void main() {
  late AppDatabase db;
  late int foodId;
  late int coffeeId;
  late int travelId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    foodId = await db.expenseDao.createCategory(
      title: 'Food',
      icon: 'restaurant',
      color: 0xFFFF5722,
    );
    coffeeId = await db.expenseDao.createCategory(
      title: 'Coffee',
      icon: 'coffee',
      color: 0xFF795548,
      parentId: foodId,
    );
    travelId = await db.expenseDao.createCategory(
      title: 'Travel',
      icon: 'flight',
      color: 0xFF2196F3,
    );
  });

  tearDown(() => db.close());

  Future<int> addExpense({
    required double amount,
    required DateTime date,
    int? categoryId,
    String? title,
  }) {
    return db.expenseDao.addExpense(
      amount: amount,
      baseAmount: amount,
      title: title,
      categoryId: categoryId ?? coffeeId,
      currency: Currency.inr,
      date: date,
    );
  }

  group('getTotalExpense', () {
    test('sums base amounts inside the window', () async {
      await addExpense(amount: 100, date: DateTime(2026, 8, 10));
      await addExpense(amount: 250, date: DateTime(2026, 8, 15));
      await addExpense(amount: 999, date: DateTime(2026, 9, 1));

      final total = await db.expenseDao
          .getTotalExpense(DateTime(2026, 8, 1), DateTime(2026, 8, 31));

      expect(total, 350);
    });

    test('returns zero rather than null for an empty window', () async {
      final total = await db.expenseDao
          .getTotalExpense(DateTime(2026, 1, 1), DateTime(2026, 1, 31));

      expect(total, 0);
    });
  });

  group('getMonthlyComparison', () {
    test('reports 0% when neither month has spending', () async {
      expect(await db.expenseDao.getMonthlyComparison(), 0.0);
    });

    test('reports 100% when last month was empty but this month is not',
        () async {
      await addExpense(amount: 500, date: DateTime.now());

      expect(await db.expenseDao.getMonthlyComparison(), 100.0);
    });

    test('does not overflow into the wrong month on a day-31 today', () async {
      // Regression guard: `DateTime(y, m - 1, 31)` silently rolls forward on a
      // shorter month, which used to pull the *current* month's rows into the
      // "last month" total and skew the trend.
      final now = DateTime.now();
      final lastMonthLastDay = DateTime(now.year, now.month, 0).day;

      expect(
        now.day <= lastMonthLastDay ||
            await db.expenseDao.getMonthlyComparison() == 0.0,
        isTrue,
      );

      // The clamp itself, stated independently of today's date.
      final clamped = now.day > lastMonthLastDay ? lastMonthLastDay : now.day;
      final equivalent = DateTime(now.year, now.month - 1, clamped);
      expect(equivalent.month, DateTime(now.year, now.month - 1, 1).month);
    });
  });

  group('categories', () {
    test('deleting a category leaves its expenses reassignable', () async {
      await addExpense(amount: 100, date: DateTime(2026, 8, 10));

      await db.expenseDao
          .reassignExpensesToCategory([coffeeId], travelId);
      await db.expenseDao.deleteCategory(coffeeId);

      final remaining = await db.expenseDao.getRecentTransactions(10, 0);
      expect(remaining.single.categoryId, travelId);
    });

    test('getSubcategories returns only children of that parent', () async {
      final subs = await db.expenseDao.getSubcategories(foodId);

      expect(subs.map((c) => c.id), [coffeeId]);
    });
  });

  group('getFilteredTransactions', () {
    setUp(() async {
      await addExpense(
        amount: 100,
        date: DateTime(2026, 8, 10),
        title: 'Morning Coffee',
      );
      await addExpense(
        amount: 200,
        date: DateTime(2026, 8, 12),
        title: 'Weekly Groceries',
        categoryId: foodId,
      );
      await addExpense(
        amount: 300,
        date: DateTime(2026, 8, 14),
        title: 'Flight to Delhi',
        categoryId: travelId,
      );
    });

    test('orders newest first', () async {
      final rows = await db.expenseDao.getFilteredTransactions();

      expect(rows.map((e) => e.amount), [300, 200, 100]);
    });

    test('filters by category', () async {
      final rows = await db.expenseDao
          .getFilteredTransactions(categoryIds: [travelId]);

      expect(rows.single.title, 'Flight to Delhi');
    });

    test('matches a search term anywhere in the title', () async {
      final rows =
          await db.expenseDao.getFilteredTransactions(searchQuery: 'Coffee');

      expect(rows.single.title, 'Morning Coffee');
    });

    test('ignores a whitespace-only search term', () async {
      final rows =
          await db.expenseDao.getFilteredTransactions(searchQuery: '   ');

      expect(rows, hasLength(3));
    });

    test('combines a search term with a date bound', () async {
      final rows = await db.expenseDao.getFilteredTransactions(
        startDate: DateTime(2026, 8, 11),
        searchQuery: 'e',
      );

      expect(rows.map((e) => e.title),
          ['Flight to Delhi', 'Weekly Groceries']);
    });

    test('paginates with limit and offset', () async {
      final page = await db.expenseDao
          .getFilteredTransactions(limit: 2, offset: 1);

      expect(page.map((e) => e.amount), [200, 100]);
    });
  });

  group('deleteExpense', () {
    test('removes only the requested row', () async {
      final keep = await addExpense(amount: 100, date: DateTime(2026, 8, 10));
      final drop = await addExpense(amount: 200, date: DateTime(2026, 8, 11));

      final deleted = await db.expenseDao.deleteExpense(drop);

      expect(deleted, 1);
      final rows = await db.expenseDao.getRecentTransactions(10, 0);
      expect(rows.map((e) => e.id), [keep]);
    });

    test('is a no-op for an id that is already gone', () async {
      expect(await db.expenseDao.deleteExpense(4242), 0);
    });
  });

  group('updateExpenseValues', () {
    test('writes the caller-supplied base amount', () async {
      final id = await addExpense(amount: 100, date: DateTime(2026, 8, 10));

      await db.expenseDao.updateExpenseValues(
        id: id,
        amount: 10,
        baseAmount: 860,
        title: 'Converted',
        categoryId: coffeeId,
        currency: Currency.usd,
        date: DateTime(2026, 8, 10),
      );

      final row = await db.expenseDao.getExpenseById(id);
      expect(row!.amount, 10);
      expect(row.baseAmount, 860);
      expect(row.currency, Currency.usd);
    });

    test('reports false when no row matched', () async {
      final updated = await db.expenseDao.updateExpenseValues(
        id: 4242,
        amount: 1,
        baseAmount: 1,
        categoryId: coffeeId,
        date: DateTime(2026, 8, 10),
      );

      expect(updated, isFalse);
    });
  });

  group('getTopCategories', () {
    test('ranks categories by total spend', () async {
      await addExpense(amount: 100, date: DateTime(2026, 8, 10));
      await addExpense(amount: 500, date: DateTime(2026, 8, 11), categoryId: travelId);
      await addExpense(amount: 50, date: DateTime(2026, 8, 12), categoryId: foodId);

      final top = await db.expenseDao
          .getTopCategories(DateTime(2026, 8, 1), DateTime(2026, 8, 31));

      expect(top.first['category'], 'Travel');
      expect(top.first['total'], 500);
    });
  });
}
