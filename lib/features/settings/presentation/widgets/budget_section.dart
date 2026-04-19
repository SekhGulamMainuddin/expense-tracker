import 'package:flutter/material.dart';
import 'package:expense_tracker/features/settings/presentation/widgets/budget_input.dart';
import 'package:expense_tracker/features/settings/presentation/widgets/threshold_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/ui_extensions.dart';

class BudgetSection extends StatelessWidget {
  const BudgetSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          const BudgetInput(label: 'Daily Limit', value: '50'),
          SizedBox(height: 16.h),
          const BudgetInput(label: 'Weekly Limit', value: '350'),
          SizedBox(height: 16.h),
          const BudgetInput(label: 'Monthly Limit', value: '1500'),
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

