import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:expense_tracker/features/settings/domain/entities/settings_snapshot.dart';
import 'package:expense_tracker/features/settings/presentation/widgets/budget_input.dart';
import 'package:expense_tracker/features/settings/presentation/widgets/threshold_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BudgetSection extends StatelessWidget {
  const BudgetSection({
    super.key,
    required this.snapshot,
    required this.onDailyChanged,
    required this.onWeeklyChanged,
    required this.onMonthlyChanged,
    required this.onSafeThresholdChanged,
    required this.onCautionThresholdChanged,
    required this.onDangerThresholdChanged,
  });

  final SettingsSnapshot snapshot;
  final ValueChanged<double> onDailyChanged;
  final ValueChanged<double> onWeeklyChanged;
  final ValueChanged<double> onMonthlyChanged;
  final ValueChanged<double> onSafeThresholdChanged;
  final ValueChanged<double> onCautionThresholdChanged;
  final ValueChanged<double> onDangerThresholdChanged;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final currencySymbol = _currencySymbol(snapshot.baseCurrencyCode);

    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          BudgetInput(
            label: 'Daily Limit',
            value: snapshot.dailyLimit,
            currencySymbol: currencySymbol,
            budgetBand: 'safe',
            onSubmitted: onDailyChanged,
          ),
          SizedBox(height: 16.h),
          BudgetInput(
            label: 'Weekly Limit',
            value: snapshot.weeklyLimit,
            currencySymbol: currencySymbol,
            budgetBand: 'caution',
            onSubmitted: onWeeklyChanged,
          ),
          SizedBox(height: 16.h),
          BudgetInput(
            label: 'Monthly Limit',
            value: snapshot.monthlyLimit,
            currencySymbol: currencySymbol,
            budgetBand: 'danger',
            onSubmitted: onMonthlyChanged,
          ),
          Divider(height: 48.h),
          ThresholdSlider(
            label: 'Safe Haven Zone',
            color: const Color(0xFF10B981),
            value: snapshot.safeThreshold,
            onChanged: onSafeThresholdChanged,
          ),
          ThresholdSlider(
            label: 'Mild Caution',
            color: Colors.orange,
            value: snapshot.cautionThreshold,
            onChanged: onCautionThresholdChanged,
          ),
          ThresholdSlider(
            label: 'Danger Threshold',
            color: Colors.red,
            value: snapshot.dangerThreshold,
            onChanged: onDangerThresholdChanged,
          ),
        ],
      ),
    );
  }

  String _currencySymbol(String currencyCode) {
    return switch (currencyCode.toLowerCase()) {
      'usd' => '\$',
      'eur' => '€',
      'inr' => '₹',
      _ => currencyCode.toUpperCase(),
    };
  }
}
