import 'dart:async';
import 'package:expense_tracker/features/home/data/datasources/finance_local_data_source.dart';
import 'package:expense_tracker/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:expense_tracker/features/settings/domain/entities/settings_category.dart';
import 'package:expense_tracker/core/domain/entities/currency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'transaction_list_state.dart';

class TransactionListCubit extends Cubit<TransactionListState> {
  TransactionListCubit(this._financeDataSource, this._settingsDataSource)
      : super(TransactionListState(
          transactions: const [],
          categories: const [],
          dateFilter: DateFilterType.last30Days,
          selectedCategoryIds: const {},
          isLoading: true,
          currencySymbol: '\$',
        )) {
    _init();
  }

  final FinanceLocalDataSource _financeDataSource;
  final SettingsLocalDataSource _settingsDataSource;

  static const int _pageSize = 20;

  Future<void> _init() async {
    final settings = await _settingsDataSource.loadSettings();
    final symbol = Currency.fromCode(settings.baseCurrencyCode).symbol;
    
    emit(state.copyWith(
      categories: settings.categories,
      currencySymbol: symbol,
    ));
    
    await fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    emit(state.copyWith(
      isLoading: true, 
      clearErrorMessage: true,
      page: 1,
      hasMore: true,
    ));
    
    try {
      final (start, end) = _getDateRange();
      final categoryIdsToQuery = _getExpandedCategoryIds();

      final transactions = await _financeDataSource.getTransactions(
        startDate: start,
        endDate: end,
        categoryIds: categoryIdsToQuery,
        limit: _pageSize,
        offset: 0,
      );

      emit(state.copyWith(
        transactions: transactions,
        isLoading: false,
        hasMore: transactions.length == _pageSize,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(isLoadingMore: true));

    try {
      final (start, end) = _getDateRange();
      final categoryIdsToQuery = _getExpandedCategoryIds();
      final nextPage = state.page + 1;

      final moreTransactions = await _financeDataSource.getTransactions(
        startDate: start,
        endDate: end,
        categoryIds: categoryIdsToQuery,
        limit: _pageSize,
        offset: state.transactions.length,
      );

      emit(state.copyWith(
        transactions: [...state.transactions, ...moreTransactions],
        isLoadingMore: false,
        page: nextPage,
        hasMore: moreTransactions.length == _pageSize,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingMore: false,
        errorMessage: e.toString(),
      ));
    }
  }

  List<int>? _getExpandedCategoryIds() {
    if (state.selectedCategoryIds.isEmpty) return null;
    
    final expanded = <int>{};
    for (final id in state.selectedCategoryIds) {
      expanded.add(id);
      final parent = _findCategory(state.categories, id);
      if (parent != null) {
        for (final child in parent.children) {
          expanded.add(child.id);
        }
      }
    }
    return expanded.toList();
  }

  SettingsCategory? _findCategory(List<SettingsCategory> categories, int id) {
    for (final cat in categories) {
      if (cat.id == id) return cat;
      final found = _findCategory(cat.children, id);
      if (found != null) return found;
    }
    return null;
  }

  (DateTime?, DateTime?) _getDateRange() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return switch (state.dateFilter) {
      DateFilterType.today => (today, now),
      DateFilterType.last7Days => (today.subtract(const Duration(days: 7)), now),
      DateFilterType.last30Days => (today.subtract(const Duration(days: 30)), now),
      DateFilterType.custom => (state.customStartDate, state.customEndDate),
    };
  }

  void setDateFilter(DateFilterType filter, {DateTime? start, DateTime? end}) {
    emit(state.copyWith(
      dateFilter: filter,
      customStartDate: start,
      customEndDate: end,
    ));
    fetchTransactions();
  }

  void toggleCategory(int id) {
    final newSelected = Set<int>.from(state.selectedCategoryIds);
    if (newSelected.contains(id)) {
      newSelected.remove(id);
      final parent = _findParentOf(state.categories, id);
      if (parent != null) {
        final allChildrenIds = parent.children.map((c) => c.id).toSet();
        final selectedChildrenCount = allChildrenIds.where((childId) => newSelected.contains(childId)).length;
        if (selectedChildrenCount == 0) {
          newSelected.remove(parent.id);
        }
      }
    } else {
      newSelected.add(id);
      final parent = _findParentOf(state.categories, id);
      if (parent != null) {
        final allChildrenIds = parent.children.map((c) => c.id).toSet();
        final selectedChildrenCount = allChildrenIds.where((childId) => newSelected.contains(childId)).length;
        if (selectedChildrenCount == allChildrenIds.length) {
          newSelected.add(parent.id);
        }
      }
    }
    emit(state.copyWith(selectedCategoryIds: newSelected));
    fetchTransactions();
  }

  SettingsCategory? _findParentOf(List<SettingsCategory> categories, int childId) {
    for (final cat in categories) {
      if (cat.children.any((c) => c.id == childId)) return cat;
      final found = _findParentOf(cat.children, childId);
      if (found != null) return found;
    }
    return null;
  }

  void toggleParentGroup(SettingsCategory category) {
    final newSelected = Set<int>.from(state.selectedCategoryIds);
    final allIds = [category.id, ...category.children.map((c) => c.id)];
    final selectedCount = allIds.where((id) => newSelected.contains(id)).length;

    if (selectedCount == allIds.length) {
      for (final id in allIds) {
        newSelected.remove(id);
      }
    } else {
      for (final id in allIds) {
        newSelected.add(id);
      }
    }

    emit(state.copyWith(selectedCategoryIds: newSelected));
    fetchTransactions();
  }

  void clearCategories() {
    emit(state.copyWith(selectedCategoryIds: const {}));
    fetchTransactions();
  }
}
