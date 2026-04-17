import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_cubit.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_state.dart';

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
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            'Category',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
    required IconData icon,
    required String name,
    required bool isSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF2B8CEE) : Colors.grey[200],
              shape: BoxShape.circle,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFF2B8CEE).withOpacity(0.3),
                        blurRadius: 10,
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? const Color(0xFF2B8CEE) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
