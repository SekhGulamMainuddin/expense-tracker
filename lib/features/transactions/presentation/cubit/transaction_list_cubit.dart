import 'dart:async';

import 'package:expense_tracker/core/domain/entities/currency.dart';
import 'package:expense_tracker/features/settings/domain/entities/settings_category.dart';
import 'package:expense_tracker/features/transactions/domain/entities/transaction_filter.dart';
import 'package:expense_tracker/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'transaction_list_state.dart';

class TransactionListCubit extends Cubit<TransactionListState> {
  TransactionListCubit(this._repository)
      : super(TransactionListState.initial()) {
    unawaited(_init());
  }

  final TransactionRepository _repository;

  static const int _pageSize = 20;
  static const _searchDebounce = Duration(milliseconds: 300);

  Timer? _searchDebounceTimer;

  Future<void> _init() async {
    final result = await _repository.loadFilterOptions();
    result.fold(
      (settings) => emit(state.copyWith(
        categories: settings.categories,
        currencySymbol: Currency.fromCode(settings.baseCurrencyCode).symbol,
      )),
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
    );
    await fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    emit(state.copyWith(
      isLoading: true,
      clearErrorMessage: true,
      hasMore: true,
    ));

    final result = await _repository.getTransactions(
      filter: state.filter,
      limit: _pageSize,
      offset: 0,
    );

    result.fold(
      (transactions) => emit(state.copyWith(
        transactions: transactions,
        isLoading: false,
        hasMore: transactions.length == _pageSize,
      )),
      (failure) => emit(state.copyWith(
        isLoading: false,
        transactions: const [],
        hasMore: false,
        errorMessage: failure.message,
      )),
    );
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(isLoadingMore: true));

    final result = await _repository.getTransactions(
      filter: state.filter,
      limit: _pageSize,
      offset: state.transactions.length,
    );

    result.fold(
      (more) => emit(state.copyWith(
        transactions: [...state.transactions, ...more],
        isLoadingMore: false,
        hasMore: more.length == _pageSize,
      )),
      (failure) => emit(state.copyWith(
        isLoadingMore: false,
        hasMore: false,
        errorMessage: failure.message,
      )),
    );
  }

  /// Removes the row, then drops it from the visible page optimistically so
  /// the list does not jump back to the top for a single deletion.
  Future<bool> deleteTransaction(int id) async {
    final result = await _repository.deleteTransaction(id);
    return result.fold(
      (_) {
        emit(state.copyWith(
          transactions:
              state.transactions.where((tx) => tx.id != id).toList(),
          clearErrorMessage: true,
        ));
        return true;
      },
      (failure) {
        emit(state.copyWith(errorMessage: failure.message));
        return false;
      },
    );
  }

  void search(String query) {
    _searchDebounceTimer?.cancel();
    emit(state.copyWith(filter: state.filter.copyWith(searchQuery: query)));
    _searchDebounceTimer = Timer(_searchDebounce, fetchTransactions);
  }

  void setDateFilter(DateFilterType type, {DateTime? start, DateTime? end}) {
    emit(state.copyWith(
      filter: TransactionFilter(
        dateFilter: type,
        // A non-custom range must forget any previously picked dates.
        customStartDate: type == DateFilterType.custom ? start : null,
        customEndDate: type == DateFilterType.custom ? end : null,
        categoryIds: state.filter.categoryIds,
        searchQuery: state.filter.searchQuery,
      ),
    ));
    unawaited(fetchTransactions());
  }

  /// Toggles a single node. A parent is marked selected only while every one
  /// of its children is selected, so the tri-state checkbox stays honest.
  void toggleCategory(int id) {
    final selected = Set<int>.from(state.filter.categoryIds);
    final parent = _findParentOf(state.categories, id);

    if (selected.contains(id)) {
      selected.remove(id);
      if (parent != null) selected.remove(parent.id);
    } else {
      selected.add(id);
      if (parent != null) {
        final childIds = parent.children.map((c) => c.id).toSet();
        if (childIds.every(selected.contains)) selected.add(parent.id);
      }
    }

    _applyCategorySelection(selected);
  }

  void toggleParentGroup(SettingsCategory category) {
    final selected = Set<int>.from(state.filter.categoryIds);
    final allIds = [category.id, ...category.children.map((c) => c.id)];

    if (allIds.every(selected.contains)) {
      selected.removeAll(allIds);
    } else {
      selected.addAll(allIds);
    }

    _applyCategorySelection(selected);
  }

  void clearCategories() => _applyCategorySelection(const {});

  void resetFilters() {
    emit(state.copyWith(
      filter: TransactionFilter(searchQuery: state.filter.searchQuery),
    ));
    unawaited(fetchTransactions());
  }

  void _applyCategorySelection(Set<int> selected) {
    emit(state.copyWith(
      filter: state.filter.copyWith(categoryIds: selected),
    ));
    unawaited(fetchTransactions());
  }

  SettingsCategory? _findParentOf(
    List<SettingsCategory> categories,
    int childId,
  ) {
    for (final cat in categories) {
      if (cat.children.any((c) => c.id == childId)) return cat;
      final found = _findParentOf(cat.children, childId);
      if (found != null) return found;
    }
    return null;
  }

  @override
  Future<void> close() {
    _searchDebounceTimer?.cancel();
    return super.close();
  }
}
