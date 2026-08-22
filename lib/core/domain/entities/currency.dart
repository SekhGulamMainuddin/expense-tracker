/// Supported currencies.
///
/// [fallbackRateToInr] is a hardcoded approximation used only before the first
/// successful rate sync, or when the device has been offline long enough that
/// no cached rates exist. Live rates come from [ExchangeRates]; never do
/// arithmetic against the fallback when a rates table is available.
enum Currency {
  inr(symbol: '₹', displayName: 'Indian Rupee', fallbackRateToInr: 1.0),
  usd(symbol: '\$', displayName: 'US Dollar', fallbackRateToInr: 86.0),
  eur(symbol: '€', displayName: 'Euro', fallbackRateToInr: 93.0),
  gbp(symbol: '£', displayName: 'British Pound', fallbackRateToInr: 110.0),
  jpy(symbol: '¥', displayName: 'Japanese Yen', fallbackRateToInr: 0.57),
  aud(symbol: 'A\$', displayName: 'Australian Dollar', fallbackRateToInr: 55.0),
  cad(symbol: 'C\$', displayName: 'Canadian Dollar', fallbackRateToInr: 61.0),
  chf(symbol: 'CHF', displayName: 'Swiss Franc', fallbackRateToInr: 98.0),
  sgd(symbol: 'S\$', displayName: 'Singapore Dollar', fallbackRateToInr: 64.0),
  cny(symbol: 'CN¥', displayName: 'Chinese Yuan', fallbackRateToInr: 12.0),
  nzd(symbol: 'NZ\$', displayName: 'New Zealand Dollar', fallbackRateToInr: 50.0),
  hkd(symbol: 'HK\$', displayName: 'Hong Kong Dollar', fallbackRateToInr: 11.0),
  zar(symbol: 'R', displayName: 'South African Rand', fallbackRateToInr: 4.7);

  const Currency({
    required this.symbol,
    required this.displayName,
    required this.fallbackRateToInr,
  });

  final String symbol;
  final String displayName;
  final double fallbackRateToInr;

  /// Upper-case ISO 4217 code, e.g. `USD`.
  String get code => name.toUpperCase();

  static Currency fromCode(String code) {
    return Currency.values.firstWhere(
      (c) => c.name.toLowerCase() == code.toLowerCase(),
      orElse: () => Currency.inr,
    );
  }

  static Currency? tryFromCode(String code) {
    for (final c in Currency.values) {
      if (c.name.toLowerCase() == code.toLowerCase()) return c;
    }
    return null;
  }
}
