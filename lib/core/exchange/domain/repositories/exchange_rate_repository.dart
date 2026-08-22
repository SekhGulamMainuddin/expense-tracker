import 'package:expense_tracker/core/error/result.dart';
import 'package:expense_tracker/core/exchange/domain/entities/exchange_rates.dart';

abstract interface class ExchangeRateRepository {
  /// The rates to use right now. Serves the in-memory value when it is still
  /// fresh, otherwise the cache, otherwise the network. Never fails: the
  /// hardcoded fallback is returned as a last resort so conversion always
  /// produces a number.
  Future<ExchangeRates> currentRates();

  /// Forces a network fetch. Surfaces failures so the UI can report them.
  ResultFuture<ExchangeRates> refresh();

  /// Refreshes only when the cached rates are older than the TTL. Safe to
  /// fire-and-forget on app start.
  Future<void> refreshIfStale();
}
