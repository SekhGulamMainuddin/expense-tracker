import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:expense_tracker/features/settings/presentation/cubit/settings_state.dart';
import 'package:expense_tracker/features/settings/presentation/widgets/category_tile.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Column(
          children: [
            CategoryTile(
              title: 'Food & Drinks',
              subtitle: '12 Subcategories',
              icon: Icons.restaurant,
              color: Colors.orange,
              isExpanded: state.expandedCategories.contains('Food'),
              onTap: () =>
                  context.read<SettingsCubit>().toggleCategory('Food'),
            ),
            const SizedBox(height: 12),
            const CategoryTile(
              title: 'Travel',
              subtitle: '4 Subcategories',
              icon: Icons.flight,
              color: Colors.blue,
              isExpanded: false,
            ),
            const SizedBox(height: 12),
            _addCategoryButton(),
          ],
        );
      },
    );
  }

  Widget _addCategoryButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_circle, color: Colors.grey),
          SizedBox(width: 8),
          Text('Add New Category'),
        ],
      ),
    );
  }
}
