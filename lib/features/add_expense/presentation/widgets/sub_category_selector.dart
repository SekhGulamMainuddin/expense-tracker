import 'package:flutter/material.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_cubit.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_texts.dart';

class SubCategorySelector extends StatelessWidget {
  const SubCategorySelector({super.key});

  static const _subCategories = ['Lunch', 'Snacks', 'Groceries', 'Dinner'];

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
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
                      label: AppTextLabelMd(
                        sub,
                        color:
                            isSelected ? cs.primary : cs.onSurfaceVariant,
                      ),
                      selected: isSelected,
                      onSelected: (_) =>
                          context.read<AddExpenseCubit>().selectSub(sub),
                      selectedColor: cs.primary.withOpacity(0.12),
                      backgroundColor: cs.surfaceContainerHigh,
                      side: BorderSide.none,
                      shape: const StadiumBorder(),
                      labelStyle: context.theme.textTheme.labelMedium,
                      showCheckmark: false,
                    );
                  },
                ))
            .toList(),
      ),
    );
  }
}
