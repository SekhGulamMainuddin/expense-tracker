import 'dart:ui';

import 'package:expense_tracker/core/styles/app_texts.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:expense_tracker/core/widgets/app_icon.dart';
import 'package:expense_tracker/features/settings/domain/entities/settings_category.dart';
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

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: isExpanded ? cs.surfaceContainerHighest : cs.surfaceContainer,
        borderRadius: BorderRadius.circular(12.r),
        border: Border(
          left: BorderSide(color: categoryColor, width: 4.w),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: onToggleExpanded,
            leading: Builder(
              builder: (context) {
                final isCustom = category.icon.startsWith('custom:');
                return Container(
                  width: 44.r,
                  height: 44.r,
                  decoration: BoxDecoration(
                    color: isCustom ? Colors.transparent : categoryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Center(
                    child: AppIcon(
                      category.icon,
                      color: categoryColor,
                      size: isCustom ? 44.r : 24.r,
                    ),
                  ),
                );
              },
            ),
            title: Text(
              category.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${category.children.length} Subcategories',
            ),
            trailing: Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
            ),
          ),
          if (isExpanded)
            Container(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (category.children.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('No subcategories found in this category.'),
                    ),
                  for (final child in category.children)
                    Card(
                      margin: EdgeInsets.only(bottom: 8.h),
                      child: ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: Builder(
                          builder: (context) {
                            final isCustom = child.icon.startsWith('custom:');
                            return Container(
                              width: 44.r,
                              height: 44.r,
                              decoration: BoxDecoration(
                                color: isCustom ? Colors.transparent : Color(child.color).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Center(
                                child: AppIcon(
                                  child.icon,
                                  color: Color(child.color),
                                  size: isCustom ? 44.r : 24.r,
                                ),
                              ),
                            );
                          },
                        ),
                        title: Text(child.title),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, size: 20),
                          onPressed: () => onDeleteSubcategory(child.id),
                        ),
                        onTap: () => onEditSubcategory(child),
                      ),
                    ),
                  SizedBox(height: 8.h),
                  _AddSubcategoryButton(
                    onTap: onAddSubcategory,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class DashedRectPainter extends CustomPainter {
  DashedRectPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.gap = 5.0,
    this.borderRadius = 0,
  });

  final Color color;
  final double strokeWidth;
  final double gap;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Path path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(borderRadius),
        ),
      );

    final Path dashedPath = Path();
    for (final PathMetric measure in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < measure.length) {
        final double length = gap;
        dashedPath.addPath(
          measure.extractPath(distance, distance + length),
          Offset.zero,
        );
        distance += length * 2;
      }
    }
    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(DashedRectPainter oldDelegate) =>
      color != oldDelegate.color ||
      strokeWidth != oldDelegate.strokeWidth ||
      gap != oldDelegate.gap ||
      borderRadius != oldDelegate.borderRadius;
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
        PopupMenuItem(
          value: 'edit',
          child: AppTextBodyMd('settings.edit_category'),
        ),
        PopupMenuItem(
          value: 'add',
          child: AppTextBodyMd('settings.add_subcategory'),
        ),
        PopupMenuItem(
          value: 'delete',
          child: AppTextBodyMd(
            'settings.delete_category',
            color: context.theme.colorScheme.error,
          ),
        ),
      ],
    );
  }
}

class _AddSubcategoryButton extends StatelessWidget {
  const _AddSubcategoryButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: CustomPaint(
          painter: DashedRectPainter(
            color: cs.outlineVariant,
            strokeWidth: 1.2,
            gap: 4.r,
            borderRadius: 12.r,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_circle_outline, size: 18.r, color: cs.primary),
                SizedBox(width: 8.w),
                AppTextLabelMd(
                  'settings.add_new_subcategory',
                  color: cs.primary,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}