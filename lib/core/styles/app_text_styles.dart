import 'package:flutter/material.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';

/// Semantic text styles aligned with Material 3 roles + editorial scale.
/// Always resolve from [ThemeData] so Manrope + colors stay consistent.
abstract final class AppTextStyles {
  AppTextStyles._();

  static TextTheme _tt(BuildContext context) => context.theme.textTheme;

  static TextStyle displayLg(BuildContext context) => _tt(context).displayLarge!;

  static TextStyle displayMd(BuildContext context) => _tt(context).displayMedium!;

  static TextStyle displaySm(BuildContext context) => _tt(context).displaySmall!;

  static TextStyle headlineLg(BuildContext context) =>
      _tt(context).headlineLarge!;

  static TextStyle headlineSm(BuildContext context) =>
      _tt(context).headlineSmall!;

  static TextStyle titleMd(BuildContext context) => _tt(context).titleMedium!;

  static TextStyle labelMd(BuildContext context) => _tt(context).labelMedium!;

  static TextStyle labelSm(BuildContext context) => _tt(context).labelSmall!;

  static TextStyle bodyMd(BuildContext context) => _tt(context).bodyMedium!;

  static TextStyle bodyLg(BuildContext context) => _tt(context).bodyLarge!;

  /// Interactive labels — prefer semibold from the theme.
  static TextStyle interactiveLabel(BuildContext context) =>
      labelMd(context).copyWith(fontWeight: FontWeight.w600);
}
