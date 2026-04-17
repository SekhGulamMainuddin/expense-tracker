import 'package:flutter/material.dart';
import 'package:expense_tracker/features/home/presentation/cubit/finance_state.dart';
import 'package:expense_tracker/features/home/presentation/widgets/transaction_tile.dart';

class RecentTransactionsSection extends StatelessWidget {
  const RecentTransactionsSection({super.key, required this.state});

  final FinanceState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Payments',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                'See All',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...state.transactions
              .map((tx) => TransactionTile(transaction: tx))
              .toList(),
        ],
      ),
    );
  }
}
