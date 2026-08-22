import 'package:expense_tracker/core/domain/entities/currency.dart';
import 'package:expense_tracker/core/exchange/domain/entities/exchange_rates.dart';
import 'package:flutter_test/flutter_test.dart';

ExchangeRates _rates(
  Map<Currency, double> overrides, {
  DateTime? fetchedAt,
}) {
  return ExchangeRates(
    ratesToInr: {Currency.inr: 1.0, ...overrides},
    fetchedAt: fetchedAt ?? DateTime(2026, 8, 22, 10),
    isFallback: false,
  );
}

void main() {
  group('convert', () {
    test('returns the amount untouched when both sides match', () {
      final rates = _rates({Currency.usd: 86.0});

      expect(
        rates.convert(42.5, from: Currency.usd, to: Currency.usd),
        42.5,
      );
    });

    test('normalizes into the INR storage base', () {
      final rates = _rates({Currency.usd: 86.0});

      expect(rates.toBase(10, Currency.usd), 860.0);
    });

    test('reads a stored base amount back out', () {
      final rates = _rates({Currency.usd: 86.0});

      expect(rates.fromBase(860, Currency.usd), 10.0);
    });

    test('round-trips through the base without drift', () {
      final rates = _rates({Currency.eur: 93.0, Currency.jpy: 0.57});

      final base = rates.toBase(1234.56, Currency.eur);
      expect(rates.fromBase(base, Currency.eur), closeTo(1234.56, 1e-9));
    });

    test('converts between two non-base currencies', () {
      final rates = _rates({Currency.usd: 86.0, Currency.eur: 86.0});

      expect(
        rates.convert(100, from: Currency.usd, to: Currency.eur),
        closeTo(100, 1e-9),
      );
    });
  });

  group('rateToInr guards', () {
    test('falls back when a currency is missing from the table', () {
      final rates = _rates({});

      expect(rates.rateToInr(Currency.gbp), Currency.gbp.fallbackRateToInr);
    });

    test('falls back on a zero rate rather than zeroing the amount', () {
      final rates = _rates({Currency.usd: 0});

      expect(rates.rateToInr(Currency.usd), Currency.usd.fallbackRateToInr);
    });

    test('falls back on a negative rate rather than inverting the sign', () {
      final rates = _rates({Currency.usd: -86});

      expect(rates.rateToInr(Currency.usd), Currency.usd.fallbackRateToInr);
    });
  });

  group('fallback', () {
    test('covers every currency and is flagged as approximate', () {
      final rates = ExchangeRates.fallback();

      expect(rates.isFallback, isTrue);
      expect(rates.fetchedAt, isNull);
      for (final currency in Currency.values) {
        expect(rates.ratesToInr[currency], currency.fallbackRateToInr);
      }
    });

    test('is always stale so the first sync is never skipped', () {
      expect(
        ExchangeRates.fallback()
            .isStale(const Duration(hours: 12), DateTime(2026, 8, 22)),
        isTrue,
      );
    });
  });

  group('isStale', () {
    final fetchedAt = DateTime(2026, 8, 22, 10);

    test('is fresh inside the ttl', () {
      final rates = _rates({}, fetchedAt: fetchedAt);

      expect(
        rates.isStale(const Duration(hours: 12), DateTime(2026, 8, 22, 21)),
        isFalse,
      );
    });

    test('is stale exactly at the ttl boundary', () {
      final rates = _rates({}, fetchedAt: fetchedAt);

      expect(
        rates.isStale(const Duration(hours: 12), DateTime(2026, 8, 22, 22)),
        isTrue,
      );
    });
  });

  group('json', () {
    test('round-trips rates and timestamp', () {
      final original = _rates({Currency.usd: 86.5, Currency.eur: 93.25});

      final restored = ExchangeRates.fromJson(original.toJson())!;

      expect(restored.fetchedAt, original.fetchedAt);
      expect(restored.isFallback, isFalse);
      expect(restored.rateToInr(Currency.usd), 86.5);
      expect(restored.rateToInr(Currency.eur), 93.25);
    });

    test('ignores unknown currency codes from an older cache', () {
      final restored = ExchangeRates.fromJson({
        'fetchedAt': '2026-08-22T10:00:00.000',
        'ratesToInr': {'usd': 86.0, 'xyz': 12.0},
      })!;

      expect(restored.rateToInr(Currency.usd), 86.0);
      expect(restored.ratesToInr.containsKey(Currency.usd), isTrue);
    });

    test('fills currencies the cache never stored', () {
      final restored = ExchangeRates.fromJson({
        'fetchedAt': '2026-08-22T10:00:00.000',
        'ratesToInr': {'usd': 86.0},
      })!;

      expect(restored.rateToInr(Currency.chf), Currency.chf.fallbackRateToInr);
    });

    test('rejects a malformed payload', () {
      expect(ExchangeRates.fromJson({'ratesToInr': 'not-a-map'}), isNull);
    });

    test('treats a missing timestamp as never synced', () {
      final restored = ExchangeRates.fromJson({
        'ratesToInr': {'usd': 86.0},
      })!;

      expect(restored.isFallback, isTrue);
      expect(restored.isStale(const Duration(hours: 12), DateTime(2026, 8, 22)),
          isTrue);
    });
  });

  group('Currency', () {
    test('parses codes case-insensitively', () {
      expect(Currency.fromCode('USD'), Currency.usd);
      expect(Currency.fromCode('usd'), Currency.usd);
    });

    test('defaults to the storage base for an unknown code', () {
      expect(Currency.fromCode('zzz'), Currency.inr);
    });

    test('tryFromCode reports an unknown code instead of guessing', () {
      expect(Currency.tryFromCode('zzz'), isNull);
    });

    test('every currency has a usable fallback rate', () {
      for (final currency in Currency.values) {
        expect(currency.fallbackRateToInr, greaterThan(0),
            reason: '${currency.code} would break conversion');
      }
    });
  });
}
