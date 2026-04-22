import 'package:expense_tracker/core/styles/app_texts.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:expense_tracker/features/settings/domain/entities/settings_category.dart';
import 'package:expense_tracker/features/settings/presentation/widgets/icon_grid_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    required this.category,
    required this.isExpanded,
    required this.onToggleExpanded,
    required this.onAddSubcategory,
    required this.onEditCategory,
    required this.onDeleteCategory,
    required this.onEditSubcategory,
    required this.onDeleteSubcategory,
  });

  final SettingsCategory category;
  final bool isExpanded;
  final VoidCallback onToggleExpanded;
  final VoidCallback onAddSubcategory;
  final VoidCallback onEditCategory;
  final VoidCallback onDeleteCategory;
  final void Function(SettingsCategory category) onEditSubcategory;
  final ValueChanged<int> onDeleteSubcategory;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final categoryColor = Color(category.color);
    final expansionColor =
        isExpanded ? cs.surfaceContainerHighest : cs.surfaceContainer;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onToggleExpanded,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: expansionColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(width: 4.w, color: categoryColor),
                  Expanded(
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.fromLTRB(
                            12.w,
                            12.h,
                            12.w,
                            isExpanded ? 8.h : 12.h,
                          ),
                          leading: Container(
                            padding: EdgeInsets.all(10.r),
                            decoration: BoxDecoration(
                              color: categoryColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              IconGridSelector.iconForName(category.icon),
                              color: categoryColor,
                              size: 24.r,
                            ),
                          ),
                          title: AppTextBodyLg(
                            category.title,
                            style: context.theme.textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Padding(
                            padding: EdgeInsets.only(top: 4.h),
                            child: AppTextBodyMd(
                              '${category.children.length} Subcategories',
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _CategoryMenu(
                                onEdit: onEditCategory,
                                onAddSubcategory: onAddSubcategory,
                                onDelete: onDeleteCategory,
                              ),
                              Icon(
                                isExpanded
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                                color: cs.onSurfaceVariant,
                                size: 24.r,
                              ),
                            ],
                          ),
                        ),
                        if (isExpanded)
                          Padding(
                            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                            child: Wrap(
                              spacing: 8.w,
                              runSpacing: 8.h,
                              children: [
                                for (final child in category.children)
                                  InputChip(
                                    avatar: CircleAvatar(
                                      backgroundColor:
                                          Color(child.color).withOpacity(0.16),
                                      child: Icon(
                                        IconGridSelector.iconForName(child.icon),
                                        size: 14.r,
                                        color: Color(child.color),
                                      ),
                                    ),
                                    label: AppTextLabelSm(child.title),
                                    deleteIcon: Icon(Icons.close, size: 14.r),
                                    onPressed: () => onEditSubcategory(child),
                                    onDeleted: () =>
                                        onDeleteSubcategory(child.id),
                                    backgroundColor: cs.surfaceContainerLow,
                                    side: BorderSide.none,
                                    shape: const StadiumBorder(),
                                  ),
                                ActionChip(
                                  avatar: Icon(Icons.add, size: 16.r),
                                  label: const AppTextLabelSm('Add'),
                                  backgroundColor: cs.surfaceContainerLow,
                                  onPressed: onAddSubcategory,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryMenu extends StatelessWidget {
  const _CategoryMenu({
    required this.onEdit,
    required this.onAddSubcategory,
    required this.onDelete,
  });

  final VoidCallback onEdit;
  final VoidCallback onAddSubcategory;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        size: 20.r,
        color: context.theme.colorScheme.onSurfaceVariant,
      ),
      onSelected: (value) {
        if (value == 'edit') {
          onEdit();
        } else if (value == 'add') {
          onAddSubcategory();
        } else if (value == 'delete') {
          onDelete();
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Text('Edit Category'),
        ),
        const PopupMenuItem(
          value: 'add',
          child: Text('Add Subcategory'),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Text('Delete Category'),
        ),
      ],
    );
  }
}
