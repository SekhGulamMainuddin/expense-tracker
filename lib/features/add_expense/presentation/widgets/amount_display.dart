import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_cubit.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_text_styles.dart';
import '../../../../core/styles/app_texts.dart';
import '../../../../core/utils/ui_extensions.dart';

class AmountDisplay extends StatelessWidget {
  const AmountDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return BlocBuilder<AddExpenseCubit, AddExpenseState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 32.h),
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
                    '\$',
                    style: AppTextStyles.displayMd(context).copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  AppTextDisplayMd(
                    state.amount,
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 48.w),
                height: 2.h,
                decoration: BoxDecoration(
                  color: cs.outlineVariant.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
