import 'package:expense_tracker/core/styles/app_texts.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_cubit.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_state.dart';
import 'package:expense_tracker/features/settings/presentation/widgets/icon_grid_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubCategorySelector extends StatelessWidget {
  const SubCategorySelector({super.key, required this.cubit});

  final AddExpenseCubit cubit;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return BlocBuilder<AddExpenseCubit, AddExpenseState>(
      bloc: cubit,
      builder: (context, state) {
        if (state is! AddExpenseLoaded) {
          return const SizedBox.shrink();
        }

        final subcategories = state.subcategories;
        if (subcategories.isEmpty) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: AppTextBodyMd(
              'This category has no subcategories yet. You can save the expense directly in the selected category.',
              color: cs.onSurfaceVariant,
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
              child: AppTextLabelMd(
                'Subcategory',
                uppercase: true,
                color: cs.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 6.h),
            Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: [
                for (final subcategory in subcategories)
                  ChoiceChip(
                    selected: state.selectedSubcategoryId == subcategory.id,
                    onSelected: (_) => cubit.selectSubcategory(subcategory.id),
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          IconGridSelector.iconForName(subcategory.icon),
                          size: 16.r,
                          color: state.selectedSubcategoryId == subcategory.id
                              ? cs.onPrimary
                              : Color(subcategory.color),
                        ),
                        SizedBox(width: 8.w),
                        AppTextLabelMd(
                          subcategory.title,
                          color: state.selectedSubcategoryId == subcategory.id
                              ? cs.onPrimary
                              : cs.onSurfaceVariant,
                        ),
                      ],
                    ),
                    selectedColor: Color(subcategory.color),
                    backgroundColor: cs.surfaceContainerHigh,
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                    showCheckmark: false,
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
