import 'package:expense_tracker/features/home/domain/entities/time_range.dart';
import 'package:expense_tracker/features/home/domain/entities/finance_category_breakdown.dart';

sealed class CategoryChartState {}

final class CategoryChartInitial extends CategoryChartState {}

final class CategoryChartLoading extends CategoryChartState {}

final class CategoryChartLoaded extends CategoryChartState {
  CategoryChartLoaded({
    required this.breakdown,
    required this.range,
    this.isRefreshing = false,
  });

  final List<FinanceCategoryBreakdown> breakdown;
  final TimeRange range;
  final bool isRefreshing;

  CategoryChartLoaded copyWith({
    List<FinanceCategoryBreakdown>? breakdown,
    TimeRange? range,
    bool? isRefreshing,
  }) {
    return CategoryChartLoaded(
      breakdown: breakdown ?? this.breakdown,
      range: range ?? this.range,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

final class CategoryChartFailure extends CategoryChartState {
  CategoryChartFailure(this.message);
  final String message;
}
