import 'package:expense_tracker/core/database/dao/expense_dao.dart';
import 'package:expense_tracker/core/database/dao/key_value_store_dao.dart';
import 'package:expense_tracker/core/database/dao/custom_icon_dao.dart';
import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/features/settings/domain/entities/settings_category.dart';
import 'package:expense_tracker/features/settings/domain/entities/settings_snapshot.dart';
import 'package:expense_tracker/features/settings/domain/entities/custom_icon_entity.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import 'package:rxdart/rxdart.dart';

class SettingsLocalDataSource {
  SettingsLocalDataSource(
    this._expenseDao,
    this._keyValueStoreDao,
    this._customIconDao,
  );

  final ExpenseDao _expenseDao;
  final KeyValueStoreDao _keyValueStoreDao;
  final CustomIconDao _customIconDao;

  /// Watches for any changes in settings.
  Stream<void> watchSettings() => Rx.merge([
        _keyValueStoreDao.watchAllEntries(),
        _customIconDao.watchAllCustomIcons(),
      ]);

  static const _themeKey = 'themeMode';
  static const _currencyKey = 'baseCurrency';
  static const _dailyLimitKey = 'dailyLimit';
  static const _weeklyLimitKey = 'weeklyLimit';
  static const _monthlyLimitKey = 'monthlyLimit';
  static const _safeThresholdKey = 'safeThreshold';
  static const _cautionThresholdKey = 'cautionThreshold';
  static const _dangerThresholdKey = 'dangerThreshold';

  Future<SettingsSnapshot> loadSettings() async {
    await _ensureSeedData();

    final rawCategories = await _expenseDao.getAllCategories();
    final categories = _buildCategoryTree(rawCategories);

    final rawCustomIcons = await _customIconDao.getAllCustomIcons();
    final customIcons = rawCustomIcons
        .map((e) => CustomIconEntity(
              id: e.id,
              name: e.name,
              iconUrl: e.iconUrl,
            ))
        .toList();

    return SettingsSnapshot(
      themeMode: await _readThemeMode(),
      baseCurrencyCode: await _keyValueStoreDao.getValue<String>(
            _currencyKey,
            defaultValue: 'inr',
          ) ??
          'inr',
      dailyLimit: await _readDouble(_dailyLimitKey, 50),
      weeklyLimit: await _readDouble(_weeklyLimitKey, 350),
      monthlyLimit: await _readDouble(_monthlyLimitKey, 1500),
      safeThreshold: await _readDouble(_safeThresholdKey, 5),
      cautionThreshold: await _readDouble(_cautionThresholdKey, 5),
      dangerThreshold: await _readDouble(_dangerThresholdKey, 10),
      categories: categories,
      customIcons: customIcons,
    );
  }

  Future<void> addCustomIcon({
    required String name,
    required String iconUrl,
  }) {
    return _customIconDao.addCustomIcon(
      CustomIconsCompanion(
        name: Value(name),
        iconUrl: Value(iconUrl),
      ),
    );
  }

  Stream<List<CustomIconEntity>> watchCustomIcons() {
    return _customIconDao.watchAllCustomIcons().map(
          (list) => list
              .map((e) => CustomIconEntity(
                    id: e.id,
                    name: e.name,
                    iconUrl: e.iconUrl,
                  ))
              .toList(),
        );
  }

  Future<void> updateThemeMode(String mode) {
    return _keyValueStoreDao.setValue<String>(_themeKey, mode);
  }

  Future<void> updateBaseCurrency(String currencyCode) {
    return _keyValueStoreDao.setValue<String>(_currencyKey, currencyCode);
  }

  Future<void> updateBudgetLimit(String key, double value) {
    return _keyValueStoreDao.setValue<double>(key, value);
  }

  Future<void> updateThreshold(String key, double value) {
    return _keyValueStoreDao.setValue<double>(key, value);
  }

  Future<void> addCategory({
    required String title,
    required String icon,
    required int color,
    int? parentId,
  }) {
    return _expenseDao
        .createCategory(
          title: title,
          icon: icon,
          color: color,
          parentId: parentId,
        )
        .then((_) {});
  }

  Future<void> updateCategory({
    required int id,
    required String title,
    required String icon,
    required int color,
    int? parentId,
  }) {
    return _expenseDao
        .updateCategoryValues(
          id: id,
          title: title,
          icon: icon,
          color: color,
          parentId: parentId,
        )
        .then((_) {});
  }

  Future<void> deleteCategory(int id) async {
    await _deleteCategoryTree(id);
  }

