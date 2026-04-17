import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_cubit.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_state.dart';

class AmountDisplay extends StatelessWidget {
  const AmountDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddExpenseCubit, AddExpenseState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(
            children: [
              Text(
                'ENTER AMOUNT',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Colors.grey,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '\$',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2B8CEE),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    state.amount,
                    style: GoogleFonts.manrope(
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
