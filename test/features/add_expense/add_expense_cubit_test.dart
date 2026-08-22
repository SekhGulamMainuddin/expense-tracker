import 'package:expense_tracker/core/error/result.dart';
import 'package:expense_tracker/features/add_expense/domain/entities/editable_expense.dart';
import 'package:expense_tracker/features/add_expense/domain/repositories/add_expense_repository.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_cubit.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_state.dart';
import 'package:expense_tracker/features/settings/domain/entities/settings_category.dart';
import 'package:expense_tracker/features/settings/domain/entities/settings_snapshot.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_test/flutter_test.dart';

const _categories = [
  SettingsCategory(
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
  ),
  SettingsCategory(
    id: 3,
    title: 'Travel',
    icon: 'flight',
    color: 0xFF2196F3,
  ),
];

SettingsSnapshot _snapshot({List<SettingsCategory> categories = _categories}) {
  return SettingsSnapshot(
    themeMode: ThemeMode.system,
    baseCurrencyCode: 'inr',
    dailyLimit: 1000,
    weeklyLimit: 7000,
    monthlyLimit: 30000,
    safeThreshold: 10,
    cautionThreshold: 15,
    dangerThreshold: 25,
    categories: categories,
    customIcons: const [],
  );
}

class _FakeAddExpenseRepository implements AddExpenseRepository {
  _FakeAddExpenseRepository({
    SettingsSnapshot? snapshot,
    this.expense,
    this.failWith,
  }) : snapshot = snapshot ?? _snapshot();

  final SettingsSnapshot snapshot;
  final EditableExpense? expense;

  /// When set, every mutation fails with this message.
  final String? failWith;

  final List<String> calls = [];
  double? lastAmount;
  String? lastTitle;
  int? lastCategoryId;
  int? deletedId;

  @override
  ResultFuture<SettingsSnapshot> loadFormData() async => Success(snapshot);

  @override
  ResultFuture<EditableExpense> getExpense(int id) async {
    final found = expense;
    if (found == null) return Error(DatabaseFailure('Expense not found'));
    return Success(found);
  }

  @override
  ResultVoid addExpense({
    required double amount,
    String? title,
    required int categoryId,
    required String currencyCode,
    DateTime? date,
  }) async {
    calls.add('add');
    lastAmount = amount;
    lastTitle = title;
    lastCategoryId = categoryId;
    return failWith == null
        ? const Success(null)
        : Error(DatabaseFailure(failWith!));
  }

  @override
  ResultVoid updateExpense({
    required int id,
    required double amount,
    String? title,
    required int categoryId,
    required String currencyCode,
    DateTime? date,
  }) async {
    calls.add('update');
    lastAmount = amount;
    lastTitle = title;
    lastCategoryId = categoryId;
    return failWith == null
        ? const Success(null)
        : Error(DatabaseFailure(failWith!));
  }

  @override
  ResultVoid deleteExpense(int id) async {
    calls.add('delete');
    deletedId = id;
    return failWith == null
        ? const Success(null)
        : Error(DatabaseFailure(failWith!));
  }
}

/// Builds a cubit already settled in [AddExpenseLoaded].
Future<AddExpenseCubit> _loadedCubit(
  _FakeAddExpenseRepository repo, {
  int? transactionId,
  AddExpenseMode? mode,
}) async {
  final cubit = AddExpenseCubit(repo);
  await cubit.loadFormData(transactionId: transactionId, mode: mode);
  return cubit;
}

