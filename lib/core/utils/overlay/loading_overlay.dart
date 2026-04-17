import 'package:flutter/material.dart';
import 'package:expense_tracker/core/styles/app_palette.dart';

final class LoadingOverlayUtil {
  static final Map<String, DialogRoute<void>> routes = {};

  static void show(BuildContext context, {String id = 'loading-overlay'}) {
    hide(context, id: id);

    routes[id] = DialogRoute<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const ColoredBox(
        color: AppPalette.overlay,
        child: Center(child: CircularProgressIndicator()),
      ),
    );

    Navigator.of(context).push(routes[id]!);
  }

  static void hide(BuildContext context, {String id = 'loading-overlay'}) {
    final route = routes.remove(id);
    if (route != null) {
      Navigator.of(context).removeRoute(route);
    }
  }
}
