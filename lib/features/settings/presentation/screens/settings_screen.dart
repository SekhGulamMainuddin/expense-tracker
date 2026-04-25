import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/core/di/service_locator.dart';
import 'package:expense_tracker/core/styles/app_texts.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:expense_tracker/features/settings/domain/entities/settings_category.dart';
import 'package:expense_tracker/features/settings/domain/entities/settings_snapshot.dart';
import 'package:expense_tracker/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:expense_tracker/features/settings/presentation/cubit/settings_state.dart';
import 'package:expense_tracker/features/settings/presentation/widgets/budget_section.dart';
import 'package:expense_tracker/features/settings/presentation/widgets/category_list.dart';
import 'package:expense_tracker/features/settings/presentation/screens/category_editor_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final settingsCubit = getIt<SettingsCubit>();

    return BlocConsumer<SettingsCubit, SettingsState>(
      bloc: settingsCubit,
      listener: (context, state) {
        if (state is SettingsFailure) {
          context.showAppSnackBar(state.errorMessage);
        }
      },
      builder: (context, state) {
        if (state is SettingsInitial || state is SettingsLoading) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => context.switchBottomNavTab(0),
                icon: Icon(
                  Icons.arrow_back,
                  color: theme.colorScheme.primary,
                  size: 24.r,
                ),
              ),
              title: const AppTextHeadlineSm('settings.title'),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is SettingsFailure) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => context.switchBottomNavTab(0),
                icon: Icon(
                  Icons.arrow_back,
                  color: theme.colorScheme.primary,
                  size: 24.r,
                ),
              ),
              title: const AppTextHeadlineSm('settings.title'),
            ),
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(24.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.settings_applications_outlined,
                      size: 56.r,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(height: 16.h),
                    AppTextHeadlineSm(
                      'settings.error_load',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    AppTextBodyMd(
                      state.errorMessage,
                      textAlign: TextAlign.center,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(height: 20.h),
                    FilledButton(
                      onPressed: () => settingsCubit.loadSettings(),
                      child: const AppTextLabelMd('common.retry', uppercase: true),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final snapshot = (state as SettingsLoaded).snapshot;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => context.switchBottomNavTab(0),
              icon: Icon(
                Icons.arrow_back,
                color: theme.colorScheme.primary,
                size: 24.r,
              ),
            ),
            title: const AppTextHeadlineSm('settings.title'),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 100.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle('settings.category_mgmt'),
                SizedBox(height: 16.h),
                CategoryList(
                  categories: snapshot.categories,
                  onAddCategory: () {
                    _showCategoryEditor(context);
                  },
                  onAddSubcategory: (SettingsCategory parentCategory) {
                    _showCategoryEditor(
                      context,
                      parentCategory: parentCategory,
                    );
                  },
                  onEditCategory: (category) {
                    _showCategoryEditor(
                      context,
                      initialCategory: category,
                    );
                  },
                  onDeleteCategory: (category) {
                    _showDeleteCategoryDialog(
                      context,
                      settingsCubit,
                      category,
                    );
                  },
                  onEditSubcategory: (category) {
                    _showCategoryEditor(
                      context,
                      initialCategory: category,
                    );
                  },
                  onDeleteSubcategory: (subcategoryId) {
                    final category = _findCategoryById(snapshot.categories, subcategoryId);
                    if (category != null) {
                      _showDeleteCategoryDialog(context, settingsCubit, category);
                    }
                  },
                ),
                SizedBox(height: 32.h),
                _sectionTitle('settings.budget_limits'),
                SizedBox(height: 16.h),
                BudgetSection(
                  snapshot: snapshot,
                  onDailyChanged: (value) {
                    settingsCubit.updateDailyLimit(value);
                  },
                  onWeeklyChanged: (value) {
                    settingsCubit.updateWeeklyLimit(value);
                  },
                  onMonthlyChanged: (value) {
                    settingsCubit.updateMonthlyLimit(value);
                  },
                  onSafeThresholdChanged: (value) {
                    settingsCubit.updateSafeThreshold(value);
                  },
                  onCautionThresholdChanged: (value) {
                    settingsCubit.updateCautionThreshold(value);
                  },
                  onDangerThresholdChanged: (value) {
                    settingsCubit.updateDangerThreshold(value);
                  },
                ),
                SizedBox(height: 32.h),
                _sectionTitle('settings.preferences'),
                SizedBox(height: 16.h),
                _preferencesTile(context, snapshot, settingsCubit),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sectionTitle(String text) {
    return AppTextHeadlineSm(text);
  }

  Future<void> _showCategoryEditor(
    BuildContext context,
    {
    SettingsCategory? parentCategory,
    SettingsCategory? initialCategory,
  }) async {
    await context.push<bool>(
      CategoryEditorScreen.routeName,
      extra: CategoryEditorArgs(
        parentCategory: parentCategory?.title,
        parentId: parentCategory?.id,
        initialCategory: initialCategory,
      ),
    );
  }

  void _showDeleteCategoryDialog(
    BuildContext context,
    SettingsCubit settingsCubit,
    SettingsCategory category,
  ) {
    final isRoot = category.parentId == null;
    context.showAppAlertDialog(
      dialogId: 'delete-category-${category.id}',
      title: isRoot ? 'settings.delete_title' : 'settings.delete_sub_title',
      subtitle: context.tr('settings.delete_desc', args: [category.title]),
      isDismissible: true,
      content: _DeleteCategoryDialogContent(
        category: category,
        onConfirm: () async {
          final success = await settingsCubit.deleteCategory(category.id);
          if (success && context.mounted) {
            context.closeAlertDialog(
              dialogId: 'delete-category-${category.id}',
            );
          }
        },
      ),
    );
  }

  SettingsCategory? _findCategoryById(
    List<SettingsCategory> categories,
    int id,
  ) {
    for (final category in categories) {
      if (category.id == id) {
        return category;
      }
      final child = _findCategoryById(category.children, id);
      if (child != null) {
        return child;
      }
    }
    return null;
  }

  Widget _preferencesTile(
    BuildContext context,
    SettingsSnapshot snapshot,
    SettingsCubit settingsCubit,
  ) {
    final cs = context.theme.colorScheme;
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.currency_exchange, color: cs.primary, size: 24.r),
            title: AppTextBodyLg(
              'settings.base_currency',
              style: context.theme.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: AppTextBodyMd(
              _currencyLabel(context, snapshot.baseCurrencyCode),
              color: cs.onSurfaceVariant,
            ),
            trailing: Icon(
              Icons.chevron_right,
              size: 24.r,
              color: cs.onSurfaceVariant,
            ),
            onTap: () => context.showAppBottomSheet(
              title: 'settings.select_currency',
              customWidget: _CurrencySheet(
                currentCurrencyCode: snapshot.baseCurrencyCode,
                onSelected: (currencyCode) {
                  settingsCubit.updateBaseCurrency(currencyCode);
                },
              ),
            ),
          ),
          Divider(color: cs.outlineVariant, height: 32.h),
          Row(
            children: [
              Icon(Icons.brightness_6, color: cs.primary, size: 24.r),
              SizedBox(width: 16.w),
              AppTextBodyLg(
                'settings.app_theme',
                style: context.theme.textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(
                value: ThemeMode.system,
                label: AppTextLabelMd('settings.theme_system'),
                icon: Icon(Icons.brightness_auto, size: 18),
              ),
              ButtonSegment(
                value: ThemeMode.light,
                label: AppTextLabelMd('settings.theme_light'),
                icon: Icon(Icons.light_mode, size: 18),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                label: AppTextLabelMd('settings.theme_dark'),
                icon: Icon(Icons.dark_mode, size: 18),
              ),
            ],
            selected: {snapshot.themeMode},
            onSelectionChanged: (Set<ThemeMode> newSelection) {
              settingsCubit.updateThemeMode(newSelection.first);
            },
            style: SegmentedButton.styleFrom(
              foregroundColor: cs.onSurface,
              selectedForegroundColor: cs.onPrimary,
              selectedBackgroundColor: cs.primary,
              textStyle: context.theme.textTheme.labelMedium,
            ),
          ),
        ],
      ),
    );
  }

  String _currencyLabel(BuildContext context, String currencyCode) {
    return switch (currencyCode.toLowerCase()) {
      'usd' => context.tr('common.usd'),
      'inr' => context.tr('common.inr'),
      'eur' => context.tr('common.eur'),
      _ => currencyCode.toUpperCase(),
    };
  }
}