void main() {
  group('loadFormData in create mode', () {
    test('preselects the first root and its first child', () async {
      final cubit = await _loadedCubit(_FakeAddExpenseRepository());

      final state = cubit.state as AddExpenseLoaded;
      expect(state.mode, AddExpenseMode.create);
      expect(state.selectedCategoryId, 1);
      expect(state.selectedSubcategoryId, 2);
      expect(state.generatedTitle, 'Food | Coffee');
      await cubit.close();
    });

    test('fails clearly when there are no categories to spend against',
        () async {
      final cubit = await _loadedCubit(
        _FakeAddExpenseRepository(snapshot: _snapshot(categories: const [])),
      );

      expect(cubit.state, isA<AddExpenseFailure>());
      await cubit.close();
    });
  });

  group('loadFormData in view mode', () {
    test('maps a subcategory expense back onto root + sub', () async {
      final repo = _FakeAddExpenseRepository(
        expense: EditableExpense(
          id: 7,
          amount: 123.4,
          title: 'Morning latte',
          categoryId: 2,
          date: DateTime(2026, 8, 22),
        ),
      );

      final cubit = await _loadedCubit(
        repo,
        transactionId: 7,
        mode: AddExpenseMode.view,
      );

      final state = cubit.state as AddExpenseLoaded;
      expect(state.selectedCategoryId, 1);
      expect(state.selectedSubcategoryId, 2);
      expect(state.transactionId, 7);
      // Always rendered at 2dp so the field never shows float noise.
      expect(state.amount, '123.40');
      await cubit.close();
    });

    test('a root-category expense has no subcategory selected', () async {
      final repo = _FakeAddExpenseRepository(
        expense: EditableExpense(
          id: 8,
          amount: 500,
          title: null,
          categoryId: 3,
          date: DateTime(2026, 8, 22),
        ),
      );

      final cubit = await _loadedCubit(
        repo,
        transactionId: 8,
        mode: AddExpenseMode.view,
      );

      final state = cubit.state as AddExpenseLoaded;
      expect(state.selectedCategoryId, 3);
      expect(state.selectedSubcategoryId, isNull);
      await cubit.close();
    });
  });

  group('updateAmount', () {
    test('caps the fraction at two digits', () async {
      final cubit = await _loadedCubit(_FakeAddExpenseRepository());

      cubit.updateAmount('12.3456');

      expect((cubit.state as AddExpenseLoaded).amount, '12.34');
      await cubit.close();
    });

    test('strips characters a paste could smuggle in', () async {
      final cubit = await _loadedCubit(_FakeAddExpenseRepository());

      cubit.updateAmount('1a2b.5c');

      expect((cubit.state as AddExpenseLoaded).amount, '12.5');
      await cubit.close();
    });

    test('collapses a second decimal point', () async {
      final cubit = await _loadedCubit(_FakeAddExpenseRepository());

      cubit.updateAmount('1.2.3');

      expect((cubit.state as AddExpenseLoaded).amount, '1.23');
      await cubit.close();
    });

    test('keeps a trailing point so the user can keep typing', () async {
      final cubit = await _loadedCubit(_FakeAddExpenseRepository());

      cubit.updateAmount('12.');

      expect((cubit.state as AddExpenseLoaded).amount, '12.');
      await cubit.close();
    });

    test('clears to empty when everything is deleted', () async {
      final cubit = await _loadedCubit(_FakeAddExpenseRepository());

      cubit.updateAmount('abc');

      expect((cubit.state as AddExpenseLoaded).amount, '');
      await cubit.close();
    });
  });

  group('category selection', () {
    test('switching root selects that root\'s first child', () async {
      final cubit = await _loadedCubit(_FakeAddExpenseRepository());

      cubit.selectCategory(3);

      final state = cubit.state as AddExpenseLoaded;
      expect(state.selectedCategoryId, 3);
      expect(state.selectedSubcategoryId, isNull);
      expect(state.generatedTitle, 'Travel');
      await cubit.close();
    });

    test('an unknown category id is ignored', () async {
      final cubit = await _loadedCubit(_FakeAddExpenseRepository());

      cubit.selectCategory(999);

      expect((cubit.state as AddExpenseLoaded).selectedCategoryId, 1);
      await cubit.close();
    });
  });

  group('submitExpense', () {
    test('rejects a zero amount without touching the repository', () async {
      final repo = _FakeAddExpenseRepository();
      final cubit = await _loadedCubit(repo);

      cubit.updateAmount('0');
      final ok = await cubit.submitExpense();

      expect(ok, isFalse);
      expect(repo.calls, isEmpty);
      expect((cubit.state as AddExpenseLoaded).errorMessage, isNotNull);
      await cubit.close();
    });

    test('rejects an empty amount', () async {
      final repo = _FakeAddExpenseRepository();
      final cubit = await _loadedCubit(repo);

      cubit.updateAmount('');
      expect(await cubit.submitExpense(), isFalse);
      expect(repo.calls, isEmpty);
      await cubit.close();
    });

    test('submits the deepest selected category', () async {
      final repo = _FakeAddExpenseRepository();
      final cubit = await _loadedCubit(repo);

      cubit.updateAmount('250.75');
      final ok = await cubit.submitExpense();

      expect(ok, isTrue);
      expect(repo.calls, ['add']);
      expect(repo.lastAmount, 250.75);
      expect(repo.lastCategoryId, 2);
      expect(cubit.state, isA<AddExpenseSuccess>());
      await cubit.close();
    });

    test('a blank title is stored as null so the fallback kicks in', () async {
      final repo = _FakeAddExpenseRepository();
      final cubit = await _loadedCubit(repo);

      cubit.updateAmount('10');
      cubit.updateTitle('   ');
      await cubit.submitExpense();

      expect(repo.lastTitle, isNull);
      await cubit.close();
    });

    test('trims a supplied title', () async {
      final repo = _FakeAddExpenseRepository();
      final cubit = await _loadedCubit(repo);

      cubit.updateAmount('10');
      cubit.updateTitle('  Latte  ');
      await cubit.submitExpense();

      expect(repo.lastTitle, 'Latte');
      await cubit.close();
    });

    test('edit mode updates instead of inserting', () async {
      final repo = _FakeAddExpenseRepository(
        expense: EditableExpense(
          id: 7,
          amount: 100,
          title: 'Old',
          categoryId: 2,
          date: DateTime(2026, 8, 22),
        ),
      );
      final cubit = await _loadedCubit(
        repo,
        transactionId: 7,
        mode: AddExpenseMode.edit,
      );

      cubit.updateAmount('99');
      await cubit.submitExpense();

      expect(repo.calls, ['update']);
      await cubit.close();
    });

    test('a failure keeps the form filled in so nothing is retyped', () async {
      final repo = _FakeAddExpenseRepository(failWith: 'disk full');
      final cubit = await _loadedCubit(repo);

      cubit.updateAmount('10');
      final ok = await cubit.submitExpense();

      expect(ok, isFalse);
      final state = cubit.state as AddExpenseLoaded;
      expect(state.errorMessage, 'disk full');
      expect(state.amount, '10');
      expect(state.isSubmitting, isFalse);
      await cubit.close();
    });
  });

  group('deleteExpense', () {
    test('deletes the loaded row and reports it', () async {
      final repo = _FakeAddExpenseRepository(
        expense: EditableExpense(
          id: 7,
          amount: 100,
          title: null,
          categoryId: 2,
          date: DateTime(2026, 8, 22),
        ),
      );
      final cubit = await _loadedCubit(
        repo,
        transactionId: 7,
        mode: AddExpenseMode.view,
      );

      final ok = await cubit.deleteExpense();

      expect(ok, isTrue);
      expect(repo.deletedId, 7);
      expect(cubit.state, isA<AddExpenseDeleted>());
      await cubit.close();
    });

    test('is a no-op while creating, since no row exists yet', () async {
      final repo = _FakeAddExpenseRepository();
      final cubit = await _loadedCubit(repo);

      expect(await cubit.deleteExpense(), isFalse);
      expect(repo.calls, isEmpty);
      await cubit.close();
    });

    test('surfaces a failure and stays on the form', () async {
      final repo = _FakeAddExpenseRepository(
        expense: EditableExpense(
          id: 7,
          amount: 100,
          title: null,
          categoryId: 2,
          date: DateTime(2026, 8, 22),
        ),
        failWith: 'row is locked',
      );
      final cubit = await _loadedCubit(
        repo,
        transactionId: 7,
        mode: AddExpenseMode.view,
      );

      expect(await cubit.deleteExpense(), isFalse);
      expect((cubit.state as AddExpenseLoaded).errorMessage, 'row is locked');
      await cubit.close();
    });
  });
}
