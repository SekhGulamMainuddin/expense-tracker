import 'dart:async';

import 'package:expense_tracker/features/home/domain/repositories/finance_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'finance_state.dart';

class FinanceCubit extends Cubit<FinanceState> {
  FinanceCubit(this._repository) : super(FinanceInitial()) {
    _startWatching();
  }

  final FinanceRepository _repository;
  StreamSubscription<void>? _subscription;

  /// Subscribes to the reactive dashboard stream.
  /// Every time an expense or category changes in the DB, the
  /// dashboard is automatically recomputed and a new state is emitted.
  void _startWatching() {
    emit(FinanceLoading());
    _subscription = _repository.watchDashboard().listen(
      (snapshot) {
        emit(FinanceLoaded(snapshot));
      },
      onError: (Object error) {
        emit(FinanceFailure(error.toString()));
      },
    );
  }

  /// Manual refresh — useful for pull-to-refresh gesture.
  /// Reloads from the one-time Future endpoint, then re-emits.
  Future<void> refresh() async {
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

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
