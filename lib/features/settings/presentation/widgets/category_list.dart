import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:expense_tracker/features/settings/presentation/cubit/settings_state.dart';
import 'package:expense_tracker/features/settings/presentation/widgets/category_tile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/ui_extensions.dart';

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
            SizedBox(height: 12.h),
            const CategoryTile(
              title: 'Travel',
              subtitle: '4 Subcategories',
              icon: Icons.flight,
              color: Colors.blue,
              isExpanded: false,
            ),
            SizedBox(height: 12.h),
            _addCategoryButton(context),
          ],
        );
      },
    );
  }

  Widget _addCategoryButton(BuildContext context) {
    final theme = context.theme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.5),
          width: 2.w,
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_circle, color: theme.colorScheme.primary, size: 24.r),
          SizedBox(width: 8.w),
          Text(
            'Add New Category',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
          ),
        ],
      ),
    );
  }
}

