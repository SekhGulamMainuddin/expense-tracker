import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_text_styles.dart';
import '../../../../core/styles/app_texts.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.transaction});

  final Map<String, dynamic> transaction;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final bool isPositive = (transaction['amount'] as double) > 0;

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: cs.surfaceContainer,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(14.r),
          child: Row(
            children: [
              Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  color: cs.primaryContainer.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Icons.shopping_bag, color: cs.primary, size: 24.r),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextBodyLg(
                      transaction['title'] as String,
                      
                      style: AppTextStyles.bodyLg(context).copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    AppTextBodyMd(
                      transaction['subtitle'] as String,
                      
                      color: cs.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
              Text(
                '${isPositive ? '+' : '-'}\$${(transaction['amount'] as double).abs().toStringAsFixed(2)}',
                style: AppTextStyles.bodyMd(context).copyWith(
                  fontWeight: FontWeight.w600,
                  color: isPositive ? cs.secondary : cs.error,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
