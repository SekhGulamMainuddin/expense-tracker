import 'package:expense_tracker/core/error/result.dart';
import 'package:expense_tracker/features/settings/domain/entities/settings_snapshot.dart';
import 'package:expense_tracker/features/settings/domain/entities/custom_icon_entity.dart';
import 'package:expense_tracker/core/domain/entities/app_theme.dart';
import 'package:expense_tracker/core/domain/entities/currency.dart';

abstract interface class SettingsRepository {
  ResultFuture<SettingsSnapshot> loadSettings();

  ResultVoid updateThemeMode(AppTheme theme);

  ResultVoid updateBaseCurrency(Currency currency);

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

  ResultVoid addCustomIcon({
    required String name,
    required String iconUrl,
  });

  Stream<List<CustomIconEntity>> watchCustomIcons();
}
