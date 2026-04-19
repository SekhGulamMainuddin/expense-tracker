import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.transaction});

  final Map<String, dynamic> transaction;

  @override
  Widget build(BuildContext context) {
    final bool isPositive = (transaction['amount'] as double) > 0;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Icons.shopping_bag, color: const Color(0xFF2B8CEE), size: 24.r),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['title'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  transaction['subtitle'] as String,
                  style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                ),
              ],
            ),
          ),
          Text(
            '${isPositive ? '+' : '-'}\$${(transaction['amount'] as double).abs().toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
              color: isPositive ? const Color(0xFF10B981) : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

