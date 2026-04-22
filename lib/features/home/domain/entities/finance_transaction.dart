class FinanceTransaction {
  FinanceTransaction({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.icon,
    required this.color,
    required this.date,
  });

  final int id;
  final String title;
  final String subtitle;
  final double amount;
  final String icon;
  final int color;
  final DateTime date;
}
