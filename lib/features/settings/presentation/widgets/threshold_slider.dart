import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:expense_tracker/features/settings/presentation/cubit/settings_state.dart';

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
      builder: (context, state) {
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
                    CircleAvatar(radius: 4, backgroundColor: color),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${val.toInt()}%',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Slider(
              value: val,
              min: 0,
              max: 100,
              activeColor: color,
              onChanged: (v) =>
                  context.read<SettingsCubit>().updateThreshold(type, v),
            ),
          ],
        );
      },
    );
  }
}
