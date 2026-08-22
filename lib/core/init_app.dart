import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/core/exchange/domain/repositories/exchange_rate_repository.dart';
import 'package:expense_tracker/firebase_options.dart';
import 'package:flutter/services.dart';
import 'package:expense_tracker/core/di/service_locator.dart';
import 'package:expense_tracker/core/navigation/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> initApp() async {
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  await GoogleSignIn.instance.initialize();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await setupServiceLocator();
  AppRouter.instance;

  // Rates are only needed for display/normalization, so never block startup
  // on the network - the cached or fallback table is already usable.
  unawaited(getIt<ExchangeRateRepository>().refreshIfStale());
}
