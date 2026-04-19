import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_cubit.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/ui_extensions.dart';

class NumericKeypad extends StatelessWidget {
  const NumericKeypad({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, -5.h),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            childAspectRatio: 1.5,
            mainAxisSpacing: 10.h,
            crossAxisSpacing: 10.w,
            children: [
              ...['1', '2', '3', '4', '5', '6', '7', '8', '9', '.', '0']
                  .map((val) => _keyButton(val)),
              _keyButton('backspace', isIcon: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _keyButton(String val, {bool isIcon = false}) {
    return BlocBuilder<AddExpenseCubit, AddExpenseState>(
      builder: (context, state) {
        return Material(
          color: Colors.transparent,
          child: IconButton(
            onPressed: () => context.read<AddExpenseCubit>().keyPressed(val),
            icon: Center(
              child: isIcon
                  ? Icon(Icons.backspace_outlined, size: 24.r)
                  : Text(
                      val,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}

