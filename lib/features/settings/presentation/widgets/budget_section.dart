import 'package:flutter/material.dart';
import 'package:expense_tracker/features/settings/presentation/widgets/budget_input.dart';
import 'package:expense_tracker/features/settings/presentation/widgets/threshold_slider.dart';

class BudgetSection extends StatelessWidget {
  const BudgetSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const Column(
        children: [
          BudgetInput(label: 'Daily Limit', value: '50'),
          SizedBox(height: 16),
          BudgetInput(label: 'Weekly Limit', value: '350'),
          SizedBox(height: 16),
          BudgetInput(label: 'Monthly Limit', value: '1500'),
          Divider(height: 48),
          ThresholdSlider(
            label: 'Safe Haven Zone',
            color: Color(0xFF10B981),
            type: 'safe',
          ),
          ThresholdSlider(
            label: 'Mild Caution',
            color: Colors.orange,
            type: 'caution',
          ),
          ThresholdSlider(
            label: 'Danger Threshold',
            color: Colors.red,
            type: 'danger',
          ),
        ],
      ),
    );
  }
}
