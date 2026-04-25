enum Currency {
  usd(symbol: '\$', rateToInr: 83.0),
  inr(symbol: '₹', rateToInr: 1.0),
  eur(symbol: '€', rateToInr: 90.0);

  final String symbol;
  final double rateToInr;
  const Currency({required this.symbol, required this.rateToInr});

  double convertTo(double amount, Currency target) {
    if (this == target) return amount;
    // (Amount in This) * (This -> INR) / (Target -> INR) = (Amount in Target)
    return (amount * rateToInr) / target.rateToInr;
  }

  static Currency fromCode(String code) {
    return Currency.values.firstWhere(
      (c) => c.name.toLowerCase() == code.toLowerCase(),
      orElse: () => Currency.usd,
    );
  }
}
