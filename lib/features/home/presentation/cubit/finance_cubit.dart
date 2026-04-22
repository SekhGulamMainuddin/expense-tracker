import 'dart:async';

import 'package:expense_tracker/features/home/domain/repositories/finance_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'finance_state.dart';

class FinanceCubit extends Cubit<FinanceState> {
  FinanceCubit(this._repository) : super(FinanceInitial()) {
    unawaited(loadDashboard());
  }

  final FinanceRepository _repository;

  Future<void> loadDashboard() async {
    emit(FinanceLoading());
    final result = await _repository.loadDashboard();
    result.fold(
      (snapshot) {
        emit(FinanceLoaded(snapshot));
      },
      (failure) {
        emit(FinanceFailure(failure.message));
      },
    );
  }

  Future<void> refresh() => loadDashboard();
}
