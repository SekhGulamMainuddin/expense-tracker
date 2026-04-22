import 'package:expense_tracker/features/settings/domain/entities/settings_snapshot.dart';

sealed class SettingsState {}

final class SettingsInitial extends SettingsState {}

final class SettingsLoading extends SettingsState {}

final class SettingsLoaded extends SettingsState {
  SettingsLoaded(this.snapshot);

  final SettingsSnapshot snapshot;
}

final class SettingsFailure extends SettingsState {
  SettingsFailure(this.errorMessage);

  final String errorMessage;
}
