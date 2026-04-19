import 'package:flutter/material.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:expense_tracker/core/styles/app_dimensions.dart';
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
    final cs = context.theme.colorScheme;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      backgroundColor: cs.surfaceContainerHigh,
      shape: RoundedRectangleBorder(borderRadius: AppRadii.xl),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) AppTextHeadlineSm(title!),
            if (subtitle != null) ...[
              8.verticalSpace,
              AppTextBodyMd(subtitle!, color: cs.onSurfaceVariant),
            ],
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
