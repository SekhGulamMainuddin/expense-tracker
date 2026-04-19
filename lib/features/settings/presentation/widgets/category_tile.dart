import 'package:flutter/material.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:expense_tracker/features/settings/presentation/widgets/add_subcategory_content.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.isExpanded,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isExpanded;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          ListTile(
            onTap: onTap,
            leading: Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: color, size: 24.r),
            ),
            title: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(fontSize: 12.sp),
            ),
            trailing: Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
              size: 24.r,
            ),
          ),
          if (isExpanded)
            Container(
              width: double.infinity,
              color: theme.brightness == Brightness.light 
                  ? Colors.grey.shade50 
                  : theme.colorScheme.secondary.withOpacity(0.1),
              padding: EdgeInsets.all(16.r),
              child: Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  _subCategoryChip(context, 'Groceries'),
                  _subCategoryChip(context, 'Restaurants'),
                  _subCategoryChip(context, 'Coffee'),
                  ActionChip(
                    avatar: Icon(Icons.add, size: 16.r),
                    label: Text('Add', style: TextStyle(fontSize: 11.sp)),
                    onPressed: () => context.parentContext.showAppBottomSheet(
                      isScrollControlled: true,
                      customWidget: AddSubcategoryContent(
                        parentCategory: title,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _subCategoryChip(BuildContext context, String label) {
    final theme = context.theme;
    return Chip(
      label: Text(label, style: TextStyle(fontSize: 11.sp)),
      deleteIcon: Icon(Icons.close, size: 14.r),
      onDeleted: () {},
      backgroundColor: theme.colorScheme.surface,
      shape: StadiumBorder(side: BorderSide(color: theme.colorScheme.outline)),
    );
  }
}


