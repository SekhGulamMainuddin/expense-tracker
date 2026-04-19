import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:expense_tracker/core/widgets/app_modal_bottom_sheet.dart';

final class BottomSheetConstants {
  BottomSheetConstants._();

  static const baseId = 'app-bottom-sheet';
}

final class BottomSheetUtil {
  static final Map<String, ModalBottomSheetRoute<void>> routes = {};

  static void open({
    required BuildContext context,
    required String sheetId,
    String? title,
    Widget? customWidget,
    bool isScrollControlled = false,
    bool isDismissible = true,
  }) {
    close(context: context, sheetId: sheetId);

    routes[sheetId] = ModalBottomSheetRoute<void>(
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: isDismissible,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) =>
          AppModalBottomSheet(title: title, customWidget: customWidget),
    );

    Navigator.of(context).push(routes[sheetId]!);
  }

  static void close({required BuildContext context, required String sheetId}) {
    final route = routes.remove(sheetId);
    if (route != null) {
      Navigator.of(context).removeRoute(route);
    }
  }
}
