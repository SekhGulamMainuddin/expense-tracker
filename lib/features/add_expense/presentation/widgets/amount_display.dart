import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_cubit.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/ui_extensions.dart';

class AmountDisplay extends StatelessWidget {
  const AmountDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return BlocBuilder<AddExpenseCubit, AddExpenseState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 32.h),
          child: Column(
            children: [
              Text(
                'ENTER AMOUNT',
                style: GoogleFonts.manrope(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.grey,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '\$',
                    style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    state.amount,
                    style: GoogleFonts.manrope(
                      fontSize: 48.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

