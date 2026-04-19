import 'package:flutter/material.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:expense_tracker/core/styles/app_dimensions.dart';
import 'package:expense_tracker/core/styles/app_text_styles.dart';
import 'package:expense_tracker/core/styles/app_texts.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });

  final String buttonText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: AppRadii.full),
        ),
        onPressed: onPressed,
        child: AppTextBodyLg(
          buttonText,
          style: AppTextStyles.bodyLg(context).copyWith(fontWeight: FontWeight.w600),
          color: cs.onPrimary,
        ),
      ),
    );
  }
}
