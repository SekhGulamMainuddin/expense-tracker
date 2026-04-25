import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/core/di/service_locator.dart';
import 'package:expense_tracker/core/styles/app_texts.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_cubit.dart';
import 'package:expense_tracker/features/add_expense/presentation/cubit/add_expense_state.dart';
import 'package:expense_tracker/features/add_expense/presentation/widgets/amount_display.dart';
import 'package:expense_tracker/features/add_expense/presentation/widgets/category_selector.dart';
import 'package:expense_tracker/features/add_expense/presentation/widgets/sub_category_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AddExpenseArgs {
  const AddExpenseArgs({
    this.transactionId,
    this.mode,
  });

  final int? transactionId;
  final AddExpenseMode? mode;
}

class AddExpenseScreen extends StatefulWidget {
  static const routeName = '/add-expense';

  const AddExpenseScreen({
    super.key,
    this.transactionId,
    this.mode,
  });

  final int? transactionId;
  final AddExpenseMode? mode;

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  late final AddExpenseCubit _cubit;
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<AddExpenseCubit>();
    _titleController = TextEditingController();
    _amountController = TextEditingController(text: '0');
    _cubit.loadFormData(
      transactionId: widget.transactionId,
      mode: widget.mode,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
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
          final effectiveTitle = state.title ?? '';
          if (_titleController.text != effectiveTitle) {
            _titleController.value = TextEditingValue(
              text: effectiveTitle,
              selection: TextSelection.collapsed(offset: effectiveTitle.length),
            );
          }
          if (_amountController.text != state.amount) {
            _amountController.value = TextEditingValue(
              text: state.amount,
              selection: TextSelection.collapsed(offset: state.amount.length),
            );
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
        final isViewMode = loaded?.mode == AddExpenseMode.view;
        final canSubmit = loaded != null && !loaded.isSubmitting && !isViewMode;

        String appBarTitle = 'add_expense.title_label';
        if (loaded != null) {
          appBarTitle = switch (loaded.mode) {
            AddExpenseMode.create => 'add_expense.title_label',
            AddExpenseMode.view => 'View Expense',
            AddExpenseMode.edit => 'Edit Expense',
          };
        }

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
            title: AppTextHeadlineSm(appBarTitle),
            centerTitle: true,
            actions: [
              if (isViewMode)
                IconButton(
                  icon: Icon(Icons.edit_outlined, color: theme.colorScheme.primary),
                  onPressed: () => _cubit.setMode(AddExpenseMode.edit),
                )
              else
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
                      onRetry: () => _cubit.loadFormData(
                        transactionId: widget.transactionId,
                        mode: widget.mode,
                      ),
                    )
                  : loaded == null
                      ? const SizedBox.shrink()
                      : SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.fromLTRB(
                            20.w,
                            12.h,
                            20.w,
                            20.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AmountDisplay(
                                cubit: _cubit,
                                controller: _amountController,
                                enabled: !loaded.isSubmitting && !isViewMode,
                              ),
                              _ExpenseSummaryCard(state: loaded),
                              SizedBox(height: 20.h),
                              _ExpenseTitleField(
                                controller: _titleController,
                                cubit: _cubit,
                                enabled: !loaded.isSubmitting && !isViewMode,
                              ),
                              if ((loaded.title == null || loaded.title!.isEmpty) && loaded.generatedTitle != null) ...[
                                SizedBox(height: 8.h),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.info_outline, size: 16.r, color: Colors.orange[800]),
                                      SizedBox(width: 8.w),
                                      Expanded(
                                        child: Text(
                                          'Title was not provided, using "${loaded.generatedTitle}" as default.',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.orange[900],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              SizedBox(height: 20.h),
                              _ExpenseDateTile(
                                date: loaded.date,
                                onTap: (loaded.isSubmitting || isViewMode)
                                    ? null
                                    : () async {
                                        final picked = await showDatePicker(
                                          context: context,
                                          initialDate: loaded.date,
                                          firstDate: DateTime.now().subtract(const Duration(days: 365)),
                                          lastDate: DateTime.now().add(const Duration(days: 365)),
                                        );
                                        if (picked != null) {
                                          _cubit.selectDate(picked);
                                        }
                                      },
                              ),
                              SizedBox(height: 24.h),
                              CategorySelector(
                                rootCategories: loaded.rootCategories,
                                selectedCategoryId: loaded.selectedCategoryId,
                                onCategorySelected: (loaded.isSubmitting || isViewMode)
                                    ? null
                                    : _cubit.selectCategory,
                              ),
                              SizedBox(height: 18.h),
                              SubCategorySelector(
                                subcategories: loaded.subcategories,
                                selectedSubcategoryId:
                                    loaded.selectedSubcategoryId,
                                onSubcategorySelected: (loaded.isSubmitting || isViewMode)
                                    ? null
                                    : _cubit.selectSubcategory,
                              ),
                              150.verticalSpace
                            ],
                          ),
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
            'add_expense.title_label',
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
            hintText: context.tr('add_expense.title_hint'),
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
    final formatted = '${monthName(context, date.month)} ${date.day}, ${date.year}';

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
                      'add_expense.date_label',
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
    final subcategoryColor = subcategory == null ? cs.primary : Color(subcategory.color);

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
                    AppTextHeadlineSm('add_expense.saving_to'),
                    SizedBox(height: 4.h),
                    AppTextBodyMd(
                      'add_expense.summary_desc',
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
                label: category?.title ?? context.tr('add_expense.category'),
                backgroundColor: categoryColor.withValues(alpha: 0.14),
                foregroundColor: categoryColor,
              ),
              _SummaryChip(
                icon: Icons.subdirectory_arrow_right,
                label: subcategory?.title ?? context.tr('add_expense.no_subcategory'),
                backgroundColor: subcategoryColor.withValues(alpha: 0.14),
                foregroundColor: subcategoryColor,
              ),
              _SummaryChip(
                icon: Icons.calendar_month,
                label: '${monthName(context, state.date.month)} ${state.date.day}',
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

String monthName(BuildContext context, int month) {
  final keys = [
    'common.months.jan',
    'common.months.feb',
    'common.months.mar',
    'common.months.apr',
    'common.months.may',
    'common.months.jun',
    'common.months.jul',
    'common.months.aug',
    'common.months.sep',
    'common.months.oct',
    'common.months.nov',
    'common.months.dec',
  ];
  return context.tr(keys[month - 1]);
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
              'add_expense.error_load',
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
              child: const AppTextLabelMd('common.retry', uppercase: true),
            ),
          ],
        ),
      ),
    );
  }
}
