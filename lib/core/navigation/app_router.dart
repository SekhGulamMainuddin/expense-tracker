import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:expense_tracker/features/expense_overview/presentation/screens/expense_overview_screen.dart';

final class AppRouter {
  AppRouter._internal() {
    router = GoRouter(
      initialLocation: ExpenseOverviewScreen.routeName,
      navigatorKey: parentNavigatorKey,
      routes: [
        GoRoute(
          path: ExpenseOverviewScreen.routeName,
          name: ExpenseOverviewScreen.routeName,
          builder: (context, state) => const ExpenseOverviewScreen(),
        ),
      ],
    );
  }

  static final AppRouter _instance = AppRouter._internal();

  static AppRouter get instance => _instance;

  static late final GoRouter router;

  static final parentNavigatorKey = GlobalKey<NavigatorState>();
}
