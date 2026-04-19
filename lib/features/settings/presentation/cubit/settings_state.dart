import 'package:flutter/material.dart';

sealed class SettingsState {}

final class SettingsInitial extends SettingsState {}

final class SettingsLoaded extends SettingsState {
  final List<String> expandedCategories;
  final double dailyLimit;
  final double weeklyLimit;
  final double monthlyLimit;
  final double safeHaven;
  final double mildCaution;
  final double dangerThreshold;
  final ThemeMode themeMode;

  SettingsLoaded({
    this.expandedCategories = const [],
    this.dailyLimit = 50.0,
    this.weeklyLimit = 350.0,
    this.monthlyLimit = 1500.0,
    this.safeHaven = 5.0,
    this.mildCaution = 5.0,
    this.dangerThreshold = 10.0,
    this.themeMode = ThemeMode.system,
  });

  SettingsLoaded copyWith({
    List<String>? expandedCategories,
    double? dailyLimit,
    double? weeklyLimit,
    double? monthlyLimit,
    double? safeHaven,
    double? mildCaution,
    double? dangerThreshold,
    ThemeMode? themeMode,
  }) {
    return SettingsLoaded(
      expandedCategories: expandedCategories ?? this.expandedCategories,
      dailyLimit: dailyLimit ?? this.dailyLimit,
      weeklyLimit: weeklyLimit ?? this.weeklyLimit,
      monthlyLimit: monthlyLimit ?? this.monthlyLimit,
      safeHaven: safeHaven ?? this.safeHaven,
      mildCaution: mildCaution ?? this.mildCaution,
      dangerThreshold: dangerThreshold ?? this.dangerThreshold,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

final class SettingsFailure extends SettingsState {
  final String errorMessage;

  SettingsFailure(this.errorMessage);
}
