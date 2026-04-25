import 'package:expense_tracker/core/styles/app_texts.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:expense_tracker/features/home/domain/entities/finance_snapshot.dart';
import 'package:expense_tracker/features/home/presentation/widgets/transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class RecentTransactionsSection extends StatelessWidget {
  const RecentTransactionsSection({
    super.key,
    required this.snapshot,
    required this.currencySymbol,
  });

  final FinanceSnapshot snapshot;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(24.r, 8.r, 24.r, 24.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppTextHeadlineSm('home.recent_payments'),
              if (snapshot.recentTransactions.isNotEmpty)
                TextButton(
                  onPressed: () {
                    // Navigate to transactions screen
                    GoRouter.of(context).push('/transactions');
                  },
                  child: AppTextLabelMd(
                    'home.view_all',
                    color: cs.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),

          SizedBox(height: 16.h),
          if (snapshot.recentTransactions.isEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: cs.surfaceContainer,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 52.r,
                    color: cs.onSurfaceVariant,
                  ),
                  SizedBox(height: 12.h),
                  AppTextBodyLg(
                    'home.no_transactions',
                    style: context.theme.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  AppTextBodyMd(
                    'home.no_transactions_desc',
                    textAlign: TextAlign.center,
                    color: cs.onSurfaceVariant,
                  ),
                ],
              ),
            )
          else
            ...snapshot.recentTransactions.map(
              (tx) => TransactionTile(
                transaction: tx,
                currencySymbol: currencySymbol,
              ),
            ),
        ],
      ),
    );
  }
}
