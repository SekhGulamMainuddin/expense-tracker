import 'dart:async';

import 'package:expense_tracker/features/add_expense/domain/repositories/add_expense_repository.dart';
import 'package:expense_tracker/features/settings/domain/entities/settings_category.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_expense_state.dart';

class AddExpenseCubit extends Cubit<AddExpenseState> {
  AddExpenseCubit(this._repository) : super(AddExpenseLoading()) {
    unawaited(loadFormData());
  }

  final AddExpenseRepository _repository;

  Future<void> loadFormData({int? transactionId, AddExpenseMode? mode}) async {
    emit(AddExpenseLoading());
    final settingsResult = await _repository.loadFormData();
    
    settingsResult.fold(
      (settings) async {
        if (settings.categories.isEmpty) {
          emit(AddExpenseFailure('No categories available yet.'));
          return;
        }

        if (transactionId != null) {
          final expenseResult = await _repository.getExpense(transactionId);
          expenseResult.fold(
            (expense) {
              // Map expense category to root and sub
              int? rootId;
              int? subId;
              
              // Search for the category in the hierarchy
              final category = _findCategoryInSettings(settings.categories, expense.categoryId);
              if (category != null) {
                if (category.parentId != null && category.parentId != 0) {
                  rootId = category.parentId;
                  subId = category.id;
                } else {
                  rootId = category.id;
                  subId = null;
                }
              }

              final root = rootId != null ? _findCategoryInSettings(settings.categories, rootId) : null;
              final sub = subId != null ? _findCategoryInSettings(settings.categories, subId) : null;

              emit(
                AddExpenseLoaded(
                  settings: settings,
                  amount: expense.amount.toString(),
                  title: expense.title,
                  date: expense.date,
                  selectedCategoryId: rootId ?? settings.categories.first.id,
                  selectedSubcategoryId: subId,
                  mode: mode ?? AddExpenseMode.view,
                  transactionId: transactionId,
                  generatedTitle: _generateTitle(root, sub),
                ),
              );
            },
            (failure) => emit(AddExpenseFailure(failure.message)),
          );
        } else {
          final firstRoot = settings.categories.first;
          final firstSub = firstRoot.children.isNotEmpty ? firstRoot.children.first : null;
          emit(
            AddExpenseLoaded(
              settings: settings,
              amount: '0',
              title: '',
              date: DateTime.now(),
              selectedCategoryId: firstRoot.id,
              selectedSubcategoryId: firstSub?.id,
              mode: AddExpenseMode.create,
              generatedTitle: _generateTitle(firstRoot, firstSub),
            ),
          );
        }
      },
      (failure) => emit(AddExpenseFailure(failure.message)),
    );
  }

  SettingsCategory? _findCategoryInSettings(List<SettingsCategory> categories, int id) {
    for (final category in categories) {
      if (category.id == id) return category;
      final child = _findCategoryInSettings(category.children, id);
      if (child != null) return child;
    }
    return null;
  }

  void setMode(AddExpenseMode mode) {
    final current = _loadedStateOrNull();
    if (current == null) return;
    emit(current.copyWith(mode: mode));
  }

  static const _maxDecimalPlaces = 2;

  void updateAmount(String value) {
    final current = _loadedStateOrNull();
    if (current == null) return;

    emit(current.copyWith(amount: value, clearErrorMessage: true));
  }

  void updateTitle(String value) {
    final current = _loadedStateOrNull();
    if (current == null) return;

    emit(current.copyWith(title: value, clearErrorMessage: true));
  }

  void selectCategory(int categoryId) {
    final current = _loadedStateOrNull();
    if (current == null) return;

    SettingsCategory? selectedRoot;
    for (final category in current.rootCategories) {
      if (category.id == categoryId) {
        selectedRoot = category;
        break;
      }
    }
    if (selectedRoot == null) {
      return;
    }

    final newSubId = selectedRoot.children.isNotEmpty
            ? selectedRoot.children.first.id
            : null;
            
    emit(
      current.copyWith(
        selectedCategoryId: categoryId,
        selectedSubcategoryId: newSubId,
        clearSelectedSubcategoryId: selectedRoot.children.isEmpty,
        clearErrorMessage: true,
        generatedTitle: _generateTitle(selectedRoot, selectedRoot.children.isNotEmpty ? selectedRoot.children.first : null),
      ),
    );
  }

  void selectSubcategory(int? subcategoryId) {
    final current = _loadedStateOrNull();
    if (current == null) return;

    SettingsCategory? sub;
    if (subcategoryId != null) {
      sub = _findCategoryInSettings(current.rootCategories, subcategoryId);
    }

    emit(
      current.copyWith(
        selectedSubcategoryId: subcategoryId,
        clearErrorMessage: true,
        generatedTitle: _generateTitle(current.selectedCategory, sub),
      ),
    );
  }

  String _generateTitle(SettingsCategory? root, SettingsCategory? sub) {
    if (root == null) return 'Expense';
    if (sub != null && sub.parentId != 0) {
      return '${root.title} | ${sub.title}';
    }
    return root.title;
  }


  void selectDate(DateTime date) {
    final current = _loadedStateOrNull();
    if (current == null) return;

    emit(current.copyWith(date: date, clearErrorMessage: true));
  }

  Future<bool> submitExpense() async {
    final current = _loadedStateOrNull();
    if (current == null || current.isSubmitting) {
      return false;
    }

    final amount = double.tryParse(current.amount);
    if (amount == null || amount <= 0) {
      emit(current.copyWith(errorMessage: 'Please enter a valid amount.'));
      return false;
    }

    final categoryId = current.selectedSubcategoryId ?? current.selectedCategoryId;
    final title = (current.title?.trim().isEmpty ?? true) ? null : current.title!.trim();

    emit(current.copyWith(isSubmitting: true, clearErrorMessage: true));
    
    final result = current.mode == AddExpenseMode.edit 
      ? await _repository.updateExpense(
          id: current.transactionId!,
          amount: amount,
          title: title,
          categoryId: categoryId,
          currencyCode: current.settings.baseCurrencyCode,
          date: current.date,
        )
      : await _repository.addExpense(
          amount: amount,
          title: title,
          categoryId: categoryId,
          currencyCode: current.settings.baseCurrencyCode,
          date: current.date,
        );

    return result.fold(
      (_) {
        emit(AddExpenseSuccess());
        return true;
      },
      (failure) {
        emit(
          current.copyWith(
            isSubmitting: false,
            errorMessage: failure.message,
          ),
        );
        return false;
      },
    );
  }

  AddExpenseLoaded? _loadedStateOrNull() {
    final current = state;
    if (current is AddExpenseLoaded) {
      return current;
    }
    return null;
  }
}
