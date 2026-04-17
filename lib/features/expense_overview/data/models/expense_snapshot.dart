class ExpenseSnapshot {
  const ExpenseSnapshot({
    required this.titleKey,
    required this.descriptionKey,
    required this.spentLabel,
    required this.remainingLabel,
  });

  final String titleKey;
  final String descriptionKey;
  final String spentLabel;
  final String remainingLabel;
}
