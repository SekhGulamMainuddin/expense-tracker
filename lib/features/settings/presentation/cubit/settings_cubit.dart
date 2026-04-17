import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/settings/presentation/cubit/settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  void toggleCategory(String category) {
    final current = List<String>.from(state.expandedCategories);
    if (current.contains(category)) {
      current.remove(category);
    } else {
      current.add(category);
    }
    emit(state.copyWith(expandedCategories: current));
  }

  void updateLimit(String type, double value) {
    if (type == 'daily') emit(state.copyWith(dailyLimit: value));
    if (type == 'weekly') emit(state.copyWith(weeklyLimit: value));
    if (type == 'monthly') emit(state.copyWith(monthlyLimit: value));
  }

  void updateThreshold(String type, double value) {
    if (type == 'safe') emit(state.copyWith(safeHaven: value));
    if (type == 'caution') emit(state.copyWith(mildCaution: value));
    if (type == 'danger') emit(state.copyWith(dangerThreshold: value));
  }
}
