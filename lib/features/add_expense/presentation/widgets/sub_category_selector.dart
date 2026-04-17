import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_cubit.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_state.dart';

class SubCategorySelector extends StatelessWidget {
  const SubCategorySelector({super.key});

  static const _subCategories = ['Lunch', 'Snacks', 'Groceries', 'Dinner'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Wrap(
        spacing: 8,
        children: _subCategories
            .map((sub) => BlocBuilder<AddExpenseCubit, AddExpenseState>(
                  builder: (context, state) {
                    final isSelected = state.selectedSubCategory == sub;
                    return ChoiceChip(
                      label: Text(sub),
                      selected: isSelected,
                      onSelected: (_) =>
                          context.read<AddExpenseCubit>().selectSub(sub),
                      selectedColor: const Color(0xFF2B8CEE).withOpacity(0.1),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? const Color(0xFF2B8CEE)
                            : Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: isSelected
                              ? const Color(0xFF2B8CEE)
                              : Colors.transparent,
                        ),
                      ),
                      showCheckmark: false,
                    );
                  },
                ))
            .toList(),
      ),
    );
  }
}
