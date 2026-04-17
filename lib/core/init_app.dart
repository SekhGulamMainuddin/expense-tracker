import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:expense_tracker/core/di/service_locator.dart';
import 'package:expense_tracker/core/navigation/app_router.dart';

Future<void> initApp() async {
  await EasyLocalization.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  AppRouter.instance;
  await setupServiceLocator();
}
