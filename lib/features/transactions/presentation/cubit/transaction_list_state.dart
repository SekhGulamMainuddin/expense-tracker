import 'package:expense_tracker/features/home/domain/entities/finance_transaction.dart';
import 'package:expense_tracker/features/settings/domain/entities/settings_category.dart';

enum DateFilterType { today, last7Days, last30Days, custom }

final class TransactionListState {
  const TransactionListState({
    required this.transactions,
    required this.categories,
    required this.dateFilter,
    this.customStartDate,
    this.customEndDate,
    required this.selectedCategoryIds,
    this.isLoading = false,
    this.errorMessage,
    required this.currencySymbol,
  });

  final List<FinanceTransaction> transactions;
  final List<SettingsCategory> categories;
  final DateFilterType dateFilter;
  final DateTime? customStartDate;
  final DateTime? customEndDate;
  final Set<int> selectedCategoryIds; // Empty Set means "All"
  final bool isLoading;
  final String? errorMessage;
  final String currencySymbol;

  TransactionListState copyWith({
    List<FinanceTransaction>? transactions,
    List<SettingsCategory>? categories,
    DateFilterType? dateFilter,
    DateTime? customStartDate,
    DateTime? customEndDate,
    Set<int>? selectedCategoryIds,
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? currencySymbol,
  }) {
    return TransactionListState(
      transactions: transactions ?? this.transactions,
      categories: categories ?? this.categories,
      dateFilter: dateFilter ?? this.dateFilter,
      customStartDate: customStartDate ?? this.customStartDate,
      customEndDate: customEndDate ?? this.customEndDate,
      selectedCategoryIds: selectedCategoryIds ?? this.selectedCategoryIds,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      currencySymbol: currencySymbol ?? this.currencySymbol,
    );
  }
}
