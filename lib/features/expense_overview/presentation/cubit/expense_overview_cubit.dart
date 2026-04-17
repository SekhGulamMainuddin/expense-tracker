import 'package:bloc/bloc.dart';
import 'package:expense_tracker/features/expense_overview/data/models/expense_snapshot.dart';
import 'package:expense_tracker/features/expense_overview/data/repository/expense_overview_repository.dart';

part 'expense_overview_state.dart';

class ExpenseOverviewCubit extends Cubit<ExpenseOverviewState> {
  ExpenseOverviewCubit(this._repository) : super(ExpenseOverviewLoadingState());

  final ExpenseOverviewRepository _repository;

  Future<void> load() async {
    emit(ExpenseOverviewLoadingState());
    try {
      final snapshot = await _repository.fetchOverview();
      emit(ExpenseOverviewLoadedState(snapshot));
    } catch (_) {
      emit(ExpenseOverviewErrorState('overview.error'));
    }
  }
}
