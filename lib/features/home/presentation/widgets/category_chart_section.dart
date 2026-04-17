import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryChartSection extends StatelessWidget {
  const CategoryChartSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Category Distribution',
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('View Details'),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: 0.7,
                    strokeWidth: 10,
                    color: Color(0xFF2B8CEE),
                    backgroundColor: Color(0xFFF1F5F9),
                  ),
                ),
                const SizedBox(width: 30),
                Expanded(
                  child: Column(
                    children: [
                      _chartLegend(const Color(0xFF2B8CEE), 'Housing', '45%'),
                      _chartLegend(const Color(0xFF10B981), 'Food', '30%'),
                      _chartLegend(Colors.orange, 'Transport', '25%'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chartLegend(Color color, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
