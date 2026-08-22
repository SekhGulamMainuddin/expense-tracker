import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/core/di/cubit_scope.dart';
import 'package:expense_tracker/core/di/service_locator.dart';
import 'package:expense_tracker/core/styles/app_texts.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:expense_tracker/core/widgets/app_icon.dart';
import 'package:expense_tracker/features/home/presentation/widgets/transaction_tile.dart';
import 'package:expense_tracker/features/settings/domain/entities/settings_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../cubit/transaction_list_cubit.dart';
import '../cubit/transaction_list_state.dart';

class TransactionListScreen extends StatefulWidget {
  static const routeName = '/transactions';

  const TransactionListScreen({super.key});

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  String? _scopeName;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  /// Resolved from the screen's GetIt scope, never passed down a constructor.
  TransactionListCubit get _cubit => getIt<TransactionListCubit>();

  @override
  void initState() {
    super.initState();
    _scopeName = CubitScope.open<TransactionListCubit>(
      scopeName: 'transaction_list_scope',
      create: () => TransactionListCubit(getIt()),
    );
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    CubitScope.close(_scopeName);
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) _cubit.loadMore();
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    return _scrollController.offset >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final cubit = _cubit;

    return Scaffold(
      appBar: AppBar(
        title: const AppTextTitleMd('transactions.title'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: BlocConsumer<TransactionListCubit, TransactionListState>(
        bloc: cubit,
        listenWhen: (previous, current) =>
            current.errorMessage != null &&
            previous.errorMessage != current.errorMessage,
        listener: (context, state) =>
            context.showAppSnackBar(state.errorMessage!),
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SearchField(
                controller: _searchController,
                onChanged: cubit.search,
              ),
              _ActiveFiltersRow(state: state),
              Expanded(child: _buildList(context, state, theme)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    TransactionListState state,
    ThemeData theme,
  ) {
    if (state.isLoading && state.transactions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 64.r,
              color: theme.colorScheme.outline,
            ),
            SizedBox(height: 16.h),
            const AppTextHeadlineSm('transactions.none_found'),
            SizedBox(height: 8.h),
            const AppTextBodyMd('transactions.adjust_filters'),
            SizedBox(height: 24.h),
            TextButton(
              onPressed: _cubit.resetFilters,
              child: const AppTextLabelMd('transactions.clear_filters'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      itemCount: state.hasMore
          ? state.transactions.length + 1
          : state.transactions.length,
      itemBuilder: (context, index) {
        if (index >= state.transactions.length) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final transaction = state.transactions[index];
        return Dismissible(
          key: ValueKey(transaction.id),
          direction: DismissDirection.endToStart,
          confirmDismiss: (_) => _confirmDelete(context),
          onDismissed: (_) async {
            final deleted = await _cubit.deleteTransaction(transaction.id);
            if (deleted && context.mounted) {
              context.showAppSnackBar('transactions.deleted');
            }
          },
          background: _DismissBackground(color: theme.colorScheme.error),
          child: TransactionTile(
            transaction: transaction,
            currencySymbol: state.currencySymbol,
          ),
        );
      },
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final theme = context.theme;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: AppTextHeadlineSm('add_expense.delete_title'),
        content: AppTextBodyMd('add_expense.delete_desc'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: AppTextLabelMd('common.cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: AppTextLabelMd(
              'common.delete',
              color: theme.colorScheme.error,
            ),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: context.theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder: (_) => const _FilterBottomSheet(),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 0),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: context.tr('transactions.search_hint'),
          prefixIcon: Icon(Icons.search, size: 20.r),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: Icon(Icons.close, size: 18.r),
                onPressed: () {
                  controller.clear();
                  onChanged('');
                },
              );
            },
          ),
          filled: true,
          fillColor: cs.surfaceContainer,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _DismissBackground extends StatelessWidget {
  const _DismissBackground({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(Icons.delete_outline, color: color, size: 24.r),
    );
  }
}

class _ActiveFiltersRow extends StatelessWidget {
  const _ActiveFiltersRow({required this.state});

  final TransactionListState state;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      child: Row(
        children: [
          FilterChip(
            label: Text(context.tr(_dateFilterKey(state.dateFilter))),
            selected: true,
            onSelected: (_) {},
            backgroundColor: theme.colorScheme.primaryContainer,
            labelStyle: TextStyle(color: theme.colorScheme.onPrimaryContainer),
          ),
          SizedBox(width: 8.w),
          if (state.transactions.isNotEmpty) ...[
            Chip(
              avatar: Icon(Icons.functions, size: 14.r),
              label: Text(
                '${state.currencySymbol}${state.total.toStringAsFixed(2)}'
                '${state.hasMore ? '+' : ''}',
              ),
              backgroundColor: theme.colorScheme.surfaceContainerHigh,
            ),
            SizedBox(width: 8.w),
          ],
          ...state.selectedCategoryIds.map((id) {
            final cat = _findCategory(state.categories, id);
            if (cat == null) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: Chip(
                label: Text(cat.title),
                onDeleted: () => getIt<TransactionListCubit>().toggleCategory(id),
                deleteIcon: const Icon(Icons.close, size: 14),
              ),
            );
          }),
        ],
      ),
    );
  }

  SettingsCategory? _findCategory(List<SettingsCategory> categories, int id) {
    for (final cat in categories) {
      if (cat.id == id) return cat;
      final found = _findCategory(cat.children, id);
      if (found != null) return found;
    }
    return null;
  }
}

String _dateFilterKey(DateFilterType type) {
  return switch (type) {
    DateFilterType.today => 'transactions.filter_today',
    DateFilterType.last7Days => 'transactions.filter_7_days',
    DateFilterType.last30Days => 'transactions.filter_30_days',
    DateFilterType.custom => 'transactions.filter_custom',
  };
}

class _FilterBottomSheet extends StatelessWidget {
  const _FilterBottomSheet();

  @override
  Widget build(BuildContext context) {
    final cubit = getIt<TransactionListCubit>();
    return BlocBuilder<TransactionListCubit, TransactionListState>(
      bloc: cubit,
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppTextHeadlineSm('transactions.filter_title'),
                  TextButton(
                    onPressed: () {
                      cubit.resetFilters();
                      context.pop();
                    },
                    child: const AppTextLabelMd('transactions.reset'),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              const AppTextLabelMd('transactions.date_range', uppercase: true),
              SizedBox(height: 12.h),
              Wrap(
                spacing: 8.w,
                children: DateFilterType.values.map((type) {
                  return ChoiceChip(
                    label: Text(context.tr(_dateFilterKey(type))),
                    selected: state.dateFilter == type,
                    onSelected: (selected) async {
                      if (!selected) return;
                      if (type != DateFilterType.custom) {
                        cubit.setDateFilter(type);
                        return;
                      }
                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        cubit.setDateFilter(
                          type,
                          start: picked.start,
                          end: picked.end,
                        );
                      }
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 32.h),
              const AppTextLabelMd('transactions.categories', uppercase: true),
              SizedBox(height: 12.h),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.categories.length,
                  itemBuilder: (context, index) {
                    return _CategoryFilterTile(
                      category: state.categories[index],
                      selectedIds: state.selectedCategoryIds,
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => context.pop(),
                    child: const AppTextLabelMd('transactions.apply_filters'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CategoryFilterTile extends StatefulWidget {
  const _CategoryFilterTile({
    required this.category,
    required this.selectedIds,
  });

  final SettingsCategory category;
  final Set<int> selectedIds;

  @override
  State<_CategoryFilterTile> createState() => _CategoryFilterTileState();
}

class _CategoryFilterTileState extends State<_CategoryFilterTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final cubit = getIt<TransactionListCubit>();
    final hasChildren = widget.category.children.isNotEmpty;

    final allIds = [
      widget.category.id,
      ...widget.category.children.map((c) => c.id),
    ];
    final selectedCount =
        allIds.where((id) => widget.selectedIds.contains(id)).length;

    // null renders the indeterminate dash for a partial selection.
    final bool? triValue = selectedCount == allIds.length
        ? true
        : selectedCount == 0
            ? false
            : null;

    return Column(
      children: [
        ListTile(
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: triValue,
                tristate: true,
                onChanged: (_) =>
                    cubit.toggleParentGroup(widget.category),
              ),
              SizedBox(width: 8.w),
              AppIcon(
                widget.category.icon,
                color: Color(widget.category.color),
                size: 20.r,
              ),
            ],
          ),
          title: Text(widget.category.title),
          dense: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          contentPadding: EdgeInsets.zero,
          trailing: hasChildren
              ? IconButton(
                  icon: Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                  ),
                  onPressed: () => setState(() => _isExpanded = !_isExpanded),
                )
              : null,
          onTap: hasChildren
              ? () => setState(() => _isExpanded = !_isExpanded)
              : () => cubit.toggleParentGroup(widget.category),
        ),
        if (hasChildren && _isExpanded)
          Padding(
            padding: EdgeInsets.only(left: 32.w),
            child: Column(
              children: widget.category.children.map<Widget>((child) {
                return ListTile(
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: widget.selectedIds.contains(child.id),
                        onChanged: (_) => cubit.toggleCategory(child.id),
                      ),
                      SizedBox(width: 8.w),
                      AppIcon(
                        child.icon,
                        color: Color(child.color),
                        size: 18.r,
                      ),
                    ],
                  ),
                  title: Text(child.title),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  onTap: () => cubit.toggleCategory(child.id),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
