import 'package:expense_tracker/core/domain/entities/currency.dart';
import 'package:expense_tracker/core/exchange/data/datasources/exchange_rate_local_data_source.dart';
import 'package:expense_tracker/core/exchange/data/datasources/exchange_rate_remote_data_source.dart';
import 'package:expense_tracker/core/exchange/data/models/exchange_rate_response.dart';
import 'package:expense_tracker/core/exchange/data/repositories/exchange_rate_repository_impl.dart';
import 'package:expense_tracker/core/exchange/domain/entities/exchange_rates.dart';
import 'package:flutter_test/flutter_test.dart';

/// The exact payload api.frankfurter.dev/v1/latest?base=INR returns, so the
/// inversion is checked against the real contract rather than a guess.
const _liveRates = <String, num>{
  'AUD': 0.01458,
  'CAD': 0.01436,
  'CHF': 0.00835,
  'CNY': 0.07023,
  'EUR': 0.00893,
  'GBP': 0.00765,
  'HKD': 0.08193,
  'JPY': 1.6583,
  'NZD': 0.01745,
  'SGD': 0.01325,
  'USD': 0.01045,
  'ZAR': 0.16723,
};

class _FakeRemote implements ExchangeRateRemoteDataSource {
  _FakeRemote({this.rates = _liveRates, this.throwOnCall = false});

  final Map<String, num> rates;
  final bool throwOnCall;
  int callCount = 0;
  String? lastBase;
  String? lastSymbols;

  @override
  Future<ExchangeRateResponse> getLatestRates({
    required String base,
    required String symbols,
  }) async {
    callCount++;
    lastBase = base;
    lastSymbols = symbols;
    if (throwOnCall) throw Exception('offline');
    return ExchangeRateResponse(
      base: base,
      date: '2026-08-21',
      rates: rates,
    );
  }
}

class _FakeLocal implements ExchangeRateLocalDataSource {
  _FakeLocal([this._cached]);

  ExchangeRates? _cached;
  int writeCount = 0;

  @override
  Future<ExchangeRates?> readCachedRates() async => _cached;

  @override
  Future<void> writeCachedRates(ExchangeRates rates) async {
    writeCount++;
    _cached = rates;
  }
}

ExchangeRateRepositoryImpl _repo(_FakeRemote remote, _FakeLocal local) {
  return ExchangeRateRepositoryImpl(
    remoteDataSource: remote,
    localDataSource: local,
  );
}

