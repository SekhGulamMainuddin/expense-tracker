import 'package:flutter/material.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:expense_tracker/features/home/presentation/cubit/finance_state.dart';
import 'package:expense_tracker/features/home/presentation/widgets/transaction_tile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_texts.dart';

class RecentTransactionsSection extends StatelessWidget {
  const RecentTransactionsSection({super.key, required this.state});

  final FinanceState state;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return Padding(
      padding: EdgeInsets.all(24.r),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppTextHeadlineSm('Recent Payments', ),
              GestureDetector(
                onTap: () {},
                child: AppTextBodyMd(
                  'See All',
                  
                  color: cs.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...state.transactions.map((tx) => TransactionTile(transaction: tx)),
        ],
      ),
    );
  }
}
