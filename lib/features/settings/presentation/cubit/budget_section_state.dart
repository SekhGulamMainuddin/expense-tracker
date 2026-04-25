import 'package:equatable/equatable.dart';
import 'package:expense_tracker/features/settings/domain/entities/settings_snapshot.dart';

class BudgetSectionState extends Equatable {
  const BudgetSectionState({
    required this.snapshot,
    required this.daily,
    required this.weekly,
    required this.monthly,
    required this.safe,
    required this.caution,
    required this.danger,
  });

  final SettingsSnapshot snapshot;
  final double daily;
  final double weekly;
  final double monthly;
  final double safe;
  final double caution;
  final double danger;

  bool get hasChanges {
    return daily != snapshot.dailyLimit ||
        weekly != snapshot.weeklyLimit ||
        monthly != snapshot.monthlyLimit ||
        safe != snapshot.safeThreshold ||
        caution != snapshot.cautionThreshold ||
        danger != snapshot.dangerThreshold;
  }

  factory BudgetSectionState.initial(SettingsSnapshot snapshot) {
    return BudgetSectionState(
      snapshot: snapshot,
      daily: snapshot.dailyLimit,
      weekly: snapshot.weeklyLimit,
      monthly: snapshot.monthlyLimit,
      safe: snapshot.safeThreshold,
      caution: snapshot.cautionThreshold,
      danger: snapshot.dangerThreshold,
    );
  }

  BudgetSectionState copyWith({
    SettingsSnapshot? snapshot,
    double? daily,
    double? weekly,
    double? monthly,
    double? safe,
    double? caution,
    double? danger,
  }) {
    return BudgetSectionState(
      snapshot: snapshot ?? this.snapshot,
      daily: daily ?? this.daily,
      weekly: weekly ?? this.weekly,
      monthly: monthly ?? this.monthly,
      safe: safe ?? this.safe,
      caution: caution ?? this.caution,
      danger: danger ?? this.danger,
    );
  }

  @override
  List<Object> get props => [snapshot, daily, weekly, monthly, safe, caution, danger];
}
