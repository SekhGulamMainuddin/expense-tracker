import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/expense_table.dart';

part 'expense_dao.g.dart';

@DriftAccessor(tables: [Expenses, Categories])
class ExpenseDao extends DatabaseAccessor<AppDatabase> with _$ExpenseDaoMixin {
  ExpenseDao(super.db);

  // --- 1. Aggregations (Arithmetic Safe) ---
  /// Calculates total expense in cents for a given date range.
  Future<double> getTotalExpense(DateTime start, DateTime end) async {
    final query = selectOnly(expenses)..addColumns([expenses.amount.sum()]);
    query.where(expenses.date.isBetweenValues(start, end));
    final result = await query.getSingle();
    return result.read(expenses.amount.sum()) ?? 0;
  }

  /// Compares (1st of this month -> now) vs (1st of last month -> same day last month).
  Future<double> getMonthlyComparison() async {
    final now = DateTime.now();
    final thisMonthStart = DateTime(now.year, now.month, 1);

    // Calculate equivalent day last month
    final lastMonthStart = DateTime(now.year, now.month - 1, 1);
    final lastMonthEquivalent = DateTime(now.year, now.month - 1, now.day);

    final thisMonthTotal = await getTotalExpense(thisMonthStart, now);
    final lastMonthTotal = await getTotalExpense(
      lastMonthStart,
      lastMonthEquivalent,
    );

    if (lastMonthTotal == 0) return thisMonthTotal > 0 ? 100.0 : 0.0;

    // Returns percentage change (e.g., 20.0 for 20% increase)
    return ((thisMonthTotal - lastMonthTotal) / lastMonthTotal) * 100;
  }

  // --- 2. Categories & Subcategories ---

  /// Returns a list of all categories (parents and children).
  Future<List<Category>> getAllCategories() => select(categories).get();

  /// Returns subcategories for a specific parent.
  Future<List<Category>> getSubcategories(int parentId) {
    return (select(
      categories,
    )..where((t) => t.parentId.equals(parentId))).get();
  }

  Future<int> insertCategory(CategoriesCompanion entry) =>
      into(categories).insert(entry);

  Future<int> createCategory({
    required String title,
    required String icon,
    required int color,
    int? parentId,
  }) {
    return into(categories).insert(
      CategoriesCompanion.insert(
        title: title,
        icon: icon,
        color: color,
        parentId: parentId == null ? const Value.absent() : Value(parentId),
      ),
    );
  }

  Future<int> updateCategoryValues({
    required int id,
    required String title,
    required String icon,
    required int color,
    int? parentId,
  }) {
    return (update(categories)..where((t) => t.id.equals(id))).write(
      CategoriesCompanion(
        title: Value(title),
        icon: Value(icon),
        color: Value(color),
        parentId:
            parentId == null ? const Value.absent() : Value(parentId),
      ),
    );
  }

  Future<bool> updateCategory(Category entry) =>
      update(categories).replace(entry);

  Future<int> deleteCategory(int id) =>
      (delete(categories)..where((t) => t.id.equals(id))).go();

  Future<int> reassignExpensesToCategory(
    List<int> fromCategoryIds,
    int toCategoryId,
  ) {
    return (update(expenses)..where(
      (t) => t.categoryId.isIn(fromCategoryIds),
    )).write(
      ExpensesCompanion(
        categoryId: Value(toCategoryId),
      ),
    );
  }

  // --- 3. Transactions ---

  /// Returns paginated transactions, ordered by date descending.
  Future<List<Expense>> getRecentTransactions(int limit, int offset) {
    return (select(expenses)
          ..orderBy([
            (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
          ])
          ..limit(limit, offset: offset))
        .get();
  }

  Future<List<Expense>> getExpensesInRange(DateTime start, DateTime end) {
    return (select(expenses)
          ..where((t) => t.date.isBetweenValues(start, end))
          ..orderBy([
            (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
          ]))
        .get();
  }

  /// Returns the top 3 categories by total amount spent.
  Future<List<Map<String, dynamic>>> getTopCategories(
    DateTime start,
    DateTime end,
  ) async {
    final query = select(expenses).join([
      innerJoin(categories, categories.id.equalsExp(expenses.categoryId)),
    ]);
    query.addColumns([categories.title, expenses.amount.sum()]);
    query.where(expenses.date.isBetweenValues(start, end));
    query.groupBy([categories.id]);
    query.orderBy([
      OrderingTerm(expression: expenses.amount.sum(), mode: OrderingMode.desc),
    ]);
    query.limit(3);

    final rows = await query.get();
    return rows
        .map(
          (row) => {
            'category': row.read(categories.title),
            'total': row.read(expenses.amount.sum()) ?? 0,
          },
        )
        .toList();
  }

  // --- 4. Watch Streams (Reactive Triggers) ---

  /// Emits whenever any row in the expenses table changes.
  /// Used as a change trigger for the reactive dashboard.
  Stream<List<Expense>> watchAllExpenses() => select(expenses).watch();

  /// Emits whenever any row in the categories table changes.
  Stream<List<Category>> watchAllCategories() => select(categories).watch();

  // --- 5. Add Expense (Safe Fallback) ---

  Future<Expense?> getExpenseById(int id) {
    return (select(expenses)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Adds an expense with fallback title logic and enum currency.
  Future<int> addExpense({
    required double amount,
    String? title,
    required int categoryId,
    Currency currency = Currency.inr,
    DateTime? date,
  }) async {
    final expenseDate = date ?? DateTime.now();

    final expenseTitle = title ?? "";

    return into(expenses).insert(
      ExpensesCompanion.insert(
        title: Value(expenseTitle),
        amount: amount,
        date: expenseDate,
        categoryId: categoryId,
        currency: Value(currency),
      ),
    );
  }

  Future<bool> updateExpenseValues({
    required int id,
    required double amount,
    String? title,
    required int categoryId,
    Currency currency = Currency.inr,
    DateTime? date,
  }) async {
    final expenseDate = date ?? DateTime.now();
    final expenseTitle = title ?? "";

    return (update(expenses)..where((t) => t.id.equals(id))).write(
      ExpensesCompanion(
        title: Value(expenseTitle),
        amount: Value(amount),
        date: Value(expenseDate),
        categoryId: Value(categoryId),
        currency: Value(currency),
      ),
    ).then((value) => value > 0);
  }
}
