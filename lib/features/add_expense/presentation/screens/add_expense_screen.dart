import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_cubit.dart';
import 'package:expense_tracker/features/add_expense/presentation/widgets/amount_display.dart';
import 'package:expense_tracker/features/add_expense/presentation/widgets/category_selector.dart';
import 'package:expense_tracker/features/add_expense/presentation/widgets/sub_category_selector.dart';
import 'package:expense_tracker/features/add_expense/presentation/widgets/numeric_keypad.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_texts.dart';
import '../../../../core/utils/ui_extensions.dart';

class AddExpenseScreen extends StatelessWidget {
  static const routeName = '/add-expense';

  const AddExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddExpenseCubit(),
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: const Column(
          children: [
            AmountDisplay(),
            CategorySelector(),
            SubCategorySelector(),
          ],
        ),
        bottomNavigationBar: const NumericKeypad(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = context.theme;
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.close, color: theme.colorScheme.onSurfaceVariant, size: 24.r),
        onPressed: () => context.pop(),
      ),
      title: const AppTextHeadlineSm('Add Expense'),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.check, color: theme.colorScheme.primary, size: 24.r),
          onPressed: () {},
        ),
      ],
    );
  }
}
