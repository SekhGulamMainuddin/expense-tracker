import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:expense_tracker/core/navigation/app_router.dart';
import 'package:expense_tracker/core/styles/app_theme.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:expense_tracker/features/settings/presentation/cubit/settings_state.dart';
import 'package:expense_tracker/core/di/service_locator.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: const [Locale('en', 'US')],
      path: 'assets/locales',
      fallbackLocale: const Locale('en', 'US'),
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        builder: (context, child) {
          return BlocBuilder<SettingsCubit, SettingsState>(
            bloc: getIt<SettingsCubit>(),
            builder: (context, state) {
              final themeMode = state is SettingsLoaded ? state.themeMode : ThemeMode.system;
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                title: 'Expense Tracker',
                theme: AppTheme.light(),
                darkTheme: AppTheme.dark(),
                themeMode: themeMode,
                locale: context.locale,
                supportedLocales: context.supportedLocales,
                localizationsDelegates: context.localizationDelegates,
                routerConfig: AppRouter.router,
              );
            },
          );
        },
      ),
    );
  }
}
