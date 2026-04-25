import 'package:auto_size_text/auto_size_text.dart';
import 'package:expense_tracker/core/di/service_locator.dart';
import 'package:expense_tracker/core/styles/app_texts.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:expense_tracker/core/widgets/app_icon.dart';
import 'package:expense_tracker/features/home/domain/entities/finance_category_breakdown.dart';
import 'package:expense_tracker/features/home/domain/entities/time_range.dart';
import 'package:expense_tracker/features/home/presentation/cubit/category_chart_cubit.dart';
import 'package:expense_tracker/features/home/presentation/cubit/category_chart_state.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class CategoryChartSection extends StatefulWidget {
  const CategoryChartSection({
    super.key,
    required this.currencySymbol,
  });

  final String currencySymbol;

  @override
  State<CategoryChartSection> createState() => _CategoryChartSectionState();
}

class _CategoryChartSectionState extends State<CategoryChartSection> {
  late final CategoryChartCubit _cubit;
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<CategoryChartCubit>();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return BlocBuilder<CategoryChartCubit, CategoryChartState>(
      bloc: _cubit,
      builder: (context, state) {
        if (state is CategoryChartLoading) {
          return const _CategoryChartShimmer();
        }

        if (state is CategoryChartFailure) {
          return Center(child: Text(state.message));
        }

        final breakdown =
            state is CategoryChartLoaded ? state.breakdown : <FinanceCategoryBreakdown>[];
        final currentTimeRange =
            state is CategoryChartLoaded ? state.range : TimeRange.monthly;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AppTextHeadlineSm('home.chart_title'),
              SizedBox(height: 8.h),
              _TimeRangeSelector(
                currentRange: currentTimeRange,
                onChanged: _cubit.changeTimeRange,
              ),
              SizedBox(height: 16.h),
              Stack(
                children: [
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
                                    width: 130.w,
                                    height: 130.w,
                                    child: PieChart(
                                      PieChartData(
                                        pieTouchData: PieTouchData(
                                          touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                            setState(() {
                                              if (!event.isInterestedForInteractions ||
                                                  pieTouchResponse == null ||
                                                  pieTouchResponse.touchedSection == null) {
                                                touchedIndex = -1;
                                                return;
                                              }
                                              touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                                            });
                                          },
                                        ),
                                        borderData: FlBorderData(show: false),
                                        sectionsSpace: 4,
                                        centerSpaceRadius: 32.r,
                                        sections: List.generate(breakdown.length, (i) {
                                          final isTouched = i == touchedIndex;
                                          final fontSize = isTouched ? 16.sp : 12.sp;
                                          final radius = isTouched ? 38.r : 30.r;
                                          final item = breakdown[i];
                                          
                                          return PieChartSectionData(
                                            color: Color(item.color),
                                            value: item.percentage * 100,
                                            title: isTouched ? '${(item.percentage * 100).toStringAsFixed(0)}%' : '',
                                            radius: radius,
                                            titleStyle: TextStyle(
                                              fontSize: fontSize,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            badgeWidget: isTouched ? _Badge(item.icon, size: 22.r, borderColor: Color(item.color)) : null,
                                            badgePositionPercentageOffset: 1.1,
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20.w),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        for (int i = 0; i < breakdown.length && i < 3; i++)
                                          _chartLegend(
                                            context,
                                            breakdown[i],
                                            isHighlighted: i == touchedIndex,
                                            index: i,
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (breakdown.length > 3) ...[
                                SizedBox(height: 16.h),
                                Divider(color: cs.outlineVariant, height: 1),
                                SizedBox(height: 16.h),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: breakdown.length - 3,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisExtent: 52.h,
                                    crossAxisSpacing: 16.w,
                                    mainAxisSpacing: 8.h,
                                  ),
                                  itemBuilder: (context, index) {
                                    final itemIndex = index + 3;
                                    return _chartLegend(
                                      context,
                                      breakdown[itemIndex],
                                      isHighlighted: itemIndex == touchedIndex,
                                      index: itemIndex,
                                    );
                                  },
                                ),
                              ],
                            ],
                          ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _chartLegend(
    BuildContext context,
    FinanceCategoryBreakdown item, {
    bool isHighlighted = false,
    required int index,
  }) {
    final cs = context.theme.colorScheme;
    return InkWell(
      onTap: () {
        setState(() {
          touchedIndex = isHighlighted ? -1 : index;
        });
      },
      borderRadius: BorderRadius.circular(8.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: isHighlighted ? EdgeInsets.all(6.r) : EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.r),
        decoration: BoxDecoration(
          color: isHighlighted ? Color(item.color).withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: Color(item.color).withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: AppIcon(
                  item.icon,
                  size: 16.r,
                  color: Color(item.color),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AutoSizeText(
                    item.title,
                    maxLines: 1,
                    minFontSize: 10,
                    overflow: TextOverflow.ellipsis,
                    style: context.theme.textTheme.bodyMedium!.copyWith(
                      color: cs.onSurface,
                      fontWeight: isHighlighted ? FontWeight.w800 : FontWeight.w600,
                      fontSize: 13.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  AppTextLabelSm(
                    '${widget.currencySymbol}${item.amount.toStringAsFixed(0)}',
                    color: cs.onSurfaceVariant,
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            AppTextBodyMd(
              '${(item.percentage * 100).toStringAsFixed(0)}%',
              color: isHighlighted ? Color(item.color) : cs.onSurfaceVariant,
              style: context.theme.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(
    this.icon, {
    required this.size,
    required this.borderColor,
  });
  final String icon;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 1.5.r,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: AppIcon(
          icon,
          color: borderColor,
          size: size * 0.6,
        ),
      ),
    );
  }
}

class _TimeRangeSelector extends StatelessWidget {
  const _TimeRangeSelector({
    required this.currentRange,
    required this.onChanged,
  });

  final TimeRange currentRange;
  final ValueChanged<TimeRange> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return SegmentedButton<TimeRange>(
      segments: const [
        ButtonSegment(
          value: TimeRange.daily,
          label: Text('Daily'),
          icon: Icon(Icons.today, size: 16),
        ),
        ButtonSegment(
          value: TimeRange.weekly,
          label: Text('Weekly'),
          icon: Icon(Icons.date_range, size: 16),
        ),
        ButtonSegment(
          value: TimeRange.monthly,
          label: Text('Monthly'),
          icon: Icon(Icons.calendar_month, size: 16),
        ),
      ],
      selected: {currentRange},
      onSelectionChanged: (Set<TimeRange> selection) {
        onChanged(selection.first);
      },
      showSelectedIcon: false,
      style: SegmentedButton.styleFrom(
        visualDensity: VisualDensity.compact,
        padding: EdgeInsets.zero,
        backgroundColor: cs.surfaceContainerLow,
        selectedBackgroundColor: cs.primaryContainer,
        selectedForegroundColor: cs.onPrimaryContainer,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}

class _CategoryChartShimmer extends StatelessWidget {
  const _CategoryChartShimmer();

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.r),
      child: Shimmer.fromColors(
        baseColor: cs.surfaceContainer,
        highlightColor: cs.surfaceContainerHigh,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 120.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                Container(
                  width: 60.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Container(
              height: 40.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 24.w),
                  Expanded(
                    child: Column(
                      children: List.generate(
                        3,
                        (index) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 6.h),
                          child: Row(
                            children: [
                              Container(
                                width: 32.w,
                                height: 32.w,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Container(
                                  height: 32.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
