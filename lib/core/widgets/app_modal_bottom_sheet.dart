import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:expense_tracker/core/styles/app_texts.dart';

import '../utils/ui_extensions.dart';

class AppModalBottomSheet extends StatelessWidget {
  const AppModalBottomSheet({super.key, this.title, this.customWidget});

  final String? title;
  final Widget? customWidget;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return SafeArea(
      top: false,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: cs.surfaceContainerHigh,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.9,
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) ...[
                  AppTextHeadlineSm(title!),
                  16.verticalSpace,
                ],
                if (customWidget case final widget?) widget,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
