import 'package:expense_tracker/core/styles/app_texts.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:expense_tracker/features/home/domain/entities/finance_snapshot.dart';
import 'package:expense_tracker/features/home/presentation/widgets/transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecentTransactionsSection extends StatelessWidget {
  const RecentTransactionsSection({
    super.key,
    required this.snapshot,
    required this.currencySymbol,
    required this.onSeeAll,
  });

  final FinanceSnapshot snapshot;
  final String currencySymbol;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(24.r, 8.r, 24.r, 24.r),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppTextHeadlineSm('home.recent_payments'),
              TextButton(
                onPressed: onSeeAll,
                child: const AppTextLabelMd('home.see_all'),
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
