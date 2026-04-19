import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_dimensions.dart';
import '../../../../core/styles/app_palette.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../core/styles/app_texts.dart';
import '../../../../core/utils/ui_extensions.dart';

class BudgetInput extends StatelessWidget {
  const BudgetInput({
    super.key,
    required this.label,
    required this.value,
    this.budgetBand,
  });

  final String label;
  final String value;

  /// Optional band for tonal wash behind the field: `'safe'` | `'caution'` | `'danger'`.
  final String? budgetBand;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    Color? wash;
    switch (budgetBand) {
      case 'safe':
        wash = AppPalette.safeBandWashGreen(cs);
        break;
      case 'caution':
        wash = AppPalette.safeBandWashYellow(cs);
        break;
      case 'danger':
        wash = AppPalette.safeBandWashRed(cs);
        break;
      default:
        wash = null;
    }

    final ghost = cs.outlineVariant.withOpacity(AppPalette.ghostBorderOpacity(context));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextLabelMd(
          label,
          
          uppercase: true,
          color: cs.onSurfaceVariant,
        ),
        SizedBox(height: 10.h),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: wash ?? cs.surfaceContainerLow,
            borderRadius: AppRadii.xl,
          ),
          child: TextField(
            controller: TextEditingController(text: value),
            style: AppTextStyles.headlineLg(context),
            decoration: InputDecoration(
              prefixText: '\$ ',
              prefixStyle: AppTextStyles.headlineLg(context).copyWith(
                color: cs.primary,
              ),
              filled: false,
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: ghost, width: 2.w),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ghost, width: 2.w),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: cs.primary.withOpacity(0.65), width: 2.w),
              ),
              contentPadding: EdgeInsets.only(bottom: 8.h),
            ),
          ),
        ),
      ],
    );
  }
}
