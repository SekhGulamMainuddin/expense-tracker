import 'package:expense_tracker/core/error/result.dart';
import 'package:expense_tracker/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:expense_tracker/features/settings/domain/entities/settings_snapshot.dart';
import 'package:expense_tracker/features/settings/domain/repositories/settings_repository.dart';

final class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._localDataSource);

  final SettingsLocalDataSource _localDataSource;

  @override
  ResultFuture<SettingsSnapshot> loadSettings() async {
    try {
      final snapshot = await _localDataSource.loadSettings();
      return Success(snapshot);
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }

  @override
  ResultVoid updateThemeMode(String mode) async {
    try {
      await _localDataSource.updateThemeMode(mode);
      return const Success(null);
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }

  @override
  ResultVoid updateBaseCurrency(String currencyCode) async {
    try {
      await _localDataSource.updateBaseCurrency(currencyCode);
      return const Success(null);
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }

  @override
  ResultVoid updateBudgetLimit(String key, double value) async {
    try {
      await _localDataSource.updateBudgetLimit(key, value);
      return const Success(null);
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }

  @override
  ResultVoid updateThreshold(String key, double value) async {
    try {
      await _localDataSource.updateThreshold(key, value);
      return const Success(null);
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }

  @override
  ResultVoid addCategory({
    required String title,
    required String icon,
    required int color,
    int? parentId,
  }) async {
    try {
      await _localDataSource.addCategory(
        title: title,
        icon: icon,
        color: color,
        parentId: parentId,
      );
      return const Success(null);
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }

  @override
  ResultVoid updateCategory({
    required int id,
    required String title,
    required String icon,
    required int color,
    int? parentId,
  }) async {
    try {
      await _localDataSource.updateCategory(
        id: id,
        title: title,
        icon: icon,
        color: color,
        parentId: parentId,
      );
      return const Success(null);
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }

  @override
  ResultVoid deleteCategory(int id) async {
    try {
      await _localDataSource.deleteCategory(id);
      return const Success(null);
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }
}
