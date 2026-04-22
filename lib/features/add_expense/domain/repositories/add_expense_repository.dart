import 'package:expense_tracker/core/error/result.dart';
import 'package:expense_tracker/features/settings/domain/entities/settings_snapshot.dart';

abstract interface class AddExpenseRepository {
  ResultFuture<SettingsSnapshot> loadFormData();

  ResultVoid addExpense({
    required double amount,
    String? title,
    required int categoryId,
    required String currencyCode,
    DateTime? date,
  });
}
