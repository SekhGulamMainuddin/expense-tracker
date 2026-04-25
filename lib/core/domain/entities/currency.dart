enum Currency {
  usd(symbol: '\$'),
  inr(symbol: '₹'),
  eur(symbol: '€');

  final String symbol;
  const Currency({required this.symbol});

  static Currency fromCode(String code) {
    return Currency.values.firstWhere(
      (c) => c.name.toLowerCase() == code.toLowerCase(),
      orElse: () => Currency.usd,
    );
  }
}
