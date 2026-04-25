import 'package:expense_tracker/core/styles/app_texts.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:expense_tracker/core/widgets/app_icon.dart';
import 'package:expense_tracker/features/settings/domain/entities/settings_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({
    super.key,
    required this.rootCategories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  final List<SettingsCategory> rootCategories;
  final int selectedCategoryId;
  final ValueChanged<int>? onCategorySelected;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
          child: AppTextLabelMd(
            'Category',
            uppercase: true,
            color: cs.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 6.h),
        SizedBox(
          height: 120.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: rootCategories.length,
            separatorBuilder: (context, index) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              final category = rootCategories[index];
              final isSelected = selectedCategoryId == category.id;
              final categoryColor = Color(category.color);

              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 104.w,
                decoration: BoxDecoration(
                  color: isSelected
                      ? categoryColor.withValues(alpha: 0.12)
                      : cs.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isSelected ? categoryColor : cs.outlineVariant.withValues(alpha: 0.5),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20.r),
                    onTap: onCategorySelected == null ? null : () => onCategorySelected!(category.id),
                    child: Padding(
                      padding: EdgeInsets.all(12.r),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Builder(
                            builder: (context) {
                              final isCustom = category.icon.startsWith('custom:');
                              return Container(
                                width: 44.r,
                                height: 44.r,
                                decoration: BoxDecoration(
                                  color: isCustom ? Colors.transparent : categoryColor.withValues(alpha: 0.14),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: AppIcon(
                                    category.icon,
                                    color: categoryColor,
                                    size: isCustom ? 44.r : 22.r,
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 10.h),
                          AppTextLabelMd(
                            category.title,
                            textAlign: TextAlign.center,
                            color: isSelected ? categoryColor : cs.onSurface,
                            maxLines: 1,
                            style: context.theme.textTheme.labelMedium?.copyWith(
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
