import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:expense_tracker/core/styles/app_palette.dart';
import 'package:expense_tracker/core/styles/app_texts.dart';
import 'package:expense_tracker/core/widgets/primary_button.dart';

class AppAlertDialog extends StatelessWidget {
  const AppAlertDialog({
    super.key,
    required this.dialogId,
    this.title,
    this.subtitle,
    this.buttonText,
    this.onPressed,
    this.content,
    this.isDismissible = true,
  });

  final String dialogId;
  final String? title;
  final String? subtitle;
  final String? buttonText;
  final VoidCallback? onPressed;
  final Widget? content;
  final bool isDismissible;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      backgroundColor: AppPalette.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) appTextS1(title!),
            if (subtitle != null) ...[8.verticalSpace, appTextB2(subtitle!)],
            if (content != null) ...[16.verticalSpace, content!],
            if (buttonText != null && onPressed != null) ...[
              20.verticalSpace,
              PrimaryButton(buttonText: buttonText!, onPressed: onPressed),
            ],
          ],
        ),
      ),
    );
  }
}
