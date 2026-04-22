import 'package:expense_tracker/core/error/result.dart';
import 'package:expense_tracker/features/settings/domain/entities/settings_snapshot.dart';

abstract interface class SettingsRepository {
  ResultFuture<SettingsSnapshot> loadSettings();

  ResultVoid updateThemeMode(String mode);

  ResultVoid updateBaseCurrency(String currencyCode);

  ResultVoid updateBudgetLimit(String key, double value);

  ResultVoid updateThreshold(String key, double value);

  ResultVoid addCategory({
    required String title,
    required String icon,
    required int color,
    int? parentId,
  });

  ResultVoid updateCategory({
    required int id,
    required String title,
    required String icon,
    required int color,
    int? parentId,
  });

  ResultVoid deleteCategory(int id);
}
