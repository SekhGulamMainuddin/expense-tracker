import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_cubit.dart';
import 'package:expense_tracker/features/add_expense/presentation/widgets/amount_display.dart';
import 'package:expense_tracker/features/add_expense/presentation/widgets/category_selector.dart';
import 'package:expense_tracker/features/add_expense/presentation/widgets/sub_category_selector.dart';
import 'package:expense_tracker/features/add_expense/presentation/widgets/numeric_keypad.dart';

class AddExpenseScreen extends StatelessWidget {
  static const routeName = '/add-expense';

  const AddExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddExpenseCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7F8),
        appBar: _buildAppBar(context),
        body: const Column(
          children: [
            AmountDisplay(),
            CategorySelector(),
            SubCategorySelector(),
          ],
        ),
        bottomNavigationBar: NumericKeypad(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close, color: Colors.grey),
        onPressed: () => context.pop(),
      ),
      title: Text(
        'Add Expense',
        style: GoogleFonts.manrope(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.check, color: Color(0xFF2B8CEE)),
          onPressed: () {},
        ),
      ],
    );
  }
}
