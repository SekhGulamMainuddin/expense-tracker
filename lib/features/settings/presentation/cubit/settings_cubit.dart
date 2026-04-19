import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:expense_tracker/features/settings/presentation/cubit/settings_state.dart';
import 'package:expense_tracker/core/database/app_database.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._db) : super(SettingsInitial()) {
    _loadSettings();
  }

  final AppDatabase _db;

  Future<void> _loadSettings() async {
    final themeQuery = await (_db.select(_db.keyValueStore)
      ..where((tbl) => tbl.key.equals('themeMode')))
        .getSingleOrNull();

    ThemeMode mode = ThemeMode.system;
    if (themeQuery != null) {
      if (themeQuery.value == 'light') mode = ThemeMode.light;
      if (themeQuery.value == 'dark') mode = ThemeMode.dark;
    }
    emit(SettingsLoaded(themeMode: mode));
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    if (state is! SettingsLoaded) return;
    final loadedState = state as SettingsLoaded;

    String value = 'system';
    if (mode == ThemeMode.light) value = 'light';
    if (mode == ThemeMode.dark) value = 'dark';

    await _db.into(_db.keyValueStore).insertOnConflictUpdate(
      KeyValueStoreData(key: 'themeMode', value: value),
    );

    emit(loadedState.copyWith(themeMode: mode));
  }

  void toggleCategory(String category) {
    if (state is! SettingsLoaded) return;
    final loadedState = state as SettingsLoaded;

    final current = List<String>.from(loadedState.expandedCategories);
    if (current.contains(category)) {
      current.remove(category);
    } else {
      current.add(category);
    }
    emit(loadedState.copyWith(expandedCategories: current));
  }

  void updateLimit(String type, double value) {
    if (state is! SettingsLoaded) return;
    final loadedState = state as SettingsLoaded;

    if (type == 'daily') emit(loadedState.copyWith(dailyLimit: value));
    if (type == 'weekly') emit(loadedState.copyWith(weeklyLimit: value));
    if (type == 'monthly') emit(loadedState.copyWith(monthlyLimit: value));
  }

  void updateThreshold(String type, double value) {
    if (state is! SettingsLoaded) return;
    final loadedState = state as SettingsLoaded;

    if (type == 'safe') emit(loadedState.copyWith(safeHaven: value));
    if (type == 'caution') emit(loadedState.copyWith(mildCaution: value));
    if (type == 'danger') emit(loadedState.copyWith(dangerThreshold: value));
  }
}
