import 'package:flutter/material.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:expense_tracker/core/styles/app_texts.dart';
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
    final cs = context.theme.colorScheme;
    final expansionColor =
        isExpanded ? cs.surfaceContainerHighest : cs.surfaceContainer;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
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
                  Container(width: 4.w, color: color),
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
                              color: color.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(icon, color: color, size: 24.r),
                          ),
                          title: AppTextBodyLg(
                            title,
                            
                            style: context.theme.textTheme.bodyLarge!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          subtitle: Padding(
                            padding: EdgeInsets.only(top: 4.h),
                            child: AppTextBodyMd(
                              subtitle,
                              
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                          trailing: Icon(
                            isExpanded ? Icons.expand_less : Icons.expand_more,
                            color: cs.onSurfaceVariant,
                            size: 24.r,
                          ),
                        ),
                        if (isExpanded)
                          Padding(
                            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                            child: Wrap(
                              spacing: 8.w,
                              runSpacing: 8.h,
                              children: [
                                _subCategoryChip(context, 'Groceries'),
                                _subCategoryChip(context, 'Restaurants'),
                                _subCategoryChip(context, 'Coffee'),
                                ActionChip(
                                  avatar: Icon(Icons.add, size: 16.r),
                                  label: AppTextLabelSm(
                                    'Add',
                                    
                                  ),
                                  backgroundColor: cs.surfaceContainerLow,
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _subCategoryChip(BuildContext context, String label) {
    final cs = context.theme.colorScheme;
    return Chip(
      label: AppTextLabelSm(label, ),
      deleteIcon: Icon(Icons.close, size: 14.r),
      onDeleted: () {},
      backgroundColor: cs.surfaceContainerLow,
      side: BorderSide.none,
      shape: const StadiumBorder(),
    );
  }
}
