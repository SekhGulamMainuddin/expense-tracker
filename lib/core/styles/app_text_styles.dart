import 'package:flutter/material.dart';
import 'package:expense_tracker/core/styles/app_font_size.dart';
import 'package:expense_tracker/core/styles/app_palette.dart';

final class AppTextStyles {
  AppTextStyles._();

  static final h1 = TextStyle(
    fontSize: AppFontSize.size36,
    fontWeight: FontWeight.w700,
    color: AppPalette.textPrimary,
  );

  static final h2 = TextStyle(
    fontSize: AppFontSize.size28,
    fontWeight: FontWeight.w700,
    color: AppPalette.textPrimary,
  );

  static final s1 = TextStyle(
    fontSize: AppFontSize.size20,
    fontWeight: FontWeight.w600,
    color: AppPalette.textPrimary,
  );

  static final b1 = TextStyle(
    fontSize: AppFontSize.size16,
    fontWeight: FontWeight.w500,
    color: AppPalette.textPrimary,
  );

  static final b2 = TextStyle(
    fontSize: AppFontSize.size14,
    fontWeight: FontWeight.w400,
    color: AppPalette.textPrimary,
  );
}
