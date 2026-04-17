part of 'expense_overview_cubit.dart';

sealed class ExpenseOverviewState {}

final class ExpenseOverviewLoadingState extends ExpenseOverviewState {}

final class ExpenseOverviewLoadedState extends ExpenseOverviewState {
  ExpenseOverviewLoadedState(this.snapshot);

  final ExpenseSnapshot snapshot;
}

final class ExpenseOverviewErrorState extends ExpenseOverviewState {
  ExpenseOverviewErrorState(this.message);

  final String message;
}
