import 'finance_category_breakdown.dart';
import 'finance_transaction.dart';
import 'time_range.dart';

class FinanceSnapshot {
  FinanceSnapshot({
    required this.currencyCode,
    required this.currencySymbol,
    required this.dailySpent,
    required this.weeklySpent,
    required this.monthlySpent,
    required this.dailyLimit,
    required this.weeklyLimit,
    required this.monthlyLimit,
    required this.monthlyComparison,
    required this.recentTransactions,
    required this.categoryBreakdown,
    this.timeRange = TimeRange.monthly,
  });

  final String currencyCode;
  final String currencySymbol;
  final double dailySpent;
  final double weeklySpent;
  final double monthlySpent;
  final double dailyLimit;
  final double weeklyLimit;
  final double monthlyLimit;
  final double monthlyComparison;
  final List<FinanceTransaction> recentTransactions;
  final List<FinanceCategoryBreakdown> categoryBreakdown;
  final TimeRange timeRange;

  double get monthlyBudgetRemaining => monthlyLimit - monthlySpent;

  double get budgetUtilization {
    if (monthlyLimit <= 0) {
      return 0;
    }
    return (monthlySpent / monthlyLimit).clamp(0.0, 1.0);
  }
}
