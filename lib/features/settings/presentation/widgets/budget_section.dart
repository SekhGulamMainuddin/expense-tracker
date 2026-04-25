import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:expense_tracker/features/settings/domain/entities/settings_snapshot.dart';
import 'package:expense_tracker/features/settings/presentation/cubit/budget_section_cubit.dart';
import 'package:expense_tracker/features/settings/presentation/cubit/budget_section_state.dart';
import 'package:expense_tracker/features/settings/presentation/widgets/budget_input.dart';
import 'package:expense_tracker/features/settings/presentation/widgets/threshold_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BudgetSection extends StatefulWidget {
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
  State<BudgetSection> createState() => _BudgetSectionState();
}

class _BudgetSectionState extends State<BudgetSection> {
  late final BudgetSectionCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = BudgetSectionCubit(widget.snapshot);
  }

  @override
  void didUpdateWidget(BudgetSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.snapshot != oldWidget.snapshot) {
      _cubit.updateSnapshot(widget.snapshot);
    }
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _saveChanges() {
    FocusScope.of(context).unfocus();
    
    // Allow focus loss to trigger BudgetInput's onSubmitted before checking changes
    Future.microtask(() {
      if (!mounted) return;
      _cubit.saveChanges(
        onDailyChanged: widget.onDailyChanged,
        onWeeklyChanged: widget.onWeeklyChanged,
        onMonthlyChanged: widget.onMonthlyChanged,
        onSafeThresholdChanged: widget.onSafeThresholdChanged,
        onCautionThresholdChanged: widget.onCautionThresholdChanged,
        onDangerThresholdChanged: widget.onDangerThresholdChanged,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<BudgetSectionCubit, BudgetSectionState>(
        builder: (context, state) {
          final cs = context.theme.colorScheme;
          final currencySymbol = _currencySymbol(state.snapshot.baseCurrencyCode);

          return Container(
            padding: EdgeInsets.all(24.r),
            decoration: BoxDecoration(
              color: cs.surfaceContainer,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BudgetInput(
                  label: 'Daily Limit',
                  value: state.daily,
                  currencySymbol: currencySymbol,
                  budgetBand: 'safe',
                  onChanged: _cubit.updateDaily,
                  onSubmitted: _cubit.updateDaily,
                ),
                SizedBox(height: 16.h),
                BudgetInput(
                  label: 'Weekly Limit',
                  value: state.weekly,
                  currencySymbol: currencySymbol,
                  budgetBand: 'caution',
                  onChanged: _cubit.updateWeekly,
                  onSubmitted: _cubit.updateWeekly,
                ),
                SizedBox(height: 16.h),
                BudgetInput(
                  label: 'Monthly Limit',
                  value: state.monthly,
                  currencySymbol: currencySymbol,
                  budgetBand: 'danger',
                  onChanged: _cubit.updateMonthly,
                  onSubmitted: _cubit.updateMonthly,
                ),
                Divider(height: 48.h),
                ThresholdSlider(
                  label: 'Safe Haven Zone',
                  color: const Color(0xFF10B981),
                  value: state.safe,
                  onChanged: _cubit.updateSafe,
                ),
                ThresholdSlider(
                  label: 'Mild Caution',
                  color: Colors.orange,
                  value: state.caution,
                  onChanged: _cubit.updateCaution,
                ),
                ThresholdSlider(
                  label: 'Danger Threshold',
                  color: Colors.red,
                  value: state.danger,
                  onChanged: _cubit.updateDanger,
                ),
                
                if (state.hasChanges) ...[
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _cubit.discardChanges,
                          child: const Text('Discard'),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: FilledButton(
                          onPressed: _saveChanges,
                          child: const Text('Save Changes'),
                        ),
                      ),
                    ],
                  ),
                ]
              ],
            ),
          );
        },
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
