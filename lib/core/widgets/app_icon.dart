import 'package:expense_tracker/features/settings/presentation/widgets/icon_catalog.dart';
import 'package:flutter/material.dart';

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
    return AppIconCatalog.render(
      iconKey,
      size: size,
      color: color ?? Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }
}
