import 'package:expense_tracker/core/domain/entities/currency.dart';

/// An immutable snapshot of currency rates, all expressed as
/// "how many INR is one unit of this currency worth".
///
/// INR is the storage base: every expense row persists `baseAmount` in INR so
/// aggregation never depends on which currency the user happened to be using.
class ExchangeRates {
  const ExchangeRates({
    required this.ratesToInr,
    required this.fetchedAt,
    required this.isFallback,
  });

  /// Rates derived entirely from [Currency.fallbackRateToInr]. Used before the
  /// first successful sync.
  ExchangeRates.fallback()
      : ratesToInr = {
          for (final c in Currency.values) c: c.fallbackRateToInr,
        },
        fetchedAt = null,
        isFallback = true;

  final Map<Currency, double> ratesToInr;

  /// When these rates were retrieved from the network. Null for [fallback].
  final DateTime? fetchedAt;

  /// True while no live rate has ever been fetched, so the UI can say the
  /// numbers are approximate.
  final bool isFallback;

  double rateToInr(Currency currency) {
    final rate = ratesToInr[currency];
    // A non-positive rate would silently zero out or invert every amount.
    if (rate == null || rate <= 0) return currency.fallbackRateToInr;
    return rate;
  }

  /// Converts [amount] denominated in [from] into [to].
  double convert(double amount, {required Currency from, required Currency to}) {
    if (from == to) return amount;
    return (amount * rateToInr(from)) / rateToInr(to);
  }

  /// Normalizes an amount into the INR storage base.
  double toBase(double amount, Currency from) =>
      convert(amount, from: from, to: Currency.inr);

  /// Reads a stored INR amount back out in [to].
  double fromBase(double baseAmount, Currency to) =>
      convert(baseAmount, from: Currency.inr, to: to);

  bool isStale(Duration ttl, DateTime now) {
    final fetched = fetchedAt;
    if (fetched == null) return true;
    return now.difference(fetched) >= ttl;
  }

  Map<String, dynamic> toJson() => {
        'fetchedAt': fetchedAt?.toIso8601String(),
        'ratesToInr': {
          for (final entry in ratesToInr.entries) entry.key.name: entry.value,
        },
      };

  /// Rebuilds from cache. Unknown codes are ignored and missing currencies
  /// fall back, so adding a currency to the enum never breaks an old cache.
  static ExchangeRates? fromJson(Map<String, dynamic> json) {
    final rawRates = json['ratesToInr'];
    if (rawRates is! Map) return null;

    final rates = <Currency, double>{
      for (final c in Currency.values) c: c.fallbackRateToInr,
    };
    for (final entry in rawRates.entries) {
      final currency = Currency.tryFromCode(entry.key.toString());
      final value = entry.value;
      if (currency == null || value is! num || value <= 0) continue;
      rates[currency] = value.toDouble();
    }

    final rawFetchedAt = json['fetchedAt'];
    final fetchedAt =
        rawFetchedAt is String ? DateTime.tryParse(rawFetchedAt) : null;

    return ExchangeRates(
      ratesToInr: rates,
      fetchedAt: fetchedAt,
      isFallback: fetchedAt == null,
    );
  }
}
