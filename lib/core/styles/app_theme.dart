import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expense_tracker/core/styles/app_dimensions.dart';
import 'package:expense_tracker/core/styles/app_font_size.dart';
import 'package:expense_tracker/core/styles/app_palette.dart';

final class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final scheme = _lightScheme();
    return _buildTheme(scheme);
  }

  static ThemeData dark() {
    final scheme = _darkScheme();
    return _buildTheme(scheme);
  }

  static ColorScheme _lightScheme() {
    return ColorScheme(
      brightness: Brightness.light,
      primary: AppPalette.lightPrimary,
      onPrimary: AppPalette.lightOnPrimary,
      primaryContainer: AppPalette.lightPrimaryContainer,
      onPrimaryContainer: AppPalette.lightOnPrimaryContainer,
      secondary: AppPalette.lightSecondary,
      onSecondary: Colors.white,
      secondaryContainer: AppPalette.lightSecondaryContainer,
      onSecondaryContainer: AppPalette.lightOnSecondaryContainer,
      tertiary: AppPalette.lightTertiary,
      onTertiary: const Color(0xFF78350F),
      tertiaryContainer: AppPalette.lightTertiaryContainer,
      onTertiaryContainer: AppPalette.lightOnTertiaryContainer,
      error: AppPalette.lightError,
      onError: Colors.white,
      errorContainer: AppPalette.lightErrorContainer,
      onErrorContainer: AppPalette.lightOnErrorContainer,
      surface: AppPalette.lightBackground,
      onSurface: AppPalette.lightOnSurface,
      onSurfaceVariant: AppPalette.lightOnSurfaceVariant,
      outline: AppPalette.lightOutline,
      outlineVariant: AppPalette.lightOutlineVariant,
      shadow: AppPalette.ambientShadow,
      scrim: AppPalette.overlayScrim,
      inverseSurface: AppPalette.darkSurfaceContainerHigh,
      onInverseSurface: AppPalette.darkOnSurface,
      inversePrimary: AppPalette.darkPrimary,
      surfaceTint: AppPalette.vividBlue,
      surfaceContainerLowest: AppPalette.lightSurfaceContainerLowest,
      surfaceContainerLow: AppPalette.lightSurfaceContainerLow,
      surfaceContainer: AppPalette.lightSurfaceContainer,
      surfaceContainerHigh: AppPalette.lightSurfaceContainerHigh,
      surfaceContainerHighest: AppPalette.lightSurfaceContainerHighest,
    );
  }

  static ColorScheme _darkScheme() {
    return ColorScheme(
      brightness: Brightness.dark,
      primary: AppPalette.darkPrimary,
      onPrimary: AppPalette.darkOnPrimary,
      primaryContainer: AppPalette.darkPrimaryContainer,
      onPrimaryContainer: AppPalette.darkOnPrimaryContainer,
      secondary: AppPalette.darkSecondary,
      onSecondary: AppPalette.darkBackground,
      secondaryContainer: AppPalette.darkSecondaryContainer,
      onSecondaryContainer: AppPalette.darkOnSecondaryContainer,
      tertiary: AppPalette.darkTertiary,
      onTertiary: const Color(0xFF422006),
      tertiaryContainer: AppPalette.darkTertiaryContainer,
      onTertiaryContainer: AppPalette.darkOnTertiaryContainer,
      error: AppPalette.darkError,
      onError: AppPalette.darkBackground,
      errorContainer: AppPalette.darkErrorContainer,
      onErrorContainer: AppPalette.darkOnErrorContainer,
      surface: AppPalette.darkBackground,
      onSurface: AppPalette.darkOnSurface,
      onSurfaceVariant: AppPalette.darkOnSurfaceVariant,
      outline: AppPalette.darkOutline,
      outlineVariant: AppPalette.darkOutlineVariant,
      shadow: AppPalette.ambientShadow,
      scrim: AppPalette.overlayScrim,
      inverseSurface: AppPalette.lightSurfaceContainerHigh,
      onInverseSurface: AppPalette.lightOnSurface,
      inversePrimary: AppPalette.lightPrimary,
      surfaceTint: AppPalette.darkPrimary,
      surfaceContainerLowest: AppPalette.darkSurfaceContainerLowest,
      surfaceContainerLow: AppPalette.darkSurfaceContainerLow,
      surfaceContainer: AppPalette.darkSurfaceContainer,
      surfaceContainerHigh: AppPalette.darkSurfaceContainerHigh,
      surfaceContainerHighest: AppPalette.darkSurfaceContainerHighest,
    );
  }

  static ThemeData _buildTheme(ColorScheme scheme) {
    final textTheme = _manropeTextTheme(scheme);

    final ghostSide = BorderSide(
      color: scheme.outlineVariant.withValues(alpha: 0.10),
      width: 2.w,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      brightness: scheme.brightness,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      splashFactory: InkRipple.splashFactory,
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant.withValues(alpha: 0.08),
        thickness: 1,
        space: 16.h,
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainer,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.xl),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerHigh.withValues(alpha: 0.94),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.xl),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        titleTextStyle: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: AppPalette.ambientShadow,
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          minimumSize: Size(double.infinity, 56.h),
          shape: RoundedRectangleBorder(borderRadius: AppRadii.full),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.02,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.onSurface,
          side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.20)),
          minimumSize: Size(double.infinity, 56.h),
          shape: RoundedRectangleBorder(borderRadius: AppRadii.full),
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLow,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        border: OutlineInputBorder(
          borderRadius: AppRadii.xl,
          borderSide: ghostSide,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadii.xl,
          borderSide: ghostSide,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadii.xl,
          borderSide: BorderSide(color: scheme.primary, width: 2.w),
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainer,
        deleteIconColor: scheme.onSurfaceVariant,
        disabledColor: scheme.surfaceContainerLow,
        selectedColor: scheme.primaryContainer,
        secondarySelectedColor: scheme.secondaryContainer,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        shape: RoundedRectangleBorder(borderRadius: AppRadii.md),
        side: BorderSide.none,
        labelStyle: textTheme.labelMedium!,
        brightness: scheme.brightness,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primaryContainer,
        foregroundColor: scheme.onPrimaryContainer,
        elevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.full),
      ),
    );
  }

  static TextTheme _manropeTextTheme(ColorScheme cs) {
    final letterLabelMd = AppFontSize.labelMd * 0.05;
    final letterLabelSm = AppFontSize.labelSm * 0.05;

    final base = TextTheme(
      displayLarge: TextStyle(
        fontSize: AppFontSize.displayLg,
        fontWeight: FontWeight.w700,
        height: 1.08,
      ),
      displayMedium: TextStyle(
        fontSize: AppFontSize.displayMd,
        fontWeight: FontWeight.w700,
        height: 1.1,
      ),
      displaySmall: TextStyle(
        fontSize: AppFontSize.displaySm,
        fontWeight: FontWeight.w700,
        height: 1.12,
      ),
      headlineLarge: TextStyle(
        fontSize: AppFontSize.headlineLg,
        fontWeight: FontWeight.w700,
        height: 1.15,
      ),
      headlineMedium: TextStyle(
        fontSize: AppFontSize.titleMd + 2.sp,
        fontWeight: FontWeight.w600,
        height: 1.22,
      ),
      headlineSmall: TextStyle(
        fontSize: AppFontSize.headlineSm,
        fontWeight: FontWeight.w600,
        height: 1.25,
      ),
      titleLarge: TextStyle(
        fontSize: AppFontSize.headlineSm,
        fontWeight: FontWeight.w600,
        height: 1.25,
      ),
      titleMedium: TextStyle(
        fontSize: AppFontSize.titleMd,
        fontWeight: FontWeight.w500,
        height: 1.3,
      ),
      titleSmall: TextStyle(
        fontSize: AppFontSize.bodyLg,
        fontWeight: FontWeight.w600,
        height: 1.35,
      ),
      labelLarge: TextStyle(
        fontSize: AppFontSize.bodyMd,
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
      labelMedium: TextStyle(
        fontSize: AppFontSize.labelMd,
        fontWeight: FontWeight.w600,
        letterSpacing: letterLabelMd,
        height: 1.2,
      ),
      labelSmall: TextStyle(
        fontSize: AppFontSize.labelSm,
        fontWeight: FontWeight.w600,
        letterSpacing: letterLabelSm,
        height: 1.2,
      ),
      bodyLarge: TextStyle(
        fontSize: AppFontSize.bodyLg,
        fontWeight: FontWeight.w400,
        height: 1.45,
      ),
      bodyMedium: TextStyle(
        fontSize: AppFontSize.bodyMd,
        fontWeight: FontWeight.w400,
        height: 1.45,
      ),
      bodySmall: TextStyle(
        fontSize: AppFontSize.labelMd,
        fontWeight: FontWeight.w400,
        height: 1.35,
      ),
    );

    return GoogleFonts.manropeTextTheme(base).apply(
      bodyColor: cs.onSurface,
      displayColor: cs.onSurface,
    );
  }
}
