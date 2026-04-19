import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:expense_tracker/features/settings/presentation/cubit/settings_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_text_styles.dart';
import '../../../../core/styles/app_texts.dart';

import 'package:expense_tracker/core/di/service_locator.dart';

class ThresholdSlider extends StatelessWidget {
  const ThresholdSlider({
    super.key,
    required this.label,
    required this.color,
    required this.type,
  });

  final String label;
  final Color color;
  final String type;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      bloc: getIt<SettingsCubit>(),
      builder: (context, state) {
        if (state is! SettingsLoaded) return const SizedBox.shrink();

        final val = type == 'safe'
            ? state.safeHaven
            : (type == 'caution' ? state.mildCaution : state.dangerThreshold);
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(radius: 4.r, backgroundColor: color),
                    SizedBox(width: 8.w),
                    AppTextLabelMd(
                      label,
                      style: AppTextStyles.labelMd(context).copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                AppTextLabelMd(
                  '${val.toInt()}%',
                  color: color,
                  style: AppTextStyles.labelMd(context).copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Slider(
              value: val,
              min: 0,
              max: 100,
              activeColor: color,
              onChanged: (v) => getIt<SettingsCubit>().updateThreshold(type, v),
            ),
          ],
        );
      },
    );
  }
}
