import 'package:expense_tracker/core/di/service_locator.dart';
import 'package:expense_tracker/features/settings/domain/entities/custom_icon_entity.dart';
import 'package:expense_tracker/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:expense_tracker/features/settings/presentation/cubit/settings_state.dart';
import 'package:expense_tracker/features/settings/presentation/widgets/icon_catalog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppIcon extends StatelessWidget {
  const AppIcon(
    this.iconKey, {
    super.key,
    this.size = 24,
    this.color,
  });

  final String iconKey;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      bloc: getIt<SettingsCubit>(),
      buildWhen: (previous, current) => current is SettingsLoaded,
      builder: (context, state) {
        final customIcons = state is SettingsLoaded
            ? state.snapshot.customIcons
            : const <CustomIconEntity>[];

        return AppIconCatalog.render(
          iconKey,
          size: size,
          color: color ?? Theme.of(context).colorScheme.onSurfaceVariant,
          customIcons: customIcons,
        );
      },
    );
  }
}
