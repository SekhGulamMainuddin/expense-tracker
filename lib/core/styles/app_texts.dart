import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/core/styles/app_text_styles.dart';

/// Prefer these widgets for UI copy so typography stays on-system.
/// Set [translate] false for dynamic / non-locale strings.

class AppTextDisplayLg extends StatelessWidget {
  const AppTextDisplayLg(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final TextStyle? style;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final base = AppTextStyles.displayLg(context);
    return Text(
      context.tr(text),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: base.merge(style).copyWith(color: color ?? base.color),
    );
  }
}

class AppTextDisplayMd extends StatelessWidget {
  const AppTextDisplayMd(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final TextStyle? style;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final base = AppTextStyles.displayMd(context);
    return Text(
      context.tr(text),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: base.merge(style).copyWith(color: color ?? base.color),
    );
  }
}

class AppTextDisplaySm extends StatelessWidget {
  const AppTextDisplaySm(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final TextStyle? style;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final base = AppTextStyles.displaySm(context);
    return Text(
      context.tr(text),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: base.merge(style).copyWith(color: color ?? base.color),
    );
  }
}

class AppTextHeadlineLg extends StatelessWidget {
  const AppTextHeadlineLg(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final TextStyle? style;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final base = AppTextStyles.headlineLg(context);
    return Text(
      context.tr(text),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: base.merge(style).copyWith(color: color ?? base.color),
    );
  }
}

class AppTextHeadlineSm extends StatelessWidget {
  const AppTextHeadlineSm(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final TextStyle? style;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final base = AppTextStyles.headlineSm(context);
    return Text(
      context.tr(text),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: base.merge(style).copyWith(color: color ?? base.color),
    );
  }
}

class AppTextTitleMd extends StatelessWidget {
  const AppTextTitleMd(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final TextStyle? style;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final base = AppTextStyles.titleMd(context);
    return Text(
      context.tr(text),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: base.merge(style).copyWith(color: color ?? base.color),
    );
  }
}

class AppTextLabelMd extends StatelessWidget {
  const AppTextLabelMd(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.letterSpacing = 0.05,
    this.uppercase = false,
  });

  final String text;
  final TextStyle? style;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double letterSpacing;
  final bool uppercase;

  @override
  Widget build(BuildContext context) {
    final raw = context.tr(text);
    final display = uppercase ? raw.toUpperCase() : raw;
    final base = AppTextStyles.labelMd(context);
    return Text(
      display,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: base.merge(style).copyWith(
            color: color ?? base.color,
            letterSpacing: letterSpacing,
          ),
    );
  }
}

class AppTextLabelSm extends StatelessWidget {
  const AppTextLabelSm(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.letterSpacing = 0.05,
    this.uppercase = false,
  });

  final String text;
  final TextStyle? style;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double letterSpacing;
  final bool uppercase;

  @override
  Widget build(BuildContext context) {
    final raw = context.tr(text);
    final display = uppercase ? raw.toUpperCase() : raw;
    final base = AppTextStyles.labelSm(context);
    return Text(
      display,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: base.merge(style).copyWith(
            color: color ?? base.color,
            letterSpacing: letterSpacing,
          ),
    );
  }
}

class AppTextBodyMd extends StatelessWidget {
  const AppTextBodyMd(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.height,
  });

  final String text;
  final TextStyle? style;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final base = AppTextStyles.bodyMd(context);
    return Text(
      context.tr(text),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: base.merge(style).copyWith(
            color: color ?? base.color,
            height: height,
          ),
    );
  }
}

class AppTextBodyLg extends StatelessWidget {
  const AppTextBodyLg(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.height,
  });

  final String text;
  final TextStyle? style;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final base = AppTextStyles.bodyLg(context);
    return Text(
      context.tr(text),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: base.merge(style).copyWith(
            color: color ?? base.color,
            height: height,
          ),
    );
  }
}
