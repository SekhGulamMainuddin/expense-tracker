import 'package:another_flushbar/flushbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/core/utils/overlay/bottomsheet_overlay.dart';
import 'package:expense_tracker/core/utils/overlay/dialog_overlay.dart';
import 'package:expense_tracker/core/utils/overlay/loading_overlay.dart';

extension BuildContextUiExtensions on BuildContext {
  void showAppSnackbar(String text) {
    Flushbar(
      message: text.tr(),
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(8),
      flushbarPosition: FlushbarPosition.TOP,
    ).show(this);
  }

  void showAppAlertDialog({
    String? title,
    String? subtitle,
    String? buttonText,
    VoidCallback? onPressed,
    String dialogId = DialogConstants.alertId,
    bool isDismissible = true,
    Widget? content,
  }) {
    AlertDialogUtil.open(
      context: this,
      dialogId: dialogId,
      title: title,
      subtitle: subtitle,
      buttonText: buttonText,
      onPressed: onPressed,
      isDismissible: isDismissible,
      content: content,
    );
  }

  void closeAlertDialog({String dialogId = DialogConstants.alertId}) {
    AlertDialogUtil.close(context: this, dialogId: dialogId);
  }

  void showAppBottomSheet({
    String? title,
    Widget? customWidget,
    String sheetId = BottomSheetConstants.baseId,
  }) {
    BottomSheetUtil.open(
      context: this,
      sheetId: sheetId,
      title: title,
      customWidget: customWidget,
    );
  }

  void closeAppBottomSheet({String sheetId = BottomSheetConstants.baseId}) {
    BottomSheetUtil.close(context: this, sheetId: sheetId);
  }

  void showLoadingOverlay() => LoadingOverlayUtil.show(this);

  void hideLoadingOverlay() => LoadingOverlayUtil.hide(this);
}
