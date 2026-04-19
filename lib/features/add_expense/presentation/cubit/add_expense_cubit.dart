import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_state.dart';

class AddExpenseCubit extends Cubit<AddExpenseState> {
  AddExpenseCubit()
      : super(
    AddExpenseState(
      amount: '0.00',
      selectedCategory: 'Food',
      selectedSubCategory: 'Lunch',
    ),
  );

  void keyPressed(String value) {
    final current = state.amount;

    if (value == 'backspace') {
      if (current.length <= 1) {
        emit(state.copyWith(amount: '0.00'));
      } else {
        emit(state.copyWith(
          amount: current.substring(0, current.length - 1),
        ));
      }
      return;
    }

    // Handle initial zero
    if (current == '0.00') {
      if (value == '.') {
        emit(state.copyWith(amount: '0.'));
      } else {
        emit(state.copyWith(amount: value));
      }
    } else {
      // Prevent double decimals
      if (value == '.' && current.contains('.')) return;
      emit(state.copyWith(amount: current + value));
    }
  }

  void selectCategory(String cat) => emit(state.copyWith(category: cat));

  void selectSub(String sub) => emit(state.copyWith(sub: sub));
}
