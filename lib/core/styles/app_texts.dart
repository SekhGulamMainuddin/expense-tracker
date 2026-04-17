import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/core/styles/app_text_styles.dart';

Widget appTextH1(String text, {Color? color, TextAlign? textAlign}) => Text(
  text.tr(),
  textAlign: textAlign,
  style: AppTextStyles.h1.copyWith(color: color),
);

Widget appTextS1(String text, {Color? color, TextAlign? textAlign}) => Text(
  text.tr(),
  textAlign: textAlign,
  style: AppTextStyles.s1.copyWith(color: color),
);

Widget appTextB1(String text, {Color? color, TextAlign? textAlign}) => Text(
  text.tr(),
  textAlign: textAlign,
  style: AppTextStyles.b1.copyWith(color: color),
);

Widget appTextB2(String text, {Color? color, TextAlign? textAlign}) => Text(
  text.tr(),
  textAlign: textAlign,
  style: AppTextStyles.b2.copyWith(color: color),
);
