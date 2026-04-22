import 'package:expense_tracker/core/di/service_locator.dart';
import 'package:expense_tracker/core/styles/app_texts.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_cubit.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_state.dart';
import 'package:expense_tracker/features/add_expense/presentation/widgets/amount_display.dart';
import 'package:expense_tracker/features/add_expense/presentation/widgets/category_selector.dart';
import 'package:expense_tracker/features/add_expense/presentation/widgets/numeric_keypad.dart';
import 'package:expense_tracker/features/add_expense/presentation/widgets/sub_category_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AddExpenseScreen extends StatefulWidget {
  static const routeName = '/add-expense';

  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  late final AddExpenseCubit _cubit;
  late final TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<AddExpenseCubit>();
    _titleController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return BlocConsumer<AddExpenseCubit, AddExpenseState>(
      bloc: _cubit,
      listener: (context, state) {
        if (state is AddExpenseLoaded) {
          if (_titleController.text != state.title) {
            _titleController.text = state.title;
          }
          if (state.errorMessage != null) {
            context.showAppSnackBar(state.errorMessage!);
          }
        } else if (state is AddExpenseFailure) {
          context.showAppSnackBar(state.message);
        } else if (state is AddExpenseSuccess) {
          context.pop(true);
        }
      },
      builder: (context, state) {
        final isLoading = state is AddExpenseLoading;
        final isFailure = state is AddExpenseFailure;
        final failureMessage =
            state is AddExpenseFailure ? state.message : null;
        final loaded = state is AddExpenseLoaded ? state : null;
        final canSubmit = loaded != null && !loaded.isSubmitting;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.close,
                color: theme.colorScheme.onSurfaceVariant,
                size: 24.r,
              ),
              onPressed: () => context.pop(false),
            ),
            title: const AppTextHeadlineSm('Add Expense'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: loaded?.isSubmitting == true
                    ? SizedBox(
                        width: 18.r,
                        height: 18.r,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: theme.colorScheme.primary,
                        ),
                      )
                    : Icon(
                        Icons.check,
                        color: theme.colorScheme.primary,
                        size: 24.r,
                      ),
                onPressed: canSubmit ? () => _cubit.submitExpense() : null,
              ),
            ],
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : isFailure
                  ? _LoadFailureView(
                      message: failureMessage!,
                      onRetry: _cubit.loadFormData,
                    )
                  : loaded == null
                      ? const SizedBox.shrink()
                      : Column(
                          children: [
                            Expanded(
                              child: ListView(
                                padding: EdgeInsets.fromLTRB(
                                  20.w,
                                  12.h,
                                  20.w,
                                  20.h,
                                ),
                                children: [
                                  AmountDisplay(cubit: _cubit),
                                  _ExpenseSummaryCard(state: loaded),
                                  SizedBox(height: 20.h),
                                  _ExpenseTitleField(
                                    controller: _titleController,
                                    cubit: _cubit,
                                    enabled: !loaded.isSubmitting,
                                  ),
                                  SizedBox(height: 20.h),
                                  _ExpenseDateTile(
                                    date: loaded.date,
                                    onTap: loaded.isSubmitting
                                        ? null
                                        : () async {
                                            final picked = await showDatePicker(
                                              context: context,
                                              initialDate: loaded.date,
                                              firstDate: DateTime(2020),
                                              lastDate: DateTime(2100),
                                            );
                                            if (picked != null) {
                                              _cubit.selectDate(picked);
                                            }
                                          },
                                  ),
                                  SizedBox(height: 24.h),
                                  CategorySelector(cubit: _cubit),
                                  SizedBox(height: 18.h),
                                  SubCategorySelector(cubit: _cubit),
                                  SizedBox(height: 24.h),
                                  _FormHint(
                                    text:
                                        'Use the keypad below to enter the amount and tap the checkmark when you are ready to save.',
                                  ),
                                ],
                              ),
                            ),
                            NumericKeypad(cubit: _cubit),
                          ],
                        ),
        );
      },
    );
  }
}

class _ExpenseTitleField extends StatelessWidget {
  const _ExpenseTitleField({
    required this.controller,
    required this.cubit,
    required this.enabled,
  });

  final TextEditingController controller;
  final AddExpenseCubit cubit;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
          child: AppTextLabelMd(
            'Expense Title',
            uppercase: true,
            color: cs.onSurfaceVariant,
          ),
        ),
        TextField(
          controller: controller,
          enabled: enabled,
          textCapitalization: TextCapitalization.sentences,
          onChanged: cubit.updateTitle,
          decoration: InputDecoration(
            hintText: 'Lunch, cab, internet bill, etc.',
            filled: true,
            fillColor: cs.surfaceContainerLow,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide.none,
            ),
            prefixIcon: Icon(Icons.edit_note, color: cs.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}

class _ExpenseDateTile extends StatelessWidget {
  const _ExpenseDateTile({
    required this.date,
    required this.onTap,
  });

  final DateTime date;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final formatted = '${monthName(date.month)} ${date.day}, ${date.year}';

    return Material(
      color: cs.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Row(
            children: [
              Icon(Icons.calendar_month, color: cs.primary),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextLabelMd(
                      'Expense Date',
                      uppercase: true,
                      color: cs.onSurfaceVariant,
                    ),
                    SizedBox(height: 4.h),
                    AppTextBodyLg(
                      formatted,
                      style: context.theme.textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }

}

class _ExpenseSummaryCard extends StatelessWidget {
  const _ExpenseSummaryCard({required this.state});

  final AddExpenseLoaded state;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final category = state.selectedCategory;
    final subcategory = state.selectedSubcategory;
    final categoryColor = category == null ? cs.primary : Color(category.color);

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            categoryColor.withValues(alpha: 0.16),
            cs.surfaceContainerLow,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: categoryColor.withValues(alpha: 0.16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.receipt_long,
                  size: 18.r,
                  color: categoryColor,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextHeadlineSm('Saving to'),
                    SizedBox(height: 4.h),
                    AppTextBodyMd(
                      'Confirm your category, subcategory, and date before saving.',
                      color: cs.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: [
              _SummaryChip(
                icon: Icons.category_outlined,
                label: category?.title ?? 'Category',
                backgroundColor: categoryColor.withValues(alpha: 0.14),
                foregroundColor: categoryColor,
              ),
              _SummaryChip(
                icon: Icons.subdirectory_arrow_right,
                label: subcategory?.title ?? 'No subcategory',
                backgroundColor: cs.surfaceContainerHigh,
                foregroundColor: cs.onSurfaceVariant,
              ),
              _SummaryChip(
                icon: Icons.calendar_month,
                label: '${monthName(state.date.month)} ${state.date.day}',
                backgroundColor: cs.surfaceContainerHigh,
                foregroundColor: cs.onSurfaceVariant,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String monthName(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return months[month - 1];
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.r, color: foregroundColor),
          SizedBox(width: 8.w),
          AppTextLabelSm(
            label,
            color: foregroundColor,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}

class _FormHint extends StatelessWidget {
  const _FormHint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withValues(alpha: 0.38),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: AppTextBodyMd(
        text,
        color: cs.onSurfaceVariant,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _LoadFailureView extends StatelessWidget {
  const _LoadFailureView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 56.r,
              color: cs.onSurfaceVariant,
            ),
            SizedBox(height: 16.h),
            AppTextHeadlineSm(
              'Could not load expense form',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            AppTextBodyMd(
              message,
              textAlign: TextAlign.center,
              color: cs.onSurfaceVariant,
            ),
            SizedBox(height: 20.h),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
