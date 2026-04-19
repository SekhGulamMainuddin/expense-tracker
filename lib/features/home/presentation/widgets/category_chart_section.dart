import 'package:flutter/material.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_texts.dart';

class CategoryChartSection extends StatelessWidget {
  const CategoryChartSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return Padding(
      padding: EdgeInsets.all(24.r),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppTextHeadlineSm('Category Distribution',),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: cs.surfaceContainer,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 80.w,
                  height: 80.h,
                  child: CircularProgressIndicator(
                    value: 0.7,
                    strokeWidth: 10.w,
                    color: cs.primary,
                    backgroundColor: cs.primaryContainer.withOpacity(0.35),
                  ),
                ),
                SizedBox(width: 30.w),
                Expanded(
                  child: Column(
                    children: [
                      _chartLegend(context, cs.primary, 'Housing', '45%'),
                      _chartLegend(
                          context, const Color(0xFF10B981), 'Food', '30%'),
                      _chartLegend(context, Colors.orange, 'Transport', '25%'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chartLegend(BuildContext context, Color color, String label,
      String value) {
    final cs = context.theme.colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Container(
            width: 8.w,
            height: 8.h,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: AppTextBodyMd(
              label,

              color: cs.onSurfaceVariant,
            ),
          ),
          AppTextBodyMd(
            value,

            style: context.theme.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
