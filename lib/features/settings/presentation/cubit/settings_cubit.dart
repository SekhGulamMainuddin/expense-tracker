import 'dart:async';

import 'package:expense_tracker/core/error/result.dart';
import 'package:expense_tracker/features/settings/domain/entities/settings_snapshot.dart';
import 'package:expense_tracker/features/settings/domain/repositories/settings_repository.dart';
import 'package:expense_tracker/core/domain/entities/app_theme.dart';
import 'package:expense_tracker/core/domain/entities/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._repository) : super(SettingsInitial()) {
    unawaited(loadSettings());
  }

  final SettingsRepository _repository;
  SettingsSnapshot? _snapshot;

  Future<bool> loadSettings() async {
    emit(SettingsLoading());
    final result = await _repository.loadSettings();
    return _applyLoadResult(result, emitFailureState: true);
  }

  Future<bool> updateThemeMode(ThemeMode mode) async {
    final appTheme = switch (mode) {
      ThemeMode.light => AppTheme.light,
      ThemeMode.dark => AppTheme.dark,
      ThemeMode.system => AppTheme.system,
    };
    final result = await _repository.updateThemeMode(appTheme);
    return _applyMutationResult(
      result,
      onSuccess: () async {
        _emitSnapshot(_requireSnapshot().copyWith(themeMode: mode));
        return true;
      },
    );
  }

  Future<bool> updateBaseCurrency(String currencyCode) async {
    final currency = Currency.fromCode(currencyCode);
    final result = await _repository.updateBaseCurrency(currency);
    return _applyMutationResult(
      result,
      onSuccess: () async {
        _emitSnapshot(_requireSnapshot().copyWith(baseCurrencyCode: currencyCode));
        return true;
      },
    );
  }

  Future<bool> updateDailyLimit(double value) => _updateBudgetLimit(
        storageKey: 'dailyLimit',
        value: value,
        updateSnapshot: (snapshot) => snapshot.copyWith(dailyLimit: value),
      );

  Future<bool> updateWeeklyLimit(double value) => _updateBudgetLimit(
        storageKey: 'weeklyLimit',
        value: value,
        updateSnapshot: (snapshot) => snapshot.copyWith(weeklyLimit: value),
      );

  Future<bool> updateMonthlyLimit(double value) => _updateBudgetLimit(
        storageKey: 'monthlyLimit',
        value: value,
        updateSnapshot: (snapshot) => snapshot.copyWith(monthlyLimit: value),
      );

  Future<bool> updateSafeThreshold(double value) => _updateThreshold(
        storageKey: 'safeThreshold',
        value: value,
        updateSnapshot: (snapshot) => snapshot.copyWith(safeThreshold: value),
      );

  Future<bool> updateCautionThreshold(double value) => _updateThreshold(
        storageKey: 'cautionThreshold',
        value: value,
        updateSnapshot: (snapshot) => snapshot.copyWith(cautionThreshold: value),
      );

  Future<bool> updateDangerThreshold(double value) => _updateThreshold(
        storageKey: 'dangerThreshold',
        value: value,
        updateSnapshot: (snapshot) => snapshot.copyWith(dangerThreshold: value),
      );

  Future<bool> addCategory({
    required String title,
    required String icon,
    required int color,
    int? parentId,
  }) async {
    final result = await _repository.addCategory(
      title: title,
      icon: icon,
      color: color,
      parentId: parentId,
    );
    return _applyMutationResult(
      result,
      onSuccess: () async => _refreshSnapshot(),
    );
  }

  Future<bool> updateCategory({
    required int id,
    required String title,
    required String icon,
    required int color,
    int? parentId,
  }) async {
    final result = await _repository.updateCategory(
      id: id,
      title: title,
      icon: icon,
      color: color,
      parentId: parentId,
    );
    return _applyMutationResult(
      result,
      onSuccess: () async => _refreshSnapshot(),
    );
  }

  Future<bool> deleteCategory(int id) async {
    final result = await _repository.deleteCategory(id);
    return _applyMutationResult(
      result,
      onSuccess: () async => _refreshSnapshot(),
    );
  }

  Future<bool> addCustomIcon({
    required String name,
    required String iconUrl,
  }) async {
    final result = await _repository.addCustomIcon(
      name: name,
      iconUrl: iconUrl,
    );
    return _applyMutationResult(
      result,
      onSuccess: () async => _refreshSnapshot(),
    );
  }

  Future<bool> _updateBudgetLimit({
    required String storageKey,
    required double value,
    required SettingsSnapshot Function(SettingsSnapshot snapshot) updateSnapshot,
  }) async {
    final result = await _repository.updateBudgetLimit(storageKey, value);
    return _applyMutationResult(
      result,
      onSuccess: () async {
        _emitSnapshot(updateSnapshot(_requireSnapshot()));
        return true;
      },
    );
  }

  Future<bool> _updateThreshold({
    required String storageKey,
    required double value,
    required SettingsSnapshot Function(SettingsSnapshot snapshot) updateSnapshot,
  }) async {
    final result = await _repository.updateThreshold(storageKey, value);
    return _applyMutationResult(
      result,
      onSuccess: () async {
        _emitSnapshot(updateSnapshot(_requireSnapshot()));
        return true;
      },
    );
  }

  Future<bool> _refreshSnapshot() async {
    final result = await _repository.loadSettings();
    return _applyLoadResult(result, emitFailureState: false);
  }

  bool _applyLoadResult(
    Result<SettingsSnapshot, Failure> result, {
    required bool emitFailureState,
  }) {
    return result.fold(
      (snapshot) {
        _emitSnapshot(snapshot);
        return true;
      },
      (failure) {
        if (emitFailureState) {
          _emitFailure(failure.message);
        } else {
          emit(SettingsFailure(failure.message));
          final snapshot = _snapshot;
          if (snapshot != null) {
            emit(SettingsLoaded(snapshot));
          }
        }
        return false;
      },
    );
  }

  Future<bool> _applyMutationResult(
    Result<void, Failure> result, {
    required Future<bool> Function() onSuccess,
  }) async {
    if (result.isFailure) {
      _emitFailure(result.failureOrNull!.message);
      return false;
    }

    return onSuccess();
  }

  void _emitSnapshot(SettingsSnapshot snapshot) {
    _snapshot = snapshot;
    emit(SettingsLoaded(snapshot));
  }

  void _emitFailure(String message) {
    emit(SettingsFailure(message));
    final snapshot = _snapshot;
    if (snapshot != null) {
      emit(SettingsLoaded(snapshot));
    }
  }

  SettingsSnapshot _requireSnapshot() {
    final snapshot = _snapshot;
    if (snapshot != null) {
      return snapshot;
    }
    throw StateError('Settings must be loaded before updating values.');
  }

}
