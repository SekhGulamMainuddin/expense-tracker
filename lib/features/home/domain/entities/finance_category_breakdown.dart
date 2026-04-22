class FinanceCategoryBreakdown {
  FinanceCategoryBreakdown({
    required this.categoryId,
    required this.title,
    required this.icon,
    required this.color,
    required this.amount,
    required this.percentage,
  });

  final int categoryId;
  final String title;
  final String icon;
  final int color;
  final double amount;
  final double percentage;
}
