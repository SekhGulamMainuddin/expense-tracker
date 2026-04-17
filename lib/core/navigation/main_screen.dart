import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:expense_tracker/core/styles/app_palette.dart';
import 'package:expense_tracker/features/add_expense/presentation/screens/add_expense_screen.dart';

final bottomNavKey = GlobalKey();

class MainScreen extends StatelessWidget {
  const MainScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppPalette.primary,
        onPressed: () => context.push(AddExpenseScreen.routeName),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Expense', style: TextStyle(color: Colors.white)),
      ),
      bottomNavigationBar: BottomNavigationBar(
        key: bottomNavKey,
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        selectedItemColor: AppPalette.primary,
        unselectedItemColor: AppPalette.textPrimary,
        backgroundColor: AppPalette.surface,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
