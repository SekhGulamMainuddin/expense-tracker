import 'package:flutter/material.dart';
import 'package:expense_tracker/features/settings/presentation/widgets/budget_input.dart';
import 'package:expense_tracker/features/settings/presentation/widgets/threshold_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/ui_extensions.dart';

class BudgetSection extends StatelessWidget {
  const BudgetSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          const BudgetInput(
            label: 'Daily Limit',
            value: '50',
            budgetBand: 'safe',
          ),
          SizedBox(height: 16.h),
          const BudgetInput(
            label: 'Weekly Limit',
            value: '350',
            budgetBand: 'caution',
          ),
          SizedBox(height: 16.h),
          const BudgetInput(
            label: 'Monthly Limit',
            value: '1500',
            budgetBand: 'danger',
          ),
          Divider(height: 48.h),
          const ThresholdSlider(
            label: 'Safe Haven Zone',
            color: Color(0xFF10B981),
            type: 'safe',
          ),
          const ThresholdSlider(
            label: 'Mild Caution',
            color: Colors.orange,
            type: 'caution',
          ),
          const ThresholdSlider(
            label: 'Danger Threshold',
            color: Colors.red,
            type: 'danger',
          ),
        ],
      ),
    );
  }
}
