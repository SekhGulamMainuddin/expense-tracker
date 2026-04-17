import 'package:flutter/material.dart';

class SummaryCardsRow extends StatelessWidget {
  const SummaryCardsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _summaryItem('Daily', '\$42.50', '-5%', Colors.red),
          const SizedBox(width: 12),
          _summaryItem('Weekly', '\$310.20', '+2%', const Color(0xFF10B981)),
          const SizedBox(width: 12),
          _summaryItem('Monthly', '\$1,240', '-1%', Colors.red),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, String value, String percent, Color pColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              percent,
              style: TextStyle(
                color: pColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
