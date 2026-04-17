import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:expense_tracker/core/styles/app_palette.dart';
import 'package:expense_tracker/core/styles/app_texts.dart';
import 'package:expense_tracker/features/expense_overview/data/models/expense_snapshot.dart';

class ExpenseSummaryCard extends StatelessWidget {
  const ExpenseSummaryCard({super.key, required this.snapshot});

  final ExpenseSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appTextS1(snapshot.titleKey),
            8.verticalSpace,
            appTextB2(snapshot.descriptionKey),
            20.verticalSpace,
            appTextH1(snapshot.spentLabel),
            8.verticalSpace,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppPalette.secondary,
                borderRadius: BorderRadius.circular(999.r),
              ),
              child: appTextB2(snapshot.remainingLabel),
            ),
          ],
        ),
      ),
    );
  }
}
