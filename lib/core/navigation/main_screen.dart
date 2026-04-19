import 'package:expense_tracker/core/styles/app_texts.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:expense_tracker/features/add_expense/presentation/screens/add_expense_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

final bottomNavKey = GlobalKey();

class MainScreen extends StatelessWidget {
  const MainScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return Scaffold(
      body: navigationShell,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AddExpenseScreen.routeName),
        icon: Icon(Icons.add, size: 24.r),
        label: AppTextBodyLg(
          'Add Expense',
          style: context.theme.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w600,
              ),
          color: cs.onPrimaryContainer,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        key: bottomNavKey,
        currentIndex: navigationShell.currentIndex,
        backgroundColor: cs.surfaceContainer,
        selectedItemColor: cs.primary,
        unselectedItemColor: cs.onSurfaceVariant,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 24.r),
            activeIcon: Icon(Icons.home, size: 24.r),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined, size: 24.r),
            activeIcon: Icon(Icons.settings, size: 24.r),
            label: 'Settings',
          ),
        ],
        selectedLabelStyle: context.theme.textTheme.labelSmall,
        unselectedLabelStyle: context.theme.textTheme.labelSmall,
      ),
    );
  }
}
