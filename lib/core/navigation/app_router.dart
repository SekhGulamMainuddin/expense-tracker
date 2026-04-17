import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:expense_tracker/core/navigation/main_screen.dart';
import 'package:expense_tracker/features/add_expense/presentation/screens/add_expense_screen.dart';
import 'package:expense_tracker/features/auth/presentation/screens/login_screen.dart';
import 'package:expense_tracker/features/home/presentation/screens/home_screen.dart';
import 'package:expense_tracker/features/profile/presentation/screens/profile_screen.dart';
import 'package:expense_tracker/features/settings/presentation/screens/settings_screen.dart';

final class AppRouter {
  AppRouter._internal() {
    router = GoRouter(
      initialLocation: HomeScreen.routeName,
      navigatorKey: parentNavigatorKey,
      redirect: (context, state) {
        final isGoingToLogin = state.matchedLocation == LoginScreen.routeName;

        if (!isLoggedIn && !isGoingToLogin) {
          return LoginScreen.routeName;
        }

        if (isLoggedIn && isGoingToLogin) {
          return HomeScreen.routeName;
        }

        return null;
      },
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return MainScreen(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: HomeScreen.routeName,
                  name: HomeScreen.routeName,
                  builder: (context, state) => const HomeScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: SettingsScreen.routeName,
                  name: SettingsScreen.routeName,
                  builder: (context, state) => const SettingsScreen(),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          parentNavigatorKey: parentNavigatorKey,
          path: AddExpenseScreen.routeName,
          name: AddExpenseScreen.routeName,
          builder: (context, state) => const AddExpenseScreen(),
        ),
        GoRoute(
          parentNavigatorKey: parentNavigatorKey,
          path: ProfileScreen.routeName,
          name: ProfileScreen.routeName,
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          parentNavigatorKey: parentNavigatorKey,
          path: LoginScreen.routeName,
          name: LoginScreen.routeName,
          builder: (context, state) => const LoginScreen(),
        ),
      ],
    );
  }

  static final AppRouter _instance = AppRouter._internal();

  static AppRouter get instance => _instance;

  static late final GoRouter router;

  static final parentNavigatorKey = GlobalKey<NavigatorState>();

  // Mock flag for authentication status
  static bool isLoggedIn = true;
}
