import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/home/presentation/cubit/finance_cubit.dart';
import 'package:expense_tracker/features/home/presentation/cubit/finance_state.dart';
import 'package:expense_tracker/features/home/presentation/widgets/balance_hero_card.dart';
import 'package:expense_tracker/features/home/presentation/widgets/summary_cards_row.dart';
import 'package:expense_tracker/features/home/presentation/widgets/category_chart_section.dart';
import 'package:expense_tracker/features/home/presentation/widgets/recent_transactions_section.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../profile/presentation/screens/profile_screen.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FinanceCubit(),
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: GestureDetector(
              onTap: () => context.push(ProfileScreen.routeName),
              child: CircleAvatar(
                backgroundColor: Colors.grey[200],
                child: Icon(Icons.person, color: Colors.grey, size: 20.r),
              ),
            ),
          ),
          title: Text(
            'My Finances',
            style: GoogleFonts.manrope(
              fontWeight: FontWeight.w800,
              fontSize: 18.sp,
            ),
          ),
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
