import 'package:flutter/material.dart';
import 'package:expense_tracker/features/settings/domain/entities/settings_category.dart';
import 'package:expense_tracker/features/settings/domain/entities/custom_icon_entity.dart';

class SettingsSnapshot {
  const SettingsSnapshot({
    required this.themeMode,
    required this.baseCurrencyCode,
    required this.dailyLimit,
    required this.weeklyLimit,
    required this.monthlyLimit,
    required this.safeThreshold,
    required this.cautionThreshold,
    required this.dangerThreshold,
    required this.categories,
    required this.customIcons,
  });

  final ThemeMode themeMode;
  final String baseCurrencyCode;
  final double dailyLimit;
  final double weeklyLimit;
  final double monthlyLimit;
  final double safeThreshold;
  final double cautionThreshold;
  final double dangerThreshold;
  final List<SettingsCategory> categories;
  final List<CustomIconEntity> customIcons;

  SettingsSnapshot copyWith({
    ThemeMode? themeMode,
    String? baseCurrencyCode,
    double? dailyLimit,
    double? weeklyLimit,
    double? monthlyLimit,
    double? safeThreshold,
    double? cautionThreshold,
    double? dangerThreshold,
    List<SettingsCategory>? categories,
    List<CustomIconEntity>? customIcons,
  }) {
    return SettingsSnapshot(
      themeMode: themeMode ?? this.themeMode,
      baseCurrencyCode: baseCurrencyCode ?? this.baseCurrencyCode,
      dailyLimit: dailyLimit ?? this.dailyLimit,
      weeklyLimit: weeklyLimit ?? this.weeklyLimit,
      monthlyLimit: monthlyLimit ?? this.monthlyLimit,
      safeThreshold: safeThreshold ?? this.safeThreshold,
      cautionThreshold: cautionThreshold ?? this.cautionThreshold,
      dangerThreshold: dangerThreshold ?? this.dangerThreshold,
      categories: categories ?? this.categories,
      customIcons: customIcons ?? this.customIcons,
    );
  }
}
