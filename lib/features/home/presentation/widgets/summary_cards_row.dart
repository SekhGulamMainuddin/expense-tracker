import 'package:expense_tracker/core/styles/app_texts.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:expense_tracker/features/home/domain/entities/finance_snapshot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SummaryCardsRow extends StatelessWidget {
  const SummaryCardsRow({super.key, required this.snapshot});

  final FinanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: [
          _summaryItem(
            context,
            'Daily',
            snapshot.currencySymbol,
            snapshot.dailySpent,
            snapshot.dailyLimit,
            context.theme.colorScheme.primary,
          ),
          SizedBox(width: 12.w),
          _summaryItem(
            context,
            'Weekly',
            snapshot.currencySymbol,
            snapshot.weeklySpent,
            snapshot.weeklyLimit,
            context.theme.colorScheme.tertiary,
          ),
          SizedBox(width: 12.w),
          _summaryItem(
            context,
            'Monthly',
            snapshot.currencySymbol,
            snapshot.monthlySpent,
            snapshot.monthlyLimit,
            context.theme.colorScheme.error,
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(
    BuildContext context,
    String label,
    String currencySymbol,
    double spent,
    double limit,
    Color accent,
  ) {
    final cs = context.theme.colorScheme;
    final percent = limit <= 0 ? 0.0 : (spent / limit).clamp(0.0, 999.0);
    final isHealthy = spent <= limit || limit <= 0;

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
            AppTextTitleMd(
              '$currencySymbol${spent.toStringAsFixed(0)}',
            ),
            SizedBox(height: 4.h),
            AppTextLabelSm(
              '${percent.toStringAsFixed(0)}% of budget',
              style: context.theme.textTheme.labelSmall!.copyWith(
                fontWeight: FontWeight.w600,
              ),
              color: isHealthy ? accent : cs.error,
            ),
          ],
        ),
      ),
    );
  }
}
