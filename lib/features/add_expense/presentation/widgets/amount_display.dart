import 'package:expense_tracker/core/styles/app_text_styles.dart';
import 'package:expense_tracker/core/styles/app_texts.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_cubit.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AmountDisplay extends StatelessWidget {
  const AmountDisplay({super.key, required this.cubit});

  final AddExpenseCubit cubit;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return BlocBuilder<AddExpenseCubit, AddExpenseState>(
      bloc: cubit,
      builder: (context, state) {
        final amount = state is AddExpenseLoaded ? state.amount : '0';
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
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    currencySymbol,
                    style: AppTextStyles.displayMd(context).copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  AppTextDisplayMd(amount),
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
    return switch (currencyCode.toLowerCase()) {
      'usd' => '\$',
      'eur' => '€',
      'inr' => '₹',
      _ => currencyCode.toUpperCase(),
    };
  }
}
