import 'dart:async';

import 'package:expense_tracker/core/exchange/domain/repositories/exchange_rate_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'exchange_rate_state.dart';

class ExchangeRateCubit extends Cubit<ExchangeRateState> {
  ExchangeRateCubit(this._repository) : super(ExchangeRateInitial()) {
    unawaited(load());
  }

  final ExchangeRateRepository _repository;

  /// Reads whatever rates are in effect without forcing a network call.
  Future<void> load() async {
    emit(ExchangeRateLoading());
    emit(ExchangeRateLoaded(await _repository.currentRates()));
  }

  /// User-initiated sync. A failure keeps the previous rates on screen.
  Future<void> refresh() async {
    emit(ExchangeRateLoading());
    final result = await _repository.refresh();
    await result.fold(
      (rates) async => emit(ExchangeRateLoaded(rates)),
      (failure) async => emit(ExchangeRateFailure(
        failure.message,
        await _repository.currentRates(),
      )),
    );
  }
}
