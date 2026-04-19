import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_cubit.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/ui_extensions.dart';

class SubCategorySelector extends StatelessWidget {
  const SubCategorySelector({super.key});

  static const _subCategories = ['Lunch', 'Snacks', 'Groceries', 'Dinner'];

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children: _subCategories
            .map((sub) => BlocBuilder<AddExpenseCubit, AddExpenseState>(
                  builder: (context, state) {
                    final isSelected = state.selectedSubCategory == sub;
                    return ChoiceChip(
                      label: Text(sub, style: TextStyle(fontSize: 12.sp)),
                      selected: isSelected,
                      onSelected: (_) =>
                          context.read<AddExpenseCubit>().selectSub(sub),
                      selectedColor: theme.colorScheme.primary.withOpacity(0.1),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: isSelected
                              ? theme.colorScheme.primary
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

