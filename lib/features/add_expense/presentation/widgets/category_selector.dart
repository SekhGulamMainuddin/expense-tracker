import 'package:flutter/material.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_cubit.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_texts.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({super.key});

  static const _categories = [
    {'name': 'Food', 'icon': Icons.restaurant},
    {'name': 'Travel', 'icon': Icons.directions_car},
    {'name': 'Shopping', 'icon': Icons.shopping_bag},
    {'name': 'Bills', 'icon': Icons.receipt_long},
  ];

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          child: AppTextLabelMd(
            'Category',
            uppercase: true,
            color: cs.onSurfaceVariant,
          ),
        ),
        SizedBox(
          height: 100.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              return BlocBuilder<AddExpenseCubit, AddExpenseState>(
                builder: (context, state) {
                  final isSelected = state.selectedCategory == category['name'];
                  return GestureDetector(
                    onTap: () =>
                        context.read<AddExpenseCubit>().selectCategory(category['name']! as String),
                    child: _categoryItem(
                      context: context,
                      icon: category['icon']! as IconData,
                      name: category['name']! as String,
                      isSelected: isSelected,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _categoryItem({
    required BuildContext context,
    required IconData icon,
    required String name,
    required bool isSelected,
  }) {
    final cs = context.theme.colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        children: [
          Container(
            width: 64.w,
            height: 64.h,
            decoration: BoxDecoration(
              color: isSelected ? cs.primary : cs.surfaceContainerHigh,
              shape: BoxShape.circle,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: cs.primary.withOpacity(0.35),
                        blurRadius: 24.r,
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              icon,
              color: isSelected ? cs.onPrimary : cs.onSurfaceVariant,
              size: 24.r,
            ),
          ),
          SizedBox(height: 8.h),
          AppTextLabelMd(
            name,
            color: isSelected ? cs.primary : cs.onSurfaceVariant,
            style: context.theme.textTheme.labelMedium!.copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}
