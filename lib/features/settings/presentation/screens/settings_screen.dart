import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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
          title: Text(
            'Settings',
            style: GoogleFonts.manrope(
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 100.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Category Management'),
              SizedBox(height: 16.h),
              const CategoryList(),
              SizedBox(height: 32.h),
              _sectionTitle('Budget Limits'),
              SizedBox(height: 16.h),
              const BudgetSection(),
              SizedBox(height: 32.h),
              _sectionTitle('Global Preferences'),
              SizedBox(height: 16.h),
              _preferencesTile(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.manrope(fontSize: 20.sp, fontWeight: FontWeight.w800),
    );
  }

  Widget _preferencesTile(BuildContext context) {
    final theme = context.theme;
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: ListTile(
        leading: Icon(Icons.currency_exchange, color: theme.colorScheme.primary, size: 24.r),
        title: Text(
          'Base Currency',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
        ),
        subtitle: Text('US Dollar (USD)', style: TextStyle(fontSize: 14.sp)),
        trailing: Icon(Icons.chevron_right, size: 24.r),
      ),
    );
  }
}

