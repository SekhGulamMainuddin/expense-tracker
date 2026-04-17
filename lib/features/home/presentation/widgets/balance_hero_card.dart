import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expense_tracker/features/home/presentation/cubit/finance_state.dart';

class BalanceHeroCard extends StatelessWidget {
  const BalanceHeroCard({super.key, required this.state});

  final FinanceState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF2B8CEE),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2B8CEE).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Balance',
            style: GoogleFonts.manrope(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${state.balance.toStringAsFixed(2)}',
            style: GoogleFonts.manrope(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _badge(Icons.arrow_upward, '\$${state.income.toStringAsFixed(2)}'),
              const SizedBox(width: 12),
              _badge(Icons.arrow_downward, '\$${state.expenses.toStringAsFixed(2)}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _badge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}
