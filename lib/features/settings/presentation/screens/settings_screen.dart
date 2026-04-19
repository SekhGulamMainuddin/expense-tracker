import 'package:expense_tracker/core/styles/app_texts.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:expense_tracker/features/settings/presentation/widgets/category_list.dart';
import 'package:expense_tracker/features/settings/presentation/widgets/budget_section.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return BlocProvider(
      create: (_) => SettingsCubit(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              context.switchBottomNavTab(0);
            },
            icon: Icon(Icons.arrow_back, color: theme.colorScheme.primary, size: 24.r),
          ),
          title: const AppTextHeadlineSm('Settings', ),
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
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String text) {
    return AppTextHeadlineSm(text, );
  }

  Widget _preferencesTile(BuildContext context) {
    final cs = context.theme.colorScheme;
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(Icons.currency_exchange, color: cs.primary, size: 24.r),
        title: AppTextBodyLg(
          'Base Currency',
          
          style: context.theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: AppTextBodyMd(
          'US Dollar (USD)',
          
          color: cs.onSurfaceVariant,
        ),
        trailing: Icon(Icons.chevron_right, size: 24.r, color: cs.onSurfaceVariant),
      ),
    );
  }
}
