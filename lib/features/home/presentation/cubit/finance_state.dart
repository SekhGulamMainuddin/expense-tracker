class FinanceState {
  final double balance;
  final double income;
  final double expenses;
  final List<Map<String, dynamic>> transactions;

  FinanceState({
    required this.balance,
    required this.income,
    required this.expenses,
    required this.transactions,
  });
}