  Future<void> _ensureSeedData() async {
    final categories = await _expenseDao.getAllCategories();
    if (categories.isNotEmpty) {
      return;
    }

    await _expenseDao.createCategory(
      title: 'Food & Drinks',
      icon: 'restaurant',
      color: 0xFF2B8CEE,
    );
    await _expenseDao.createCategory(
      title: 'Travel',
      icon: 'directions_car',
      color: 0xFF10B981,
    );
    await _expenseDao.createCategory(
      title: 'Shopping',
      icon: 'shopping_bag',
      color: 0xFFF59E0B,
    );
    await _expenseDao.createCategory(
      title: 'Bills',
      icon: 'receipt_long',
      color: 0xFFF43F5E,
    );

    final seeded = await _expenseDao.getAllCategories();
    final lookup = {
      for (final category in seeded) category.title: category.id,
    };

    Future<void> seedChild({
      required String title,
      required String icon,
      required int color,
      required String parentTitle,
    }) async {
      final parentId = lookup[parentTitle];
      if (parentId == null) return;
      await _expenseDao.createCategory(
        title: title,
        icon: icon,
        color: color,
        parentId: parentId,
      );
    }

    await seedChild(
      title: 'Groceries',
      icon: 'shopping_cart',
      color: 0xFF2B8CEE,
      parentTitle: 'Food & Drinks',
    );
    await seedChild(
      title: 'Restaurants',
      icon: 'restaurant_menu',
      color: 0xFF10B981,
      parentTitle: 'Food & Drinks',
    );
    await seedChild(
      title: 'Coffee',
      icon: 'coffee',
      color: 0xFFF59E0B,
      parentTitle: 'Food & Drinks',
    );
    await seedChild(
      title: 'Flights',
      icon: 'flight',
      color: 0xFF6366F1,
      parentTitle: 'Travel',
    );
    await seedChild(
      title: 'Cab',
      icon: 'local_taxi',
      color: 0xFF10B981,
      parentTitle: 'Travel',
    );
    await seedChild(
      title: 'Fashion',
      icon: 'checkroom',
      color: 0xFFA855F7,
      parentTitle: 'Shopping',
    );
    await seedChild(
      title: 'Electronics',
      icon: 'devices',
      color: 0xFFF97316,
      parentTitle: 'Shopping',
    );
    await seedChild(
      title: 'Electricity',
      icon: 'bolt',
      color: 0xFFF43F5E,
      parentTitle: 'Bills',
    );
    await seedChild(
      title: 'Internet',
      icon: 'wifi',
      color: 0xFF2B8CEE,
      parentTitle: 'Bills',
    );
  }

  Future<ThemeMode> _readThemeMode() async {
    final themeMode = await _keyValueStoreDao.getValue<String>(
      _themeKey,
      defaultValue: 'system',
    );
    return switch (themeMode) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<double> _readDouble(String key, double defaultValue) async {
    final value = await _keyValueStoreDao.getValue<num>(key);
    return value?.toDouble() ?? defaultValue;
  }

  Future<void> _deleteCategoryTree(int categoryId) async {
    final categories = await _expenseDao.getAllCategories();
    final byId = {for (final category in categories) category.id: category};

    final idsToDelete = _collectDescendants(byId, categoryId);
    if (idsToDelete.isEmpty) {
      return;
    }

    var fallbackCategoryId = _resolveFallbackCategoryId(byId, idsToDelete, categoryId);
    fallbackCategoryId ??= await _expenseDao.createCategory(
      title: 'Uncategorized',
      icon: 'more_horiz',
      color: 0xFF64748B,
    );

    await _expenseDao.reassignExpensesToCategory(idsToDelete, fallbackCategoryId);

    final idsByDepth = idsToDelete
        .map((id) => MapEntry(id, _categoryDepth(byId, id)))
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    for (final entry in idsByDepth) {
      await _expenseDao.deleteCategory(entry.key);
    }
  }

  List<int> _collectDescendants(Map<int, dynamic> byId, int categoryId) {
    if (!byId.containsKey(categoryId)) {
      return [];
    }

    final result = <int>[];
    void visit(int id) {
      result.add(id);
      for (final entry in byId.entries) {
        if (entry.value.parentId == id) {
          visit(entry.key);
        }
      }
    }

    visit(categoryId);
    return result;
  }

  int? _resolveFallbackCategoryId(
    Map<int, dynamic> byId,
    List<int> idsToDelete,
    int deletedCategoryId,
  ) {
    final deletedCategory = byId[deletedCategoryId];
    final parentId = deletedCategory?.parentId;
    if (parentId != null && !idsToDelete.contains(parentId)) {
      return parentId;
    }

    for (final category in byId.values) {
      if (!idsToDelete.contains(category.id)) {
        return category.id;
      }
    }

    return null;
  }

  int _categoryDepth(Map<int, dynamic> byId, int categoryId) {
    var depth = 0;
    var current = byId[categoryId];
    while (current != null && current.parentId != null) {
      depth++;
      current = byId[current.parentId];
    }
    return depth;
  }

  List<SettingsCategory> _buildCategoryTree(List<dynamic> rawCategories) {
    final categories = rawCategories.cast<Category>();
    final all = categories.map((c) => SettingsCategory(
      id: c.id,
      title: c.title,
      icon: c.icon,
      color: c.color,
      parentId: c.parentId,
    )).toList();

    // Roots are categories with no parent or parentId of 0
    return all.where((c) => c.parentId == null || c.parentId == 0).map((root) {
      return root.copyWith(
        children: all.where((c) => c.parentId == root.id).toList()
          ..sort((a, b) => a.title.compareTo(b.title)),
      );
    }).toList()..sort((a, b) => a.title.compareTo(b.title));
  }
}
