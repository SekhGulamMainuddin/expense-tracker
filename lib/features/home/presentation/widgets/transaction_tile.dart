import 'package:expense_tracker/core/styles/app_text_styles.dart';
import 'package:expense_tracker/core/styles/app_texts.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:expense_tracker/core/widgets/app_icon.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_state.dart';
import 'package:expense_tracker/features/add_expense/presentation/screens/add_expense_screen.dart';
import 'package:expense_tracker/features/home/domain/entities/finance_transaction.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    super.key,
    required this.transaction,
    required this.currencySymbol,
  });

  final FinanceTransaction transaction;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: InkWell(
        onTap: () {
          context.push(
            AddExpenseScreen.routeName,
            extra: AddExpenseArgs(
              transactionId: transaction.id,
              mode: AddExpenseMode.view,
            ),
          );
        },
        borderRadius: BorderRadius.circular(12.r),
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
                    color: Color(transaction.color).withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: AppIcon(
                    transaction.icon,
                    color: Color(transaction.color),
                    size: 24.r,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextBodyLg(
                        transaction.title,
                        style: AppTextStyles.bodyLg(
                          context,
                        ).copyWith(fontWeight: FontWeight.w600),
                      ),
                      AppTextBodyMd(
                        transaction.subtitle,
                        color: cs.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
                Text(
                  '-$currencySymbol${transaction.amount.toStringAsFixed(2)}',
                  style: AppTextStyles.bodyMd(
                    context,
                  ).copyWith(fontWeight: FontWeight.w600, color: cs.error),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
