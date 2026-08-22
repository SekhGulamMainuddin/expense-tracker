import 'package:expense_tracker/core/domain/entities/currency.dart';
import 'package:expense_tracker/core/error/result.dart';
import 'package:expense_tracker/core/exchange/data/datasources/exchange_rate_local_data_source.dart';
import 'package:expense_tracker/core/exchange/data/datasources/exchange_rate_remote_data_source.dart';
import 'package:expense_tracker/core/exchange/domain/entities/exchange_rates.dart';
import 'package:expense_tracker/core/exchange/domain/repositories/exchange_rate_repository.dart';

final class ExchangeRateRepositoryImpl implements ExchangeRateRepository {
  ExchangeRateRepositoryImpl({
    required ExchangeRateRemoteDataSource remoteDataSource,
    required ExchangeRateLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final ExchangeRateRemoteDataSource _remoteDataSource;
  final ExchangeRateLocalDataSource _localDataSource;

  /// The source publishes once per working day, so a 12h TTL is plenty and
  /// keeps the app usable on a flaky connection.
  static const cacheTtl = Duration(hours: 12);

  ExchangeRates? _inMemory;

  @override
  Future<ExchangeRates> currentRates() async {
    final cached = _inMemory ??= await _localDataSource.readCachedRates();
    if (cached != null && !cached.isStale(cacheTtl, DateTime.now())) {
      return cached;
    }

    final refreshed = await refresh();
    return refreshed.fold(
      (rates) => rates,
      // Stale rates beat no rates; the fallback is the floor.
      (_) => cached ?? ExchangeRates.fallback(),
    );
  }

  @override
  ResultFuture<ExchangeRates> refresh() async {
    try {
      final response = await _remoteDataSource.getLatestRates(
        base: Currency.inr.code,
        symbols: Currency.values
            .where((c) => c != Currency.inr)
            .map((c) => c.code)
            .join(','),
      );

      final rates = _toRatesToInr(response.rates);
      _inMemory = rates;
      await _localDataSource.writeCachedRates(rates);
      return Success(rates);
    } catch (e) {
      return Error(ServerFailure('Could not update exchange rates: $e'));
    }
  }

  @override
  Future<void> refreshIfStale() async {
    final cached = _inMemory ??= await _localDataSource.readCachedRates();
    if (cached != null && !cached.isStale(cacheTtl, DateTime.now())) return;
    await refresh();
  }

  /// The API returns "units of X per 1 INR"; we store the inverse because
  /// every amount is normalized *into* INR.
  ExchangeRates _toRatesToInr(Map<String, num> perInr) {
    final rates = <Currency, double>{Currency.inr: 1.0};

    for (final entry in perInr.entries) {
      final currency = Currency.tryFromCode(entry.key);
      final value = entry.value.toDouble();
      if (currency == null || value <= 0) continue;
      rates[currency] = 1 / value;
    }

    // Anything the provider omitted keeps its approximation rather than
    // silently converting at zero.
    for (final currency in Currency.values) {
      rates.putIfAbsent(currency, () => currency.fallbackRateToInr);
    }

    return ExchangeRates(
      ratesToInr: rates,
      fetchedAt: DateTime.now(),
      isFallback: false,
    );
  }
}
