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

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FinanceCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7F8),
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => context.push(ProfileScreen.routeName),
            child: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: const Icon(Icons.person, color: Colors.grey),
            ),
          ),
          title: Text(
            'My Finances',
            style: GoogleFonts.manrope(
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
        ),
        body: BlocBuilder<FinanceCubit, FinanceState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 40),
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
