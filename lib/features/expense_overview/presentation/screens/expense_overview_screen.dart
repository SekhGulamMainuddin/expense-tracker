import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:expense_tracker/core/di/service_locator.dart';
import 'package:expense_tracker/core/styles/app_palette.dart';
import 'package:expense_tracker/core/styles/app_texts.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:expense_tracker/core/widgets/primary_button.dart';
import 'package:expense_tracker/features/expense_overview/presentation/cubit/expense_overview_cubit.dart';
import 'package:expense_tracker/features/expense_overview/presentation/widgets/expense_summary_card.dart';

class ExpenseOverviewScreen extends StatefulWidget {
  static const routeName = '/';

  const ExpenseOverviewScreen({super.key});

  @override
  State<ExpenseOverviewScreen> createState() => _ExpenseOverviewScreenState();
}

class _ExpenseOverviewScreenState extends State<ExpenseOverviewScreen> {
  final expenseOverviewCubit = getIt<ExpenseOverviewCubit>();

  @override
  void initState() {
    super.initState();
    expenseOverviewCubit.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: appTextB1('app.title')),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: BlocConsumer<ExpenseOverviewCubit, ExpenseOverviewState>(
          bloc: expenseOverviewCubit,
          listener: (context, state) {
            if (state is ExpenseOverviewLoadingState) {
              context.showLoadingOverlay();
            } else {
              context.hideLoadingOverlay();
            }

            if (state is ExpenseOverviewErrorState) {
              context.showAppSnackbar(state.message);
            }
          },
          builder: (context, state) {
            return switch (state) {
              ExpenseOverviewLoadingState() => const SizedBox.shrink(),
              ExpenseOverviewLoadedState(:final snapshot) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  appTextH1('overview.hero'),
                  8.verticalSpace,
                  appTextB2('overview.subtitle', color: AppPalette.textPrimary),
                  20.verticalSpace,
                  ExpenseSummaryCard(snapshot: snapshot),
                  20.verticalSpace,
                  PrimaryButton(
                    buttonText: 'overview.cta',
                    onPressed: () {
                      context.showAppBottomSheet(
                        title: 'overview.sheet_title',
                        customWidget: appTextB2('overview.sheet_body'),
                      );
                    },
                  ),
                ],
              ),
              ExpenseOverviewErrorState() => PrimaryButton(
                buttonText: 'common.retry',
                onPressed: expenseOverviewCubit.load,
              ),
            };
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    expenseOverviewCubit.close();
    super.dispose();
  }
}
