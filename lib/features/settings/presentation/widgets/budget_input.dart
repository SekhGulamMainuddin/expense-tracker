import 'package:expense_tracker/core/styles/app_dimensions.dart';
import 'package:expense_tracker/core/styles/app_palette.dart';
import 'package:expense_tracker/core/styles/app_text_styles.dart';
import 'package:expense_tracker/core/styles/app_texts.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BudgetInput extends StatefulWidget {
  const BudgetInput({
    super.key,
    required this.label,
    required this.value,
    required this.currencySymbol,
    required this.onSubmitted,
    this.onChanged,
    this.budgetBand,
  });

  final String label;
  final double value;
  final String currencySymbol;
  final ValueChanged<double> onSubmitted;
  final ValueChanged<double>? onChanged;

  /// Optional band for tonal wash behind the field: `'safe'` | `'caution'` | `'danger'`.
  final String? budgetBand;

  @override
  State<BudgetInput> createState() => _BudgetInputState();
}

class _BudgetInputState extends State<BudgetInput> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _formatValue(widget.value));
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(covariant BudgetInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    final formattedValue = _formatValue(widget.value);
    if (_controller.text != formattedValue && !_focusNode.hasFocus) {
      _controller.text = formattedValue;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      _submitValue();
    }
  }

  void _submitValue() {
    final parsed = double.tryParse(_controller.text.trim());
    if (parsed == null) {
      _controller.text = _formatValue(widget.value);
      return;
    }

    widget.onSubmitted(parsed);
    _controller.text = _formatValue(parsed);
  }

  String _formatValue(double value) {
    if (value % 1 == 0) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    Color? wash;
    switch (widget.budgetBand) {
      case 'safe':
        wash = AppPalette.safeBandWashGreen(cs);
        break;
      case 'caution':
        wash = AppPalette.safeBandWashYellow(cs);
        break;
      case 'danger':
        wash = AppPalette.safeBandWashRed(cs);
        break;
      default:
        wash = null;
    }

    final ghost = cs.outlineVariant.withValues(alpha: AppPalette.ghostBorderOpacity(context));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextLabelMd(
          widget.label,
          uppercase: true,
          color: cs.onSurfaceVariant,
        ),
        SizedBox(height: 10.h),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: wash ?? cs.surfaceContainerLow,
            borderRadius: AppRadii.xl,
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: AppTextStyles.headlineLg(context),
            onChanged: (text) {
              final parsed = double.tryParse(text.trim());
              if (parsed != null && widget.onChanged != null) {
                widget.onChanged!(parsed);
              }
            },
            onSubmitted: (_) => _submitValue(),
            decoration: InputDecoration(
              prefixText: '${widget.currencySymbol} ',
              prefixStyle: AppTextStyles.headlineLg(context).copyWith(
                color: cs.primary,
              ),
              filled: false,
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: ghost, width: 2.w),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ghost, width: 2.w),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: cs.primary.withValues(alpha: 0.65), width: 2.w),
              ),
              contentPadding: EdgeInsets.only(bottom: 8.h),
            ),
          ),
        ),
      ],
    );
  }
}
