import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:expense_tracker/core/styles/app_palette.dart';

final class AppTheme {
  AppTheme._();

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppPalette.background,
      colorScheme: const ColorScheme.light(
        primary: AppPalette.primary,
        onPrimary: AppPalette.textInverse,
        secondary: AppPalette.secondary,
        onSecondary: AppPalette.textPrimary,
        surface: AppPalette.surface,
        onSurface: AppPalette.textPrimary,
        outline: AppPalette.outline,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: AppPalette.background,
        foregroundColor: AppPalette.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppPalette.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
          side: const BorderSide(color: AppPalette.outline),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppPalette.primary,
          foregroundColor: AppPalette.textInverse,
          minimumSize: Size(double.infinity, 56.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppPalette.textPrimary,
          side: const BorderSide(color: AppPalette.outline),
          minimumSize: Size(double.infinity, 56.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppPalette.surface,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppPalette.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppPalette.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppPalette.primary, width: 2.w),
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(color: AppPalette.textPrimary, fontWeight: FontWeight.w800, fontSize: 32.sp),
        headlineMedium: TextStyle(color: AppPalette.textPrimary, fontWeight: FontWeight.bold, fontSize: 28.sp),
        titleLarge: TextStyle(color: AppPalette.textPrimary, fontWeight: FontWeight.bold, fontSize: 22.sp),
        bodyLarge: TextStyle(color: AppPalette.textPrimary, fontSize: 16.sp),
        bodyMedium: TextStyle(color: AppPalette.textSecondary, fontSize: 14.sp),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppPalette.backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: AppPalette.primaryDark,
        onPrimary: AppPalette.textInverse,
        secondary: AppPalette.secondaryDark,
        onSecondary: AppPalette.textPrimaryDark,
        surface: AppPalette.surfaceDark,
        onSurface: AppPalette.textPrimaryDark,
        outline: AppPalette.outlineDark,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: AppPalette.backgroundDark,
        foregroundColor: AppPalette.textPrimaryDark,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppPalette.surfaceDark,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
          side: const BorderSide(color: AppPalette.outlineDark),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppPalette.primaryDark,
          foregroundColor: AppPalette.textInverse,
          minimumSize: Size(double.infinity, 56.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppPalette.textPrimaryDark,
          side: const BorderSide(color: AppPalette.outlineDark),
          minimumSize: Size(double.infinity, 56.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppPalette.surfaceDark,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppPalette.outlineDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppPalette.outlineDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppPalette.primaryDark, width: 2.w),
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(color: AppPalette.textPrimaryDark, fontWeight: FontWeight.w800, fontSize: 32.sp),
        headlineMedium: TextStyle(color: AppPalette.textPrimaryDark, fontWeight: FontWeight.bold, fontSize: 28.sp),
        titleLarge: TextStyle(color: AppPalette.textPrimaryDark, fontWeight: FontWeight.bold, fontSize: 22.sp),
        bodyLarge: TextStyle(color: AppPalette.textPrimaryDark, fontSize: 16.sp),
        bodyMedium: TextStyle(color: AppPalette.textSecondaryDark, fontSize: 14.sp),
      ),
    );
  }
}
