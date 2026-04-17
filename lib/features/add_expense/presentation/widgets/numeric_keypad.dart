import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_cubit.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_state.dart';

class NumericKeypad extends StatelessWidget {
  const NumericKeypad({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            childAspectRatio: 1.5,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: [
              ...['1', '2', '3', '4', '5', '6', '7', '8', '9', '.', '0']
                  .map((val) => _keyButton(val)),
              _keyButton('backspace', isIcon: true),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2B8CEE),
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Save Expense',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, color: Colors.white, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _keyButton(String val, {bool isIcon = false}) {
    return BlocBuilder<AddExpenseCubit, AddExpenseState>(
      builder: (context, state) {
        return Material(
          color: Colors.transparent,
          child: IconButton(
            onPressed: () => context.read<AddExpenseCubit>().keyPressed(val),
            icon: Center(
              child: isIcon
                  ? const Icon(Icons.backspace_outlined, size: 24)
                  : Text(
                      val,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
