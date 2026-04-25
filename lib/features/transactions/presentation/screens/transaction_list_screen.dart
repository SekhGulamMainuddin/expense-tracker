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

class TransactionListScreen extends StatelessWidget {
  static const routeName = '/transactions';

  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionListCubit(getIt(), getIt()),
      child: const _TransactionListContent(),
    );
  }
}

class _TransactionListContent extends StatelessWidget {
  const _TransactionListContent();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final cubit = context.read<TransactionListCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const AppTextTitleMd('Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context, cubit),
          ),
        ],
      ),
      body: BlocBuilder<TransactionListCubit, TransactionListState>(
        builder: (context, state) {
          if (state.isLoading && state.transactions.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.transactions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 64.r, color: theme.colorScheme.outline),
                  SizedBox(height: 16.h),
                  const AppTextHeadlineSm('No transactions found'),
                  SizedBox(height: 8.h),
                  const AppTextBodyMd('Try adjusting your filters'),
                  SizedBox(height: 24.h),
                  TextButton(
                    onPressed: cubit.clearCategories,
                    child: const Text('Clear All Filters'),
                  ),
                ],
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ActiveFiltersRow(state: state, cubit: cubit),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                  itemCount: state.transactions.length,
                  itemBuilder: (context, index) {
                    return TransactionTile(
                      transaction: state.transactions[index],
                      currencySymbol: state.currencySymbol,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showFilterSheet(BuildContext context, TransactionListCubit cubit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: context.theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const _FilterBottomSheet(),
      ),
    );
  }
}

class _ActiveFiltersRow extends StatelessWidget {
  const _ActiveFiltersRow({required this.state, required this.cubit});

  final TransactionListState state;
  final TransactionListCubit cubit;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      child: Row(
        children: [
          FilterChip(
            label: Text(_getDateFilterLabel(state)),
            selected: true,
            onSelected: (_) {},
            backgroundColor: theme.colorScheme.primaryContainer,
            labelStyle: TextStyle(color: theme.colorScheme.onPrimaryContainer),
          ),
          SizedBox(width: 8.w),
          if (state.selectedCategoryIds.isNotEmpty)
            ...state.selectedCategoryIds.map((id) {
              final cat = _findCategory(state.categories, id);
              if (cat == null) return const SizedBox.shrink();
              return Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: Chip(
                  label: Text(cat.title),
                  onDeleted: () => cubit.toggleCategory(id),
                  deleteIcon: const Icon(Icons.close, size: 14),
                ),
              );
            }),
        ],
      ),
    );
  }

  String _getDateFilterLabel(TransactionListState state) {
    return switch (state.dateFilter) {
      DateFilterType.today => 'Today',
      DateFilterType.last7Days => 'Last 7 Days',
      DateFilterType.last30Days => 'Last 30 Days',
      DateFilterType.custom => 'Custom Range',
    };
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

class _FilterBottomSheet extends StatelessWidget {
  const _FilterBottomSheet();

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<TransactionListCubit>();
    final state = cubit.state;
    final theme = context.theme;

    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppTextHeadlineSm('Filter Transactions'),
              TextButton(
                onPressed: () {
                  cubit.clearCategories();
                  context.pop();
                },
                child: const Text('Reset'),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          const AppTextLabelMd('DATE RANGE', uppercase: true),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            children: DateFilterType.values.map((type) {
              final isSelected = state.dateFilter == type;
              return ChoiceChip(
                label: Text(_getDateLabel(type)),
                selected: isSelected,
                onSelected: (selected) async {
                  if (selected) {
                    if (type == DateFilterType.custom) {
                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        cubit.setDateFilter(type, start: picked.start, end: picked.end);
                      }
                    } else {
                      cubit.setDateFilter(type);
                    }
                  }
                },
              );
            }).toList(),
          ),
          SizedBox(height: 32.h),
          const AppTextLabelMd('CATEGORIES', uppercase: true),
          SizedBox(height: 12.h),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final category = state.categories[index];
                return _CategoryFilterTile(
                  category: category,
                  selectedIds: state.selectedCategoryIds,
                  onToggle: cubit.toggleCategory,
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
                child: const Text('Apply Filters'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getDateLabel(DateFilterType type) {
    return switch (type) {
      DateFilterType.today => 'Today',
      DateFilterType.last7Days => '7 Days',
      DateFilterType.last30Days => '30 Days',
      DateFilterType.custom => 'Custom',
    };
  }
}

class _CategoryFilterTile extends StatefulWidget {
  const _CategoryFilterTile({
    required this.category,
    required this.selectedIds,
    required this.onToggle,
  });

  final SettingsCategory category;
  final Set<int> selectedIds;
  final Function(int) onToggle;

  @override
  State<_CategoryFilterTile> createState() => _CategoryFilterTileState();
}

class _CategoryFilterTileState extends State<_CategoryFilterTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TransactionListCubit>();
    final hasChildren = widget.category.children.isNotEmpty;
    
    // Calculate tristate value
    final allIds = [widget.category.id, ...widget.category.children.map((c) => c.id)];
    final selectedCount = allIds.where((id) => widget.selectedIds.contains(id)).length;
    
    bool? triValue;
    if (selectedCount == allIds.length) {
      triValue = true;
    } else if (selectedCount == 0) {
      triValue = false;
    } else {
      triValue = null; // Indeterminate
    }

    return Column(
      children: [
        ListTile(
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: triValue,
                tristate: true,
                onChanged: (_) => cubit.toggleParentGroup(widget.category),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          contentPadding: EdgeInsets.zero,
          trailing: hasChildren ? IconButton(
            icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
            onPressed: () => setState(() => _isExpanded = !_isExpanded),
          ) : null,
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
                        onChanged: (_) => widget.onToggle(child.id),
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
                  onTap: () => widget.onToggle(child.id),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
