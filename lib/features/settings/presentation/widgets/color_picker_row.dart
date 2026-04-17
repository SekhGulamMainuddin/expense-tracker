import 'package:flutter/material.dart';

class ColorPickerRow extends StatelessWidget {
  const ColorPickerRow({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  static const _colors = [
    Color(0xFF2B8CEE),
    Color(0xFF10B981),
    Color(0xFFF43F5E),
    Color(0xFFF59E0B),
    Color(0xFF6366F1),
    Color(0xFFA855F7),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: _colors.map((color) {
          final isSelected = selectedColor == color;
          return GestureDetector(
            onTap: () => onColorSelected(color),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(color: color.withOpacity(0.2), width: 4)
                    : null,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          );
        }).toList(),
      ),
    );
  }
}
