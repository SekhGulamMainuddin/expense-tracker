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
  void _startWatching() {
    _subscription?.cancel();
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

  /// Manual refresh.
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
