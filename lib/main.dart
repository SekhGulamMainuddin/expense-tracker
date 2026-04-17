import 'dart:async';

import 'package:flutter/material.dart';
import 'package:expense_tracker/core/init_app.dart';
import 'package:expense_tracker/core/main_app.dart';

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      // Package name is expected to be finalized immediately after project creation.
      await initApp();
      runApp(const MainApp());
    },
    (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(exception: error, stack: stackTrace),
      );
    },
  );
}
