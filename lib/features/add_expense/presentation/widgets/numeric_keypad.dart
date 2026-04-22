import 'package:expense_tracker/core/styles/app_palette.dart';
import 'package:expense_tracker/core/styles/app_text_styles.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NumericKeypad extends StatelessWidget {
  const NumericKeypad({super.key, required this.cubit});

  final AddExpenseCubit cubit;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 16.h, 12.w, 24.h),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: AppPalette.ambientShadow.withValues(alpha: 0.25),
            blurRadius: 24.r,
            offset: Offset(0, -8.h),
          ),
        ],
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        childAspectRatio: 1.85,
        mainAxisSpacing: 8.h,
        crossAxisSpacing: 8.w,
        children: [
          ...['1', '2', '3', '4', '5', '6', '7', '8', '9', '.', '0']
              .map((val) => _DigitKey(label: val, cubit: cubit)),
          _BackspaceKey(cubit: cubit),
        ],
      ),
    );
  }
}

class _DigitKey extends StatefulWidget {
  const _DigitKey({required this.label, required this.cubit});

  final String label;
  final AddExpenseCubit cubit;

  @override
  State<_DigitKey> createState() => _DigitKeyState();
}

class _DigitKeyState extends State<_DigitKey> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () => widget.cubit.updateAmount(widget.label),
      child: AnimatedScale(
        scale: _pressed ? 1.08 : 1,
        duration: const Duration(milliseconds: 90),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: _pressed
                ? [
                    BoxShadow(
                      color: cs.primary.withValues(alpha: 0.28),
                      blurRadius: 18.r,
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: Text(
            widget.label,
            style: AppTextStyles.displaySm(context).copyWith(
              color: cs.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class _BackspaceKey extends StatelessWidget {
  const _BackspaceKey({required this.cubit});

  final AddExpenseCubit cubit;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return IconButton(
      onPressed: () => cubit.updateAmount('backspace'),
      icon: Icon(
        Icons.backspace_outlined,
        size: 26.r,
        color: cs.onSurfaceVariant,
      ),
    );
  }
}
