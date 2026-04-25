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

  Future<void> loadFormData() async {
    emit(AddExpenseLoading());
    final result = await _repository.loadFormData();
    result.fold(
      (settings) {
        if (settings.categories.isEmpty) {
          emit(AddExpenseFailure('No categories available yet.'));
          return;
        }

        final firstRoot = settings.categories.first;
        emit(
          AddExpenseLoaded(
            settings: settings,
            amount: '0',
            title: '',
            date: DateTime.now(),
            selectedCategoryId: firstRoot.id,
            selectedSubcategoryId:
                firstRoot.children.isNotEmpty ? firstRoot.children.first.id : null,
          ),
        );
      },
      (failure) => emit(AddExpenseFailure(failure.message)),
    );
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

    emit(
      current.copyWith(
        selectedCategoryId: categoryId,
        selectedSubcategoryId: selectedRoot.children.isNotEmpty
            ? selectedRoot.children.first.id
            : null,
        clearSelectedSubcategoryId: selectedRoot.children.isEmpty,
        clearErrorMessage: true,
      ),
    );
  }

  void selectSubcategory(int? subcategoryId) {
    final current = _loadedStateOrNull();
    if (current == null) return;

    emit(
      current.copyWith(
        selectedSubcategoryId: subcategoryId,
        clearErrorMessage: true,
      ),
    );
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
    final title = current.title.trim().isEmpty ? null : current.title.trim();

    emit(current.copyWith(isSubmitting: true, clearErrorMessage: true));
    final result = await _repository.addExpense(
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
