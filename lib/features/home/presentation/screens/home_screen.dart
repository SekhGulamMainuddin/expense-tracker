import 'package:expense_tracker/core/di/service_locator.dart';
import 'package:expense_tracker/core/styles/app_texts.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:expense_tracker/features/add_expense/presentation/screens/add_expense_screen.dart';
import 'package:expense_tracker/features/home/domain/entities/finance_category_breakdown.dart';
import 'package:expense_tracker/features/home/domain/entities/finance_snapshot.dart';
import 'package:expense_tracker/features/home/presentation/cubit/finance_cubit.dart';
import 'package:expense_tracker/features/home/presentation/cubit/finance_state.dart';
import 'package:expense_tracker/features/home/presentation/widgets/balance_hero_card.dart';
import 'package:expense_tracker/features/home/presentation/widgets/category_chart_section.dart';
import 'package:expense_tracker/features/home/presentation/widgets/recent_transactions_section.dart';
import 'package:expense_tracker/features/home/presentation/widgets/summary_cards_row.dart';
import 'package:expense_tracker/features/home/presentation/widgets/transaction_tile.dart';
import 'package:expense_tracker/features/profile/presentation/screens/profile_screen.dart';
import 'package:expense_tracker/core/widgets/app_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final financeCubit = getIt<FinanceCubit>();
    void openAddExpense() {
      context.push(AddExpenseScreen.routeName);
    }

    return BlocConsumer<FinanceCubit, FinanceState>(
      bloc: financeCubit,
      listener: (context, state) {
        if (state is FinanceFailure) {
          context.showAppSnackBar(state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is FinanceInitial || state is FinanceLoading;
        final isFailure = state is FinanceFailure;
        final snapshot = state is FinanceLoaded ? state.snapshot : null;

        return Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: EdgeInsets.only(left: 16.w),
              child: GestureDetector(
                onTap: () => context.push(ProfileScreen.routeName),
                child: CircleAvatar(
                  backgroundColor: context.theme.colorScheme.surfaceContainerHigh,
                  child: Icon(Icons.person, color: context.theme.colorScheme.onSurfaceVariant, size: 20.r),
                ),
              ),
            ),
            title: const AppTextTitleMd('My Finances'),
            actions: [
              IconButton(
                onPressed: openAddExpense,
                icon: Icon(Icons.add_circle_outline, size: 24.r),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: 'home-add-expense-fab',
            onPressed: openAddExpense,
            child: const Icon(Icons.add),
          ),
          body: RefreshIndicator(
            onRefresh: financeCubit.refresh,
            child: Builder(
              builder: (context) {
                if (isLoading || snapshot == null) {
                  if (isFailure) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: 96.h),
                        _HomeFailureView(
                          message: state.message,
                          onRetry: financeCubit.refresh,
                        ),
                      ],
                    );
                  }

                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: 180.h),
                      const Center(child: CircularProgressIndicator()),
                    ],
                  );
                }

                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 96.h),
                  children: [
                    BalanceHeroCard(snapshot: snapshot),
                    SummaryCardsRow(snapshot: snapshot),
                    SizedBox(height: 12.h),
                    CategoryChartSection(
                      breakdown: snapshot.categoryBreakdown,
                      currencySymbol: snapshot.currencySymbol,
                      onSeeAll: () {
                        context.parentContext.showAppBottomSheet(
                          title: 'Category Breakdown',
                          isScrollControlled: true,
                          customWidget: _BreakdownSheet(snapshot: snapshot),
                        );
                      },
                    ),
                    RecentTransactionsSection(
                      snapshot: snapshot,
                      currencySymbol: snapshot.currencySymbol,
                      onSeeAll: () {
                        context.parentContext.showAppBottomSheet(
                          title: 'Recent Transactions',
                          isScrollControlled: true,
                          customWidget: _TransactionsSheet(snapshot: snapshot),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _HomeFailureView extends StatelessWidget {
  const _HomeFailureView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 56.r,
            color: cs.error,
          ),
          SizedBox(height: 16.h),
          AppTextHeadlineSm(
            'Could not load dashboard',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          AppTextBodyMd(
            message,
            textAlign: TextAlign.center,
            color: cs.onSurfaceVariant,
          ),
          SizedBox(height: 20.h),
          FilledButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _TransactionsSheet extends StatelessWidget {
  const _TransactionsSheet({required this.snapshot});

  final FinanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.65.sh,
      child: ListView.builder(
        itemCount: snapshot.recentTransactions.length,
        itemBuilder: (context, index) {
          final transaction = snapshot.recentTransactions[index];
          return TransactionTile(
            transaction: transaction,
            currencySymbol: snapshot.currencySymbol,
          );
        },
      ),
    );
  }
}

class _BreakdownSheet extends StatelessWidget {
  const _BreakdownSheet({required this.snapshot});

  final FinanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    if (snapshot.categoryBreakdown.isEmpty) {
      return SizedBox(
        height: 0.3.sh,
        child: Center(
          child: AppTextBodyMd(
            'No category data yet',
            color: cs.onSurfaceVariant,
          ),
        ),
      );
    }

    return SizedBox(
      height: 0.65.sh,
      child: ListView.separated(
        itemCount: snapshot.categoryBreakdown.length,
        separatorBuilder: (context, index) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          final item = snapshot.categoryBreakdown[index];
          return _BreakdownTile(
            item: item,
            currencySymbol: snapshot.currencySymbol,
          );
        },
      ),
    );
  }
}

class _BreakdownTile extends StatelessWidget {
  const _BreakdownTile({
    required this.item,
    required this.currencySymbol,
  });

  final FinanceCategoryBreakdown item;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundColor: Color(item.color).withAlpha(36),
            child: AppIcon(
              item.icon,
              color: Color(item.color),
              size: 18.r,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextBodyLg(
                  item.title,
                  style: context.theme.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 6.h),
                LinearProgressIndicator(
                  value: item.percentage.clamp(0.0, 1.0),
                  minHeight: 6.h,
                  borderRadius: BorderRadius.circular(99.r),
                  color: Color(item.color),
                  backgroundColor: cs.surfaceContainerLow,
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppTextBodyMd(
                '${(item.percentage * 100).toStringAsFixed(0)}%',
                style: context.theme.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppTextLabelSm(
                '$currencySymbol${item.amount.toStringAsFixed(0)}',
                color: cs.onSurfaceVariant,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
