import 'package:flutter/material.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';

/// Illuminated Ledger — chromatic tokens. Prefer [ColorScheme] via theme; these
/// back precise hex values and tonal constants (shadows, gradients, washes).
final class AppPalette {
  AppPalette._();

  // --- Anchors ---
  /// Guiding vivid blue (light-mode primary emphasis).
  static const vividBlue = Color(0xFF2B8CEE);

  // --- Dark mode (authoritative palette) ---
  static const darkBackground = Color(0xFF0C1324);
  static const darkPrimary = Color(0xFFA4C9FF);
  static const darkOnPrimary = Color(0xFF0C1324);
  static const darkPrimaryContainer = Color(0xFF284878);
  static const darkOnPrimaryContainer = Color(0xFFD8E8FF);

  static const darkSurfaceContainerLowest = Color(0xFF0E1527);
  static const darkSurfaceContainerLow = Color(0xFF171C2E);
  static const darkSurfaceContainer = Color(0xFF191F31);
  static const darkSurfaceContainerHigh = Color(0xFF23293C);
  static const darkSurfaceContainerHighest = Color(0xFF2C3348);

  static const darkOnSurface = Color(0xFFE8EDF7);
  static const darkOnSurfaceVariant = Color(0xFFB4BDCA);
  static const darkOutline = Color(0xFF4A5468);
  static const darkOutlineVariant = Color(0xFF404752);

  /// Safe band · calm (secondary lane).
  static const darkSecondary = Color(0xFF6EE7C5);
  static const darkSecondaryContainer = Color(0xFF143D33);
  static const darkOnSecondaryContainer = Color(0xFFB8F5E4);

  /// Safe band · caution (tertiary lane).
  static const darkTertiary = Color(0xFFFDE68A);
  static const darkTertiaryContainer = Color(0xFF4A3F18);
  static const darkOnTertiaryContainer = Color(0xFFFFF3C8);

  static const darkError = Color(0xFFFDA4AF);
  static const darkErrorContainer = Color(0xFF5C232D);
  static const darkOnErrorContainer = Color(0xFFFFDADE);

  // --- Light mode ---
  static const lightBackground = Color(0xFFF4F8FD);
  static const lightPrimary = vividBlue;
  static const lightOnPrimary = Color(0xFFFFFFFF);
  static const lightPrimaryContainer = Color(0xFFD8EBFF);
  static const lightOnPrimaryContainer = Color(0xFF06254A);

  static const lightSurfaceContainerLowest = Color(0xFFF0F4FB);
  static const lightSurfaceContainerLow = Color(0xFFE8EFF9);
  static const lightSurfaceContainer = Color(0xFFE2EBF7);
  static const lightSurfaceContainerHigh = Color(0xFFD9E5F5);
  static const lightSurfaceContainerHighest = Color(0xFFD0DFF3);

  static const lightOnSurface = Color(0xFF163659);
  static const lightOnSurfaceVariant = Color(0xFF475569);
  static const lightOutline = Color(0xFFB8CEEB);
  static const lightOutlineVariant = Color(0xFFCBD9EE);

  static const lightSecondary = Color(0xFF059669);
  static const lightSecondaryContainer = Color(0xFFD1FAE5);
  static const lightOnSecondaryContainer = Color(0xFF064E3B);

  static const lightTertiary = Color(0xFFD97706);
  static const lightTertiaryContainer = Color(0xFFFEF3C7);
  static const lightOnTertiaryContainer = Color(0xFF78350F);

  static const lightError = Color(0xFFDC2626);
  static const lightErrorContainer = Color(0xFFFEE2E2);
  static const lightOnErrorContainer = Color(0xFF7F1D1D);

  // --- Ambient shadow (tinted, not pure black) ---
  static const ambientShadow = Color(0x66020617); // #020617 @ ~40%

  // --- Translucent overlays ---
  static const overlayScrim = Color(0x990C1324);

  // --- Ghost border ---
  static double ghostBorderOpacity(BuildContext context) =>
      context.theme.brightness == Brightness.dark ? 0.10 : 0.12;

  // --- Safe band washes (opacity per design doc) ---
  static Color safeBandWashGreen(ColorScheme cs) =>
      cs.secondaryContainer.withOpacity(0.10);

  static Color safeBandWashYellow(ColorScheme cs) =>
      cs.tertiaryContainer.withOpacity(0.15);

  static Color safeBandWashRed(ColorScheme cs) =>
      cs.errorContainer.withOpacity(0.20);

  /// Back-compat names used by legacy widgets (map to themed text colors).
  static Color textPrimary(BuildContext context) =>
      context.theme.colorScheme.onSurface;

  static Color textSecondary(BuildContext context) =>
      context.theme.colorScheme.onSurfaceVariant;

  static Color textInverse(BuildContext context) =>
      context.theme.colorScheme.onPrimary;
}
