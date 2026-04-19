import 'package:expense_tracker/core/styles/app_texts.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:expense_tracker/features/settings/presentation/widgets/budget_section.dart';
import 'package:expense_tracker/features/settings/presentation/widgets/category_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:expense_tracker/features/settings/presentation/cubit/settings_state.dart';
import 'package:expense_tracker/core/di/service_locator.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.switchBottomNavTab(0);
          },
          icon: Icon(
            Icons.arrow_back,
            color: theme.colorScheme.primary,
            size: 24.r,
          ),
        ),
        title: const AppTextHeadlineSm('Settings'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 100.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle(context, 'Category Management'),
            SizedBox(height: 16.h),
            const CategoryList(),
            SizedBox(height: 32.h),
            _sectionTitle(context, 'Budget Limits'),
            SizedBox(height: 16.h),
            const BudgetSection(),
            SizedBox(height: 32.h),
            _sectionTitle(context, 'Global Preferences'),
            SizedBox(height: 16.h),
            _preferencesTile(context),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String text) {
    return AppTextHeadlineSm(text);
  }

  Widget _preferencesTile(BuildContext context) {
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
              'Base Currency',
              style: context.theme.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: AppTextBodyMd('US Dollar (USD)', color: cs.onSurfaceVariant),
            trailing: Icon(
              Icons.chevron_right,
              size: 24.r,
              color: cs.onSurfaceVariant,
            ),
          ),
          Divider(color: cs.outlineVariant, height: 32.h),
          BlocBuilder<SettingsCubit, SettingsState>(
            bloc: getIt<SettingsCubit>(),
            builder: (context, state) {
              final themeMode = state is SettingsLoaded ? state.themeMode : ThemeMode.system;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.brightness_6, color: cs.primary, size: 24.r),
                      SizedBox(width: 16.w),
                      AppTextBodyLg(
                        'App Theme',
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
                        label: Text('System'),
                        icon: Icon(Icons.brightness_auto, size: 18),
                      ),
                      ButtonSegment(
                        value: ThemeMode.light,
                        label: Text('Light'),
                        icon: Icon(Icons.light_mode, size: 18),
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        label: Text('Dark'),
                        icon: Icon(Icons.dark_mode, size: 18),
                      ),
                    ],
                    selected: {themeMode},
                    onSelectionChanged: (Set<ThemeMode> newSelection) {
                      getIt<SettingsCubit>().updateThemeMode(newSelection.first);
                    },
                    style: SegmentedButton.styleFrom(
                      foregroundColor: cs.onSurface,
                      selectedForegroundColor: cs.onPrimary,
                      selectedBackgroundColor: cs.primary,
                      textStyle: context.theme.textTheme.labelMedium,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
