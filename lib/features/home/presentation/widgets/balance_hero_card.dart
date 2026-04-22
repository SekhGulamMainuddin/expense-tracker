import 'package:expense_tracker/core/styles/app_text_styles.dart';
import 'package:expense_tracker/core/styles/app_texts.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:expense_tracker/features/home/domain/entities/finance_snapshot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BalanceHeroCard extends StatelessWidget {
  const BalanceHeroCard({super.key, required this.snapshot});

  final FinanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final remaining = snapshot.monthlyBudgetRemaining;
    final utilization = snapshot.budgetUtilization;
    final overBudget = remaining < 0;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(24.r, 24.r, 24.r, 20.r),
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: context.isLight
              ? [cs.primary, cs.primaryContainer]
              : [cs.primaryContainer, cs.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.32),
            blurRadius: 24.r,
            offset: Offset(0, 12.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextLabelMd(
                  'Monthly Spend',
                  uppercase: true,
                  letterSpacing: 0.08,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
                SizedBox(height: 8.h),
                AppTextDisplayMd(
                  '${snapshot.currencySymbol}${snapshot.monthlySpent.toStringAsFixed(2)}',
                  style: AppTextStyles.displayMd(context),
                  color: Colors.white,
                ),
                SizedBox(height: 12.h),
                AppTextBodyMd(
                  overBudget
                      ? 'Over budget by ${snapshot.currencySymbol}${remaining.abs().toStringAsFixed(2)}'
                      : 'Remaining ${snapshot.currencySymbol}${remaining.toStringAsFixed(2)}',
                  color: Colors.white.withValues(alpha: 0.92),
                ),
                SizedBox(height: 18.h),
                Row(
                  children: [
                    _miniStat(
                      context,
                      'Budget',
                      '${(utilization * 100).toStringAsFixed(0)}%',
                    ),
                    SizedBox(width: 12.w),
                    _miniStat(
                      context,
                      'Trend',
                      _trendLabel(snapshot.monthlyComparison),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          SizedBox(
            width: 92.r,
            height: 92.r,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: utilization.clamp(0.0, 1.0),
                  strokeWidth: 10.w,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppTextTitleMd(
                      '${(utilization * 100).toStringAsFixed(0)}%',
                      color: Colors.white,
                    ),
                    AppTextLabelSm(
                      'used',
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniStat(BuildContext context, String label, String value) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextLabelSm(
              label,
              color: Colors.white.withValues(alpha: 0.78),
            ),
            SizedBox(height: 2.h),
            AppTextBodyLg(
              value,
              style: context.theme.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w700,
              ),
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  String _trendLabel(double value) {
    if (value == 0) {
      return 'Flat';
    }
    return value > 0 ? '+${value.toStringAsFixed(0)}%' : '${value.toStringAsFixed(0)}%';
  }
}
