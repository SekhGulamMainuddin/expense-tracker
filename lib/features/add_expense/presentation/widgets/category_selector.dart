import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_cubit.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/ui_extensions.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          child: const Text(
            'Category',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
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
                  final isSelected =
                      state.selectedCategory == category['name'];
                  return GestureDetector(
                    onTap: () => context
                        .read<AddExpenseCubit>()
                        .selectCategory(category['name']! as String),
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
    final theme = context.theme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        children: [
          Container(
            width: 64.w,
            height: 64.h,
            decoration: BoxDecoration(
              color: isSelected ? theme.colorScheme.primary : theme.colorScheme.secondary.withOpacity(0.3),
              shape: BoxShape.circle,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                        blurRadius: 10.r,
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[600],
              size: 24.r,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            name,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? theme.colorScheme.primary : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

