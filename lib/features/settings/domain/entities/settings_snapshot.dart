import 'package:flutter/material.dart';
import 'package:expense_tracker/features/settings/domain/entities/settings_category.dart';

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
    );
  }
}