class _DeleteCategoryDialogContent extends StatefulWidget {
  const _DeleteCategoryDialogContent({
    required this.category,
    required this.onConfirm,
  });

  final SettingsCategory category;
  final Future<void> Function() onConfirm;

  @override
  State<_DeleteCategoryDialogContent> createState() =>
      _DeleteCategoryDialogContentState();
}

class _DeleteCategoryDialogContentState
    extends State<_DeleteCategoryDialogContent> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextBodyMd(
          'settings.delete_move_notice',
          color: cs.onSurfaceVariant,
        ),
        SizedBox(height: 20.h),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _isDeleting
                    ? null
                    : () {
                        context.closeAlertDialog(
                          dialogId:
                              'delete-category-${widget.category.id}',
                        );
                      },
                child: const AppTextLabelMd('common.cancel', uppercase: true),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: ElevatedButton(
                onPressed: _isDeleting
                    ? null
                    : () async {
                        setState(() => _isDeleting = true);
                        await widget.onConfirm();
                        if (!mounted) {
                          return;
                        }
                        setState(() => _isDeleting = false);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.error,
                  foregroundColor: cs.onError,
                ),
                child: _isDeleting
                    ? SizedBox(
                        width: 18.w,
                        height: 18.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const AppTextLabelMd('common.delete', uppercase: true),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CurrencySheet extends StatelessWidget {
  const _CurrencySheet({
    required this.currentCurrencyCode,
    required this.onSelected,
  });

  final String currentCurrencyCode;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final options = const [
      ('inr', 'common.inr', Icons.currency_rupee),
      ('usd', 'common.usd', Icons.attach_money),
      ('eur', 'common.eur', Icons.euro),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final option in options)
          ListTile(
            leading: Icon(option.$3),
            title: AppTextBodyMd(option.$2, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: AppTextLabelSm(option.$1.toUpperCase()),
            trailing: currentCurrencyCode == option.$1
                ? Icon(Icons.check, color: context.theme.colorScheme.primary)
                : null,
            onTap: () {
              onSelected(option.$1);
              Navigator.pop(context);
            },
          ),
      ],
    );
  }
}
