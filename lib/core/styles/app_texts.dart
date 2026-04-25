import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/core/styles/app_text_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';

// AutoSizeText widgets with optional arguments
class AppAutoSizeTextBodyLg extends StatelessWidget {
  const AppAutoSizeTextBodyLg(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.textAlign,
    this.maxLines = 1,
    this.minFontSize = 10,
    this.args,
    this.namedArgs,
  });

  final String text;
  final List<String>? args;
  final Map<String, String>? namedArgs;
  final TextStyle? style;
  final Color? color;
  final TextAlign? textAlign;
  final int maxLines;
  final double minFontSize;

  @override
  Widget build(BuildContext context) {
    final base = AppTextStyles.bodyLg(context);
    return AutoSizeText(
      context.tr(text, args: args, namedArgs: namedArgs),
      textAlign: textAlign,
      maxLines: maxLines,
      minFontSize: minFontSize,
      style: base.merge(style).copyWith(color: color ?? base.color),
    );
  }
}

class AppAutoSizeTextLabelSm extends StatelessWidget {
  const AppAutoSizeTextLabelSm(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.textAlign,
    this.maxLines = 1,
    this.minFontSize = 8,
    this.letterSpacing = 0.05,
    this.uppercase = false,
    this.fontWeight,
    this.args,
    this.namedArgs,
  });

  final String text;
  final List<String>? args;
  final Map<String, String>? namedArgs;
  final TextStyle? style;
  final Color? color;
  final TextAlign? textAlign;
  final int maxLines;
  final double minFontSize;
  final double letterSpacing;
  final bool uppercase;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    final raw = context.tr(text, args: args, namedArgs: namedArgs);
    final display = uppercase ? raw.toUpperCase() : raw;
    final base = AppTextStyles.labelSm(context);
    return AutoSizeText(
      display,
      textAlign: textAlign,
      maxLines: maxLines,
      minFontSize: minFontSize,
      style: base
          .merge(style)
          .copyWith(
            color: color ?? base.color,
            letterSpacing: letterSpacing,
            fontWeight: fontWeight ?? base.fontWeight,
          ),
    );
  }
}

// Regular Text widgets (no auto size)
class AppTextDisplayLg extends StatelessWidget {
  const AppTextDisplayLg(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.args,
    this.namedArgs,
  });

  final String text;
  final List<String>? args;
  final Map<String, String>? namedArgs;
  final TextStyle? style;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final base = AppTextStyles.displayLg(context);
    return Text(
      context.tr(text, args: args, namedArgs: namedArgs),
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
    this.args,
    this.namedArgs,
  });

  final String text;
  final List<String>? args;
  final Map<String, String>? namedArgs;
  final TextStyle? style;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final base = AppTextStyles.displayMd(context);
    return Text(
      context.tr(text, args: args, namedArgs: namedArgs),
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
    this.args,
    this.namedArgs,
  });

  final String text;
  final List<String>? args;
  final Map<String, String>? namedArgs;
  final TextStyle? style;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final base = AppTextStyles.displaySm(context);
    return Text(
      context.tr(text, args: args, namedArgs: namedArgs),
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
    this.args,
    this.namedArgs,
  });

  final String text;
  final List<String>? args;
  final Map<String, String>? namedArgs;
  final TextStyle? style;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final base = AppTextStyles.headlineLg(context);
    return Text(
      context.tr(text, args: args, namedArgs: namedArgs),
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
    this.args,
    this.namedArgs,
  });

  final String text;
  final List<String>? args;
  final Map<String, String>? namedArgs;
  final TextStyle? style;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final base = AppTextStyles.headlineSm(context);
    return Text(
      context.tr(text, args: args, namedArgs: namedArgs),
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
    this.args,
    this.namedArgs,
  });

  final String text;
  final List<String>? args;
  final Map<String, String>? namedArgs;
  final TextStyle? style;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final base = AppTextStyles.titleMd(context);
    return Text(
      context.tr(text, args: args, namedArgs: namedArgs),
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
    this.fontWeight,
    this.args,
    this.namedArgs,
  });

  final String text;
  final List<String>? args;
  final Map<String, String>? namedArgs;
  final TextStyle? style;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double letterSpacing;
  final bool uppercase;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    final raw = context.tr(text, args: args, namedArgs: namedArgs);
    final display = uppercase ? raw.toUpperCase() : raw;
    final base = AppTextStyles.labelMd(context);
    return Text(
      display,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: base
          .merge(style)
          .copyWith(
            color: color ?? base.color,
            letterSpacing: letterSpacing,
            fontWeight: fontWeight ?? base.fontWeight,
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
    this.fontWeight,
    this.args,
    this.namedArgs,
  });

  final String text;
  final List<String>? args;
  final Map<String, String>? namedArgs;
  final TextStyle? style;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double letterSpacing;
  final bool uppercase;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    final raw = context.tr(text, args: args, namedArgs: namedArgs);
    final display = uppercase ? raw.toUpperCase() : raw;
    final base = AppTextStyles.labelSm(context);
    return Text(
      display,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: base
          .merge(style)
          .copyWith(
            color: color ?? base.color,
            letterSpacing: letterSpacing,
            fontWeight: fontWeight ?? base.fontWeight,
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
    this.args,
    this.namedArgs,
  });

  final String text;
  final TextStyle? style;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? height;
  final List<String>? args;
  final Map<String, String>? namedArgs;

  @override
  Widget build(BuildContext context) {
    final base = AppTextStyles.bodyMd(context);
    return Text(
      context.tr(text, args: args, namedArgs: namedArgs),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: base.merge(style).copyWith(color: color ?? base.color, height: height),
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
    this.args,
    this.namedArgs,
  });

  final String text;
  final TextStyle? style;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? height;
  final List<String>? args;
  final Map<String, String>? namedArgs;

  @override
  Widget build(BuildContext context) {
    final base = AppTextStyles.bodyLg(context);
    return Text(
      context.tr(text, args: args, namedArgs: namedArgs),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: base.merge(style).copyWith(color: color ?? base.color, height: height),
    );
  }
}
