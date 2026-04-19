import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/ui_extensions.dart';

class CategoryChartSection extends StatelessWidget {
  const CategoryChartSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Padding(
      padding: EdgeInsets.all(24.r),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Category Distribution',
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text('View Details', style: TextStyle(fontSize: 14.sp)),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: theme.colorScheme.outline.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 80.w,
                  height: 80.h,
                  child: CircularProgressIndicator(
                    value: 0.7,
                    strokeWidth: 10.w,
                    color: theme.colorScheme.primary,
                    backgroundColor: theme.colorScheme.secondary.withOpacity(0.1),
                  ),
                ),
                SizedBox(width: 30.w),
                Expanded(
                  child: Column(
                    children: [
                      _chartLegend(theme.colorScheme.primary, 'Housing', '45%'),
                      _chartLegend(const Color(0xFF10B981), 'Food', '30%'),
                      _chartLegend(Colors.orange, 'Transport', '25%'),
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


  Widget _chartLegend(Color color, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        children: [
          Container(
            width: 8.w,
            height: 8.h,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 13.sp, color: Colors.grey),
            ),
          ),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
          ),
        ],
      ),
    );
  }
}

