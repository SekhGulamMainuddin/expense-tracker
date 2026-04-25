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
          child: Stack(
            children: [
              // Category color indicator
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 4.w,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: categoryColor),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                        contentPadding: EdgeInsets.fromLTRB(
                          12.w,
                          12.h,
                          12.w,
                          isExpanded ? 8.h : 12.h,
                        ),
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
                         title: AppAutoSizeTextBodyLg(
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
                          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (category.children.isEmpty)
                                Padding(
                                  padding: EdgeInsets.only(bottom: 12.h),
                                  child: Container(
                                    padding: EdgeInsets.all(12.r),
                                    decoration: BoxDecoration(
                                      color: cs.surfaceContainerLow,
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.info_outline, size: 16.r, color: cs.onSurfaceVariant),
                                        SizedBox(width: 8.w),
                                        Expanded(
                                          child: AppTextLabelSm(
                                            'This category has no subcategories yet.',
                                            color: cs.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              else
                                Padding(
                                  padding: EdgeInsets.only(bottom: 12.h),
                                  child: Wrap(
                                    spacing: 8.w,
                                    runSpacing: 10.h,
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    children: [
                                      for (final child in category.children)
                                        InputChip(
                                          avatar: Builder(
                                            builder: (context) {
                                              final isCustom = child.icon.startsWith('custom:');
                                              return CircleAvatar(
                                                backgroundColor: isCustom 
                                                    ? Colors.transparent 
                                                    : Color(child.color).withValues(alpha: 0.16),
                                                child: AppIcon(
                                                  child.icon,
                                                  size: isCustom ? 24.r : 14.r,
                                                  color: Color(child.color),
                                                ),
                                              );
                                            },
                                          ),
                                          label: AppAutoSizeTextLabelSm(child.title),
                                          deleteIcon: Icon(Icons.close, size: 14.r),
                                          onPressed: () => onEditSubcategory(child),
                                          onDeleted: () =>
                                              onDeleteSubcategory(child.id),
                                          backgroundColor: cs.surfaceContainerLow,
                                          side: BorderSide.none,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.r),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              _AddSubcategoryButton(
                                onTap: onAddSubcategory,
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
                  'Add New Subcategory',
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
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(borderRadius),
      ));

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
