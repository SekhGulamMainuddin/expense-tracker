import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Editorial scale — sizes use [ScreenUtil]; body text stays ≥14px (`bodyMd`).
final class AppFontSize {
  AppFontSize._();

  /// Display Large — financial headlines (≈ 3.5rem @ 16px root).
  static double get displayLg => 56.sp;

  /// Display Medium — secondary totals.
  static double get displayMd => 40.sp;

  /// Display Small — numpad numerals.
  static double get displaySm => 28.sp;

  /// Headline Large — emphasized numeric entry (amount fields).
  static double get headlineLg => 28.sp;

  /// Headline Small — section titles (≈ 1.5rem).
  static double get headlineSm => 24.sp;

  /// Title Medium — card titles (≈ 1.125rem).
  static double get titleMd => 18.sp;

  /// Label Medium — architectural small caps lane.
  static double get labelMd => 12.sp;

  /// Label Small — dense labels (still paired with semibold in theme).
  static double get labelSm => 11.sp;

  /// Body Medium — default reading size (≥14px).
  static double get bodyMd => 14.sp;

  /// Body Large — secondary emphasis body.
  static double get bodyLg => 16.sp;
}
