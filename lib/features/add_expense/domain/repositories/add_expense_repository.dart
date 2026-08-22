import 'package:expense_tracker/core/error/result.dart';
import 'package:expense_tracker/features/add_expense/domain/entities/editable_expense.dart';
import 'package:expense_tracker/features/settings/domain/entities/settings_snapshot.dart';

abstract interface class AddExpenseRepository {
  ResultFuture<SettingsSnapshot> loadFormData();
  
  ResultFuture<EditableExpense> getExpense(int id);

  ResultVoid addExpense({
    required double amount,
    String? title,
    required int categoryId,
    required String currencyCode,
    DateTime? date,
  });

  ResultVoid deleteExpense(int id);

  ResultVoid updateExpense({
    required int id,
    required double amount,
    String? title,
    required int categoryId,
    required String currencyCode,
    DateTime? date,
  });
}
