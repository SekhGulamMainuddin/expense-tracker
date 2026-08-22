import 'package:expense_tracker/features/home/domain/entities/finance_transaction.dart';
import 'package:expense_tracker/features/settings/domain/entities/settings_category.dart';
import 'package:expense_tracker/features/transactions/domain/entities/transaction_filter.dart';

export 'package:expense_tracker/features/transactions/domain/entities/transaction_filter.dart'
    show DateFilterType;

final class TransactionListState {
  const TransactionListState({
    required this.transactions,
    required this.categories,
    required this.filter,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    required this.currencySymbol,
    this.hasMore = true,
  });

  TransactionListState.initial()
      : transactions = const [],
        categories = const [],
        filter = const TransactionFilter(),
        isLoading = true,
        isLoadingMore = false,
        errorMessage = null,
        currencySymbol = '\$',
        hasMore = true;

  final List<FinanceTransaction> transactions;
  final List<SettingsCategory> categories;
  final TransactionFilter filter;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final String currencySymbol;
  final bool hasMore;

  /// Empty set means "all categories".
  Set<int> get selectedCategoryIds => filter.categoryIds;

  DateFilterType get dateFilter => filter.dateFilter;

  String get searchQuery => filter.searchQuery;

  bool get hasActiveCategoryFilter => filter.categoryIds.isNotEmpty;

  double get total =>
      transactions.fold<double>(0, (sum, tx) => sum + tx.amount);

  TransactionListState copyWith({
    List<FinanceTransaction>? transactions,
    List<SettingsCategory>? categories,
    TransactionFilter? filter,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? currencySymbol,
    bool? hasMore,
  }) {
    return TransactionListState(
      transactions: transactions ?? this.transactions,
      categories: categories ?? this.categories,
      filter: filter ?? this.filter,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      currencySymbol: currencySymbol ?? this.currencySymbol,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
