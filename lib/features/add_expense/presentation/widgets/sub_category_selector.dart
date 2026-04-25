import 'package:expense_tracker/core/styles/app_texts.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:expense_tracker/core/widgets/app_icon.dart';
import 'package:expense_tracker/features/settings/domain/entities/settings_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubCategorySelector extends StatelessWidget {
  const SubCategorySelector({
    super.key,
    required this.subcategories,
    required this.selectedSubcategoryId,
    required this.onSubcategorySelected,
  });

  final List<SettingsCategory> subcategories;
  final int? selectedSubcategoryId;
  final ValueChanged<int?>? onSubcategorySelected;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    if (subcategories.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: AppTextBodyMd(
          'This category has no subcategories yet. You can save the expense directly.',
          color: cs.onSurfaceVariant,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
          child: AppTextLabelMd(
            'Subcategory',
            uppercase: true,
            color: cs.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 6.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: [
            for (final subcategory in subcategories)
              _SubcategoryChip(
                subcategory: subcategory,
                isSelected: selectedSubcategoryId == subcategory.id,
                onTap: onSubcategorySelected == null
                    ? null
                    : () => onSubcategorySelected!(subcategory.id),
              ),
          ],
        ),
      ],
    );
  }
}

class _SubcategoryChip extends StatelessWidget {
  const _SubcategoryChip({
    required this.subcategory,
    required this.isSelected,
    required this.onTap,
  });

  final SettingsCategory subcategory;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final categoryColor = Color(subcategory.color);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: isSelected ? categoryColor : cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isSelected ? categoryColor : cs.outlineVariant.withValues(alpha: 0.5),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Builder(
                  builder: (context) {
                    final isCustom = subcategory.icon.startsWith('custom:');
                    return AppIcon(
                      subcategory.icon,
                      size: isCustom ? 20.r : 16.r,
                      color: isSelected ? Colors.white : categoryColor,
                    );
                  },
                ),
                SizedBox(width: 8.w),
                AppTextLabelMd(
                  subcategory.title,
                  color: isSelected ? Colors.white : cs.onSurface,
                  style: context.theme.textTheme.labelMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
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
