import 'package:expense_tracker/core/styles/app_texts.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:expense_tracker/core/widgets/app_icon.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_cubit.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({super.key, required this.cubit});

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

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
              child: AppTextLabelMd(
                'Category',
                uppercase: true,
                color: cs.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 6.h),
            SizedBox(
              height: 128.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: state.rootCategories.length,
                separatorBuilder: (context, index) => SizedBox(width: 12.w),
                itemBuilder: (context, index) {
                  final category = state.rootCategories[index];
                  final isSelected = state.selectedCategoryId == category.id;
                  final categoryColor = Color(category.color);

                  return Material(
                    color: isSelected
                        ? categoryColor.withValues(alpha: 0.16)
                        : cs.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(20.r),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20.r),
                      onTap: () => cubit.selectCategory(category.id),
                      child: Container(
                        width: 104.w,
                        padding: EdgeInsets.all(14.r),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: isSelected ? categoryColor : cs.outlineVariant,
                            width: isSelected ? 1.6 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 48.r,
                              height: 48.r,
                              decoration: BoxDecoration(
                                color: categoryColor.withValues(alpha: 0.14),
                                shape: BoxShape.circle,
                              ),
                              child: AppIcon(
                                category.icon,
                                color: categoryColor,
                                size: 24.r,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            AppTextLabelMd(
                              category.title,
                              textAlign: TextAlign.center,
                              color: isSelected ? categoryColor : cs.onSurfaceVariant,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
