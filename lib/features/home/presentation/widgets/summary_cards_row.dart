import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/ui_extensions.dart';

class SummaryCardsRow extends StatelessWidget {
  const SummaryCardsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: [
          _summaryItem(context, 'Daily', '\$42.50', '-5%', Colors.red),
          SizedBox(width: 12.w),
          _summaryItem(context, 'Weekly', '\$310.20', '+2%', const Color(0xFF10B981)),
          SizedBox(width: 12.w),
          _summaryItem(context, 'Monthly', '\$1,240', '-1%', Colors.red),
        ],
      ),
    );
  }

  Widget _summaryItem(BuildContext context, String label, String value, String percent, Color pColor) {
    final theme = context.theme;
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: theme.colorScheme.outline.withOpacity(0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.grey, fontSize: 12.sp),
            ),
            SizedBox(height: 4.h),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                color: theme.colorScheme.onSurface,
              ),
            ),
            Text(
              percent,
              style: TextStyle(
                color: pColor,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


