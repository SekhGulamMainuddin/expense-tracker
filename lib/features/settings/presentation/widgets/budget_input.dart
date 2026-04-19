import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/ui_extensions.dart';

class BudgetInput extends StatelessWidget {
  const BudgetInput({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 10.sp,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: TextEditingController(text: value),
          decoration: InputDecoration(
            prefixText: '\$ ',
            fillColor: theme.brightness == Brightness.light 
                ? const Color(0xFFF8FAFC) 
                : theme.colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
          ),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
        ),
      ],
    );
  }
}

