import 'package:expense_tracker/core/exchange/domain/entities/exchange_rates.dart';

sealed class ExchangeRateState {}

final class ExchangeRateInitial extends ExchangeRateState {}

final class ExchangeRateLoading extends ExchangeRateState {}

final class ExchangeRateLoaded extends ExchangeRateState {
  ExchangeRateLoaded(this.rates);

  final ExchangeRates rates;
}

final class ExchangeRateFailure extends ExchangeRateState {
  ExchangeRateFailure(this.errorMessage, this.rates);

  final String errorMessage;

  /// The rates still in effect after a failed refresh, so the row keeps
  /// showing something useful instead of blanking out.
  final ExchangeRates rates;
}
