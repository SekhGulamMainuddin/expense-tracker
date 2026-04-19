import 'package:flutter/material.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_texts.dart';

class SummaryCardsRow extends StatelessWidget {
  const SummaryCardsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: [
          _summaryItem(context, 'Daily', '\$42.50', '-5%', context.theme.colorScheme.error),
          SizedBox(width: 12.w),
          _summaryItem(context, 'Weekly', '\$310.20', '+2%', context.theme.colorScheme.secondary),
          SizedBox(width: 12.w),
          _summaryItem(context, 'Monthly', '\$1,240', '-1%', context.theme.colorScheme.error),
        ],
      ),
    );
  }

  Widget _summaryItem(
    BuildContext context,
    String label,
    String value,
    String percent,
    Color pColor,
  ) {
    final cs = context.theme.colorScheme;
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextLabelMd(
              label,
              
              uppercase: true,
              color: cs.onSurfaceVariant,
            ),
            SizedBox(height: 6.h),
            AppTextTitleMd(value, ),
            AppTextLabelSm(
              percent,
              
              style: context.theme.textTheme.labelSmall!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              color: pColor,
            ),
          ],
        ),
      ),
    );
  }
}
