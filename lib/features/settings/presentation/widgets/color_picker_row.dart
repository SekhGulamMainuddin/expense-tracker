import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return Row(
      children: _colors.map((color) {
        final isSelected = selectedColor == color;
        return GestureDetector(
          onTap: () => onColorSelected(color),
          child: Container(
            margin: EdgeInsets.only(right: 12.w),
            width: 32.w,
            height: 32.h,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: color.withOpacity(0.2), width: 4.w)
                  : null,
            ),
            child: isSelected
                ? Icon(Icons.check, size: 16.r, color: Colors.white)
                : null,
          ),
        );
      }).toList(),
    );
  }
}

