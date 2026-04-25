import 'package:expense_tracker/core/styles/app_text_styles.dart';
import 'package:expense_tracker/core/styles/app_texts.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_cubit.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_state.dart';
import 'package:expense_tracker/core/domain/entities/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AmountDisplay extends StatelessWidget {
  const AmountDisplay({
    super.key,
    required this.cubit,
    required this.controller,
    this.enabled = true,
  });

  final AddExpenseCubit cubit;
  final TextEditingController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return BlocBuilder<AddExpenseCubit, AddExpenseState>(
      bloc: cubit,
      builder: (context, state) {
        final currencySymbol = state is AddExpenseLoaded
            ? _currencySymbol(state.settings.baseCurrencyCode)
            : '\$';

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 24.h),
          child: Column(
            children: [
              AppTextLabelMd(
                'ENTER AMOUNT',
                uppercase: true,
                color: cs.onSurfaceVariant,
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    currencySymbol,
                    style: AppTextStyles.displayMd(context).copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  IntrinsicWidth(
                    child: TextField(
                      controller: controller,
                      enabled: enabled,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: AppTextStyles.displayMd(context).copyWith(
                        color: cs.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      autofocus: enabled,
                      onChanged: (val) {
                        cubit.updateAmount(val);
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                      ],
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: false,
                        disabledBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 48.w),
                height: 2.h,
                decoration: BoxDecoration(
                  color: cs.outlineVariant.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _currencySymbol(String currencyCode) {
    return Currency.fromCode(currencyCode).symbol;
  }
}
