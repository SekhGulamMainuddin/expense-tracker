import 'package:flutter/material.dart';

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
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: _icons.length,
      itemBuilder: (context, index) {
        final iconName = _icons[index];
        final isSelected = selectedIcon == iconName;
        return GestureDetector(
          onTap: () => onIconSelected(iconName),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? selectedColor : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: selectedColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              _getIconData(iconName),
              color: isSelected ? Colors.white : const Color(0xFF94A3B8),
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
