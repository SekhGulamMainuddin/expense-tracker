import 'package:expense_tracker/core/styles/app_texts.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:expense_tracker/features/settings/domain/entities/settings_category.dart';
import 'package:expense_tracker/features/settings/presentation/widgets/category_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({
    super.key,
    required this.categories,
    required this.onAddCategory,
    required this.onAddSubcategory,
    required this.onEditCategory,
    required this.onDeleteCategory,
    required this.onEditSubcategory,
    required this.onDeleteSubcategory,
  });

  final List<SettingsCategory> categories;
  final VoidCallback onAddCategory;
  final void Function(SettingsCategory parentCategory) onAddSubcategory;
  final void Function(SettingsCategory category) onEditCategory;
  final void Function(SettingsCategory category) onDeleteCategory;
  final void Function(SettingsCategory category) onEditSubcategory;
  final ValueChanged<int> onDeleteSubcategory;

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  final Set<int> _expandedCategoryIds = {};

  @override
  void didUpdateWidget(covariant CategoryList oldWidget) {
    super.didUpdateWidget(oldWidget);
    final rootIds = widget.categories.map((category) => category.id).toSet();
    _expandedCategoryIds.removeWhere((id) => !rootIds.contains(id));
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    if (widget.categories.isEmpty) {
      return _EmptyCategoryState(
        onAddCategory: widget.onAddCategory,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final category in widget.categories) ...[
          CategoryTile(
            category: category,
            isExpanded: _expandedCategoryIds.contains(category.id),
            onToggleExpanded: () {
              setState(() {
                if (_expandedCategoryIds.contains(category.id)) {
                  _expandedCategoryIds.remove(category.id);
                } else {
                  _expandedCategoryIds.add(category.id);
                }
              });
            },
            onAddSubcategory: () => widget.onAddSubcategory(category),
            onEditCategory: () => widget.onEditCategory(category),
            onDeleteCategory: () => widget.onDeleteCategory(category),
            onEditSubcategory: widget.onEditSubcategory,
            onDeleteSubcategory: widget.onDeleteSubcategory,
          ),
          SizedBox(height: 12.h),
        ],
        _AddCategoryButton(
          onTap: widget.onAddCategory,
          backgroundColor: cs.surfaceContainerLow,
        ),
      ],
    );
  }
}

class _AddCategoryButton extends StatelessWidget {
  const _AddCategoryButton({
    required this.onTap,
    required this.backgroundColor,
  });

  final VoidCallback onTap;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.add, color: cs.primary, size: 18.r),
              ),
              SizedBox(width: 12.w),
              AppTextBodyMd(
                'Add New Category',
                style: context.theme.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyCategoryState extends StatelessWidget {
  const _EmptyCategoryState({required this.onAddCategory});

  final VoidCallback onAddCategory;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextBodyLg(
            'No categories yet',
            style: context.theme.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6.h),
          AppTextBodyMd(
            'Add a category to start organizing your spending.',
            color: cs.onSurfaceVariant,
          ),
          SizedBox(height: 16.h),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton(
              onPressed: onAddCategory,
              child: const Text('Add Category'),
            ),
          ),
        ],
      ),
    );
  }
}
