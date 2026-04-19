import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:expense_tracker/core/styles/app_palette.dart';
import 'package:expense_tracker/core/styles/app_texts.dart';

import '../utils/ui_extensions.dart';

class AppModalBottomSheet extends StatelessWidget {
  const AppModalBottomSheet({super.key, this.title, this.customWidget});

  final String? title;
  final Widget? customWidget;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[appTextS1(title!), 16.verticalSpace],
            if (customWidget case final widget?) widget,
          ],
        ),
      ),
    );
  }
}
