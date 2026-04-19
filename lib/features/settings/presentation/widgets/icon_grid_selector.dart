import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/ui_extensions.dart';

class IconGridSelector extends StatelessWidget {
  const IconGridSelector({
    super.key,
    required this.selectedIcon,
    required this.selectedColor,
    required this.onIconSelected,
  });

  final String selectedIcon;
  final Color selectedColor;
  final ValueChanged<String> onIconSelected;

  static const _icons = [
    'local_bar',
    'lunch_dining',
    'coffee',
    'icecream',
    'bakery_dining',
    'liquor',
    'restaurant_menu',
    'fastfood',
    'kitchen',
    'more_horiz',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
      ),
      itemCount: _icons.length,
      itemBuilder: (context, index) {
        final iconName = _icons[index];
        final isSelected = selectedIcon == iconName;
        return GestureDetector(
          onTap: () => onIconSelected(iconName),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? selectedColor : theme.colorScheme.secondary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: selectedColor.withOpacity(0.3),
                        blurRadius: 8.r,
                        offset: Offset(0, 4.h),
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              _getIconData(iconName),
              color: isSelected ? Colors.white : theme.colorScheme.onSurfaceVariant,
              size: 24.r,
            ),
          ),
        );
      },
    );
  }

  IconData _getIconData(String name) {
    return switch (name) {
      'local_bar' => Icons.local_bar,
      'lunch_dining' => Icons.lunch_dining,
      'coffee' => Icons.coffee,
      'icecream' => Icons.icecream,
      'bakery_dining' => Icons.bakery_dining,
      'liquor' => Icons.liquor,
      'restaurant_menu' => Icons.restaurant_menu,
      'fastfood' => Icons.fastfood,
      'kitchen' => Icons.kitchen,
      _ => Icons.more_horiz,
    };
  }
}

