import 'package:expense_tracker/features/settings/domain/entities/settings_snapshot.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'budget_section_state.dart';

class BudgetSectionCubit extends Cubit<BudgetSectionState> {
  BudgetSectionCubit(SettingsSnapshot initialSnapshot)
      : super(BudgetSectionState.initial(initialSnapshot));

  void updateSnapshot(SettingsSnapshot newSnapshot) {
    if (state.hasChanges) {
      // If user is editing, just update the reference snapshot
      // so we can still compare correctly without losing edits.
      emit(state.copyWith(snapshot: newSnapshot));
    } else {
      // If no changes, safely reset to the new snapshot
      emit(BudgetSectionState.initial(newSnapshot));
    }
  }

  void updateDaily(double value) => emit(state.copyWith(daily: value));
  void updateWeekly(double value) => emit(state.copyWith(weekly: value));
  void updateMonthly(double value) => emit(state.copyWith(monthly: value));
  void updateSafe(double value) => emit(state.copyWith(safe: value));
  void updateCaution(double value) => emit(state.copyWith(caution: value));
  void updateDanger(double value) => emit(state.copyWith(danger: value));

  void discardChanges() {
    emit(BudgetSectionState.initial(state.snapshot));
  }

  void saveChanges({
    required void Function(double) onDailyChanged,
    required void Function(double) onWeeklyChanged,
    required void Function(double) onMonthlyChanged,
    required void Function(double) onSafeThresholdChanged,
    required void Function(double) onCautionThresholdChanged,
    required void Function(double) onDangerThresholdChanged,
  }) {
    if (state.daily != state.snapshot.dailyLimit) onDailyChanged(state.daily);
    if (state.weekly != state.snapshot.weeklyLimit) onWeeklyChanged(state.weekly);
    if (state.monthly != state.snapshot.monthlyLimit) onMonthlyChanged(state.monthly);
    if (state.safe != state.snapshot.safeThreshold) onSafeThresholdChanged(state.safe);
    if (state.caution != state.snapshot.cautionThreshold) onCautionThresholdChanged(state.caution);
    if (state.danger != state.snapshot.dangerThreshold) onDangerThresholdChanged(state.danger);
  }
}
