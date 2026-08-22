import 'dart:io';

import 'package:dio/dio.dart';
import 'package:expense_tracker/core/domain/entities/currency.dart';
import 'package:expense_tracker/core/exchange/data/datasources/exchange_rate_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';

/// Hits the real rates API through the real Retrofit client.
///
/// Skipped unless RUN_NETWORK_TESTS=1, so the default suite stays hermetic and
/// passes offline. Run it deliberately after touching the endpoint, the
/// response model, or the Dio setup:
///
///     RUN_NETWORK_TESTS=1 fvm flutter test test/network
void main() {
  final skipReason = Platform.environment['RUN_NETWORK_TESTS'] == '1'
      ? null
      : 'needs a network; run with RUN_NETWORK_TESTS=1';

  late ExchangeRateRemoteDataSource dataSource;

  setUp(() {
    // Same Dio configuration the service locator builds for this API.
    dataSource = ExchangeRateRemoteDataSource(
      Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      )),
    );
  });

  test('fetches and parses live rates for every supported currency', skip: skipReason, () async {
    final symbols = Currency.values
        .where((c) => c != Currency.inr)
        .map((c) => c.code)
        .join(',');

    final response = await dataSource.getLatestRates(
      base: Currency.inr.code,
      symbols: symbols,
    );

    expect(response.base, 'INR');
    expect(response.date, isNotEmpty);

    // Every currency the app offers must come back, or that currency would
    // silently keep using its hardcoded approximation forever.
    for (final currency in Currency.values) {
      if (currency == Currency.inr) continue;
      expect(
        response.rates[currency.code],
        isNotNull,
        reason: '${currency.code} is not supported by the provider',
      );
      expect(
        response.rates[currency.code]!,
        greaterThan(0),
        reason: '${currency.code} returned a non-positive rate',
      );
    }
  });

  test('inverted rates land in a sane range', skip: skipReason, () async {
    final response = await dataSource.getLatestRates(
      base: Currency.inr.code,
      symbols: 'USD,JPY',
    );

    // 1 INR buys a fraction of a dollar, so a dollar must be worth many
    // rupees. A wide band catches an inversion mistake without failing on
    // ordinary market movement.
    final usdToInr = 1 / response.rates['USD']!;
    expect(usdToInr, inInclusiveRange(50, 200));

    // A yen is worth around a rupee, so it must not land in dollar territory.
    final jpyToInr = 1 / response.rates['JPY']!;
    expect(jpyToInr, inInclusiveRange(0.1, 5));
  });
}
