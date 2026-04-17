import 'package:flutter/material.dart';
import 'package:expense_tracker/core/widgets/app_alert_dialog.dart';

final class DialogConstants {
  DialogConstants._();

  static const alertId = 'alert-dialog';
}

final class AlertDialogUtil {
  static final Map<String, DialogRoute<void>> dialogRoutes = {};

  static void open({
    required BuildContext context,
    required String dialogId,
    String? title,
    String? subtitle,
    String? buttonText,
    VoidCallback? onPressed,
    bool isDismissible = true,
    Widget? content,
  }) {
    close(context: context, dialogId: dialogId);

    dialogRoutes[dialogId] = DialogRoute<void>(
      context: context,
      barrierDismissible: isDismissible,
      builder: (context) => AppAlertDialog(
        dialogId: dialogId,
        title: title,
        subtitle: subtitle,
        buttonText: buttonText,
        onPressed: onPressed,
        content: content,
        isDismissible: isDismissible,
      ),
    );

    Navigator.of(context).push(dialogRoutes[dialogId]!);
  }

  static void close({required BuildContext context, required String dialogId}) {
    final route = dialogRoutes.remove(dialogId);
    if (route != null) {
      Navigator.of(context).removeRoute(route);
    }
  }
}
