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
    return Scaffold(
      body: navigationShell,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AddExpenseScreen.routeName),
        icon: Icon(Icons.add, size: 24.r),
        label: Text(
          'Add Expense',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        key: bottomNavKey,
        currentIndex: navigationShell.currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
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
        selectedLabelStyle: TextStyle(fontSize: 12.sp),
        unselectedLabelStyle: TextStyle(fontSize: 12.sp),
      ),
    );
  }
}

