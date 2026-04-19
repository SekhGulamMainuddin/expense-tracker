import 'package:flutter/material.dart';
import 'package:expense_tracker/features/home/presentation/cubit/finance_state.dart';
import 'package:expense_tracker/features/home/presentation/widgets/transaction_tile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecentTransactionsSection extends StatelessWidget {
  const RecentTransactionsSection({super.key, required this.state});

  final FinanceState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.r),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Payments',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
              ),
              Text(
                'See All',
                style: TextStyle(color: Colors.grey, fontSize: 14.sp),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...state.transactions
              .map((tx) => TransactionTile(transaction: tx))
              .toList(),
        ],
      ),
    );
  }
}