void main() {
  group('refresh', () {
    test('inverts the API rate into "INR per unit"', () async {
      final repo = _repo(_FakeRemote(), _FakeLocal());

      final rates = (await repo.refresh()).dataOrNull!;

      // 1 INR buys 0.01045 USD, so one USD is worth 1/0.01045 INR.
      expect(rates.rateToInr(Currency.usd), closeTo(1 / 0.01045, 1e-9));
      expect(rates.rateToInr(Currency.eur), closeTo(1 / 0.00893, 1e-9));
      // JPY is worth less than a rupee, so its rate must stay below 1.
      expect(rates.rateToInr(Currency.jpy), closeTo(1 / 1.6583, 1e-9));
      expect(rates.rateToInr(Currency.jpy), lessThan(1));
    });

    test('pins the base currency at exactly 1', () async {
      final repo = _repo(_FakeRemote(), _FakeLocal());

      final rates = (await repo.refresh()).dataOrNull!;

      expect(rates.rateToInr(Currency.inr), 1.0);
    });

    test('requests every currency except the base', () async {
      final remote = _FakeRemote();
      await _repo(remote, _FakeLocal()).refresh();

      expect(remote.lastBase, 'INR');
      final requested = remote.lastSymbols!.split(',');
      expect(requested, hasLength(Currency.values.length - 1));
      expect(requested, isNot(contains('INR')));
      expect(requested, contains('USD'));
    });

    test('marks the result as live and writes it to the cache', () async {
      final local = _FakeLocal();
      final rates = (await _repo(_FakeRemote(), local).refresh()).dataOrNull!;

      expect(rates.isFallback, isFalse);
      expect(rates.fetchedAt, isNotNull);
      expect(local.writeCount, 1);
    });

    test('falls back per-currency when the provider omits one', () async {
      final repo = _repo(
        _FakeRemote(rates: const {'USD': 0.01045}),
        _FakeLocal(),
      );

      final rates = (await repo.refresh()).dataOrNull!;

      expect(rates.rateToInr(Currency.usd), closeTo(1 / 0.01045, 1e-9));
      expect(rates.rateToInr(Currency.gbp), Currency.gbp.fallbackRateToInr);
    });

    test('ignores a non-positive rate instead of dividing by zero', () async {
      final repo = _repo(
        _FakeRemote(rates: const {'USD': 0, 'EUR': -1}),
        _FakeLocal(),
      );

      final rates = (await repo.refresh()).dataOrNull!;

      expect(rates.rateToInr(Currency.usd), Currency.usd.fallbackRateToInr);
      expect(rates.rateToInr(Currency.eur), Currency.eur.fallbackRateToInr);
    });

    test('reports a network failure without writing the cache', () async {
      final local = _FakeLocal();
      final result =
          await _repo(_FakeRemote(throwOnCall: true), local).refresh();

      expect(result.isFailure, isTrue);
      expect(local.writeCount, 0);
    });
  });

  group('currentRates', () {
    test('serves a fresh cache without hitting the network', () async {
      final remote = _FakeRemote();
      final cached = ExchangeRates(
        ratesToInr: {Currency.inr: 1.0, Currency.usd: 90.0},
        fetchedAt: DateTime.now(),
        isFallback: false,
      );

      final rates = await _repo(remote, _FakeLocal(cached)).currentRates();

      expect(remote.callCount, 0);
      expect(rates.rateToInr(Currency.usd), 90.0);
    });

    test('refreshes when the cache is past its ttl', () async {
      final remote = _FakeRemote();
      final stale = ExchangeRates(
        ratesToInr: {Currency.inr: 1.0, Currency.usd: 90.0},
        fetchedAt: DateTime.now().subtract(const Duration(hours: 13)),
        isFallback: false,
      );

      final rates = await _repo(remote, _FakeLocal(stale)).currentRates();

      expect(remote.callCount, 1);
      expect(rates.rateToInr(Currency.usd), closeTo(1 / 0.01045, 1e-9));
    });

    test('keeps serving stale rates when the refresh fails', () async {
      final stale = ExchangeRates(
        ratesToInr: {Currency.inr: 1.0, Currency.usd: 90.0},
        fetchedAt: DateTime.now().subtract(const Duration(days: 5)),
        isFallback: false,
      );

      final rates = await _repo(
        _FakeRemote(throwOnCall: true),
        _FakeLocal(stale),
      ).currentRates();

      // Stale beats nothing: a 5-day-old rate is far better than the
      // hardcoded approximation.
      expect(rates.rateToInr(Currency.usd), 90.0);
    });

    test('falls back to approximations with no cache and no network', () async {
      final rates = await _repo(
        _FakeRemote(throwOnCall: true),
        _FakeLocal(),
      ).currentRates();

      expect(rates.isFallback, isTrue);
      expect(rates.rateToInr(Currency.usd), Currency.usd.fallbackRateToInr);
    });

    test('reuses the in-memory value across calls', () async {
      final remote = _FakeRemote();
      final repo = _repo(remote, _FakeLocal());

      await repo.currentRates();
      await repo.currentRates();
      await repo.currentRates();

      expect(remote.callCount, 1);
    });
  });

  group('refreshIfStale', () {
    test('does nothing when the cache is fresh', () async {
      final remote = _FakeRemote();
      final fresh = ExchangeRates(
        ratesToInr: {Currency.inr: 1.0},
        fetchedAt: DateTime.now(),
        isFallback: false,
      );

      await _repo(remote, _FakeLocal(fresh)).refreshIfStale();

      expect(remote.callCount, 0);
    });

    test('fetches on a cold start with no cache', () async {
      final remote = _FakeRemote();

      await _repo(remote, _FakeLocal()).refreshIfStale();

      expect(remote.callCount, 1);
    });

    test('swallows a failure so app startup is never blocked', () async {
      final remote = _FakeRemote(throwOnCall: true);

      await expectLater(
        _repo(remote, _FakeLocal()).refreshIfStale(),
        completes,
      );
    });
  });

  group('response parsing', () {
    test('accepts the live payload shape', () {
      final parsed = ExchangeRateResponse.fromJson(const {
        'amount': 1.0,
        'base': 'INR',
        'date': '2026-08-21',
        'rates': {'USD': 0.01045, 'JPY': 1.6583},
      });

      expect(parsed.base, 'INR');
      expect(parsed.rates['USD'], 0.01045);
    });

    test('accepts an integer-valued rate', () {
      // JSON has no int/double distinction, so a rate of exactly 1 arrives as
      // an int and must not fail the num cast.
      final parsed = ExchangeRateResponse.fromJson(const {
        'base': 'INR',
        'date': '2026-08-21',
        'rates': {'USD': 1},
      });

      expect(parsed.rates['USD'], 1);
    });
  });
}
