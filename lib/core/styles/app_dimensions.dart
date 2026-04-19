import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Roundedness scale from the Illuminated Ledger system.
final class AppRadii {
  AppRadii._();

  /// `md` — chips, small controls (0.375rem).
  static BorderRadius md = BorderRadius.circular(6.r);

  /// `xl` — cards, numeric shells (0.75rem).
  static BorderRadius xl = BorderRadius.circular(12.r);

  /// Fully rounded — primary CTA, safe-band pills.
  static BorderRadius full = BorderRadius.circular(9999);

  static Radius fullRadius = const Radius.circular(9999);
}
