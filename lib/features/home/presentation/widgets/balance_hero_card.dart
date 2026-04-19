import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expense_tracker/features/home/presentation/cubit/finance_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/ui_extensions.dart';

class BalanceHeroCard extends StatelessWidget {
  const BalanceHeroCard({super.key, required this.state});

  final FinanceState state;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Container(
      margin: EdgeInsets.all(24.r),
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 20.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Balance',
            style: GoogleFonts.manrope(
              color: theme.colorScheme.onPrimary.withOpacity(0.7),
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '\$${state.balance.toStringAsFixed(2)}',
            style: GoogleFonts.manrope(
              color: theme.colorScheme.onPrimary,
              fontSize: 32.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              _badge(context, Icons.arrow_upward, '\$${state.income.toStringAsFixed(2)}'),
              SizedBox(width: 12.w),
              _badge(context, Icons.arrow_downward, '\$${state.expenses.toStringAsFixed(2)}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _badge(BuildContext context, IconData icon, String text) {
    final theme = context.theme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14.r, color: theme.colorScheme.onPrimary),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}


