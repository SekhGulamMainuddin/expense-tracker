import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/home/presentation/cubit/finance_cubit.dart';
import 'package:expense_tracker/features/home/presentation/cubit/finance_state.dart';
import 'package:expense_tracker/features/home/presentation/widgets/balance_hero_card.dart';
import 'package:expense_tracker/features/home/presentation/widgets/summary_cards_row.dart';
import 'package:expense_tracker/features/home/presentation/widgets/category_chart_section.dart';
import 'package:expense_tracker/features/home/presentation/widgets/recent_transactions_section.dart';
import 'package:go_router/go_router.dart';

import '../../../profile/presentation/screens/profile_screen.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_texts.dart';
import '../../../../core/utils/ui_extensions.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return BlocProvider(
      create: (_) => FinanceCubit(),
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: GestureDetector(
              onTap: () => context.push(ProfileScreen.routeName),
              child: CircleAvatar(
                backgroundColor: cs.surfaceContainerHigh,
                child: Icon(Icons.person, color: cs.onSurfaceVariant, size: 20.r),
              ),
            ),
          ),
          title: const AppTextTitleMd('My Finances'),
        ),
        body: BlocBuilder<FinanceCubit, FinanceState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 40.h),
              child: Column(
                children: [
                  BalanceHeroCard(state: state),
                  const SummaryCardsRow(),
                  const CategoryChartSection(),
                  RecentTransactionsSection(state: state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
