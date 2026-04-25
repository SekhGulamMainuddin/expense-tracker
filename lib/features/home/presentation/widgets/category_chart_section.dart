import 'package:expense_tracker/core/styles/app_texts.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:expense_tracker/core/widgets/app_icon.dart';
import 'package:expense_tracker/features/home/domain/entities/finance_category_breakdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryChartSection extends StatelessWidget {
  const CategoryChartSection({
    super.key,
    required this.breakdown,
    required this.currencySymbol,
    required this.onSeeAll,
  });

  final List<FinanceCategoryBreakdown> breakdown;
  final String currencySymbol;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.r),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               const AppTextHeadlineSm('home.chart_title'),
              TextButton(
                onPressed: onSeeAll,
                child: const AppTextLabelMd('home.see_all'),
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
            child: breakdown.isEmpty
                ? const _EmptyChartState()
                : Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 84.w,
                            height: 84.h,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircularProgressIndicator(
                                  value: 1,
                                  strokeWidth: 10.w,
                                  color: cs.surfaceContainerLow,
                                  backgroundColor: cs.surfaceContainerLow,
                                ),
                                CircularProgressIndicator(
                                  value: breakdown.first.percentage.clamp(0.0, 1.0),
                                  strokeWidth: 10.w,
                                  color: Color(breakdown.first.color),
                                  backgroundColor: cs.surfaceContainerLow,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Expanded(
                            child: Column(
                              children: [
                                for (final item in breakdown.take(3))
                                  _chartLegend(
                                    context,
                                    item,
                                  ),
                              ],
                            ),
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

  Widget _chartLegend(
    BuildContext context,
    FinanceCategoryBreakdown item,
  ) {
    final cs = context.theme.colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              color: Color(item.color).withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: AppIcon(
              item.icon,
              size: 16.r,
              color: Color(item.color),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextBodyMd(
                  item.title,
                  color: cs.onSurfaceVariant,
                ),
                SizedBox(height: 4.h),
                LinearProgressIndicator(
                  value: item.percentage.clamp(0.0, 1.0),
                  minHeight: 6.h,
                  borderRadius: BorderRadius.circular(99.r),
                  color: Color(item.color),
                  backgroundColor: cs.surfaceContainerLow,
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppTextBodyMd(
                '${(item.percentage * 100).toStringAsFixed(0)}%',
                style: context.theme.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppTextLabelSm(
                '$currencySymbol${item.amount.toStringAsFixed(0)}',
                color: cs.onSurfaceVariant,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyChartState extends StatelessWidget {
  const _EmptyChartState();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final cs = theme.colorScheme;
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Icon(Icons.pie_chart_outline, size: 56.r, color: cs.onSurfaceVariant),
          SizedBox(height: 12.h),
          AppTextBodyLg(
            'home.no_spending',
            style: theme.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6.h),
          AppTextBodyMd(
            'home.no_spending_desc',
            textAlign: TextAlign.center,
            color: cs.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
