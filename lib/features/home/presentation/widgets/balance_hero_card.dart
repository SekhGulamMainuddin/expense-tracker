import 'package:flutter/material.dart';
import 'package:expense_tracker/features/home/presentation/cubit/finance_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_palette.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../core/styles/app_texts.dart';
import '../../../../core/utils/ui_extensions.dart';

class BalanceHeroCard extends StatelessWidget {
  const BalanceHeroCard({super.key, required this.state});

  final FinanceState state;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(24.r),
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: context.isLight ? cs.primary : cs.primaryContainer,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withOpacity(0.55),
            blurRadius: 24.r,
            offset: Offset(0, 12.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextLabelMd(
            'Total Balance',
            uppercase: true,
            letterSpacing: 0.06,
            color: Colors.white,
          ),
          SizedBox(height: 8.h),
          AppTextDisplayMd(
            '\$${state.balance.toStringAsFixed(2)}',
            style: AppTextStyles.displayMd(context),
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
