import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expense_tracker/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:expense_tracker/features/settings/presentation/widgets/category_list.dart';
import 'package:expense_tracker/features/settings/presentation/widgets/budget_section.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white.withOpacity(0.8),
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              context.switchBottomNavTab(0);
            },
            icon: const Icon(Icons.arrow_back, color: Color(0xFF2B8CEE)),
          ),
          title: Text(
            'Settings',
            style: GoogleFonts.manrope(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Category Management'),
              const SizedBox(height: 16),
              const CategoryList(),
              const SizedBox(height: 32),
              _sectionTitle('Budget Limits'),
              const SizedBox(height: 16),
              const BudgetSection(),
              const SizedBox(height: 32),
              _sectionTitle('Global Preferences'),
              const SizedBox(height: 16),
              _preferencesTile(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w800),
    );
  }

  Widget _preferencesTile() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const ListTile(
        leading: Icon(Icons.currency_exchange, color: Color(0xFF2B8CEE)),
        title: Text(
          'Base Currency',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('US Dollar (USD)'),
        trailing: Icon(Icons.chevron_right),
      ),
    );
  }
}
