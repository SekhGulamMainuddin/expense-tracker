import 'package:expense_tracker/features/home/domain/entities/finance_snapshot.dart';

sealed class FinanceState {}

final class FinanceInitial extends FinanceState {}

final class FinanceLoading extends FinanceState {}

final class FinanceLoaded extends FinanceState {
  FinanceLoaded(this.snapshot);

  final FinanceSnapshot snapshot;
}

final class FinanceFailure extends FinanceState {
  FinanceFailure(this.message);

  final String message;
}
