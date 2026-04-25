import 'package:expense_tracker/core/di/service_locator.dart';
import 'package:expense_tracker/core/widgets/sticky_header_delegate.dart';
import 'package:expense_tracker/features/settings/domain/entities/custom_icon_entity.dart';
import 'package:expense_tracker/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:expense_tracker/features/settings/presentation/widgets/icon_catalog.dart';
import 'package:expense_tracker/core/widgets/app_icon.dart';
import 'package:expense_tracker/core/styles/app_texts.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:expense_tracker/features/settings/domain/entities/custom_icon_entity.dart';
import 'package:expense_tracker/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auto_size_text/auto_size_text.dart';

class IconGridSelector extends StatefulWidget {
  const IconGridSelector({
    super.key,
    required this.selectedIcon,
    required this.selectedColor,
    required this.customIcons,
    required this.onIconSelected,
  });

  final String selectedIcon;
  final Color selectedColor;
  final List<CustomIconEntity> customIcons;
  final ValueChanged<String> onIconSelected;

  @override
  State<IconGridSelector> createState() => _IconGridSelectorState();
}

class _IconGridSelectorState extends State<IconGridSelector> {
  final _searchController = TextEditingController();
  String _activePackId = AppIconCatalog.materialPackId;

  @override
  void initState() {
    super.initState();
    _activePackId = _packFromKey(widget.selectedIcon);
  }

  @override
  void didUpdateWidget(covariant IconGridSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIcon != widget.selectedIcon) {
      _activePackId = _packFromKey(widget.selectedIcon);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final selectedKey = AppIconCatalog.normalizeKey(widget.selectedIcon);
    final results = AppIconCatalog.filter(
      packId: _activePackId,
      query: _searchController.text,
      customIcons: widget.customIcons,
    );

    return SliverMainAxisGroup(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: StickyHeaderDelegate(
            minHeight: 190.h,
            maxHeight: 190.h,
            backgroundColor: context.theme.scaffoldBackgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: context.theme.scaffoldBackgroundColor,
                  padding: EdgeInsets.only(top: 8.h, left: 20.w, right: 20.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (_) => setState(() {}),
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            hintText: 'Search icon by name',
                            prefixIcon: Icon(Icons.search, color: cs.onSurfaceVariant),
                            filled: true,
                            fillColor: cs.surfaceContainerLow,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: _searchController.text.isEmpty
                                ? null
                                : IconButton(
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {});
                                    },
                                    icon: Icon(
                                      Icons.clear,
                                      color: cs.onSurfaceVariant,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      _AddCustomIconButton(
                        onAdded: (name, url) async {
                          await getIt<SettingsCubit>().addCustomIcon(name: name, iconUrl: url);
                          setState(() {
                            _activePackId = AppIconCatalog.customPackId;
                            _searchController.clear();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 14.h),
                SizedBox(
                  height: 40.h,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    scrollDirection: Axis.horizontal,
                    itemCount: AppIconCatalog.packs.length,
                    separatorBuilder: (_, _) => SizedBox(width: 8.w),
                    itemBuilder: (context, index) {
                      final pack = AppIconCatalog.packs[index];
                      final isSelected = _activePackId == pack.id;
                      return ChoiceChip(
                        label: Text(pack.label),
                        selected: isSelected,
                        onSelected: (_) => setState(() => _activePackId = pack.id),
                        selectedColor: widget.selectedColor.withValues(alpha: 0.18),
                        labelStyle: context.theme.textTheme.labelMedium?.copyWith(
                          color: isSelected ? widget.selectedColor : cs.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                        side: BorderSide(color: isSelected ? widget.selectedColor : cs.outlineVariant),
                      );
                    },
                  ),
                ),
                SizedBox(height: 12.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: cs.secondaryContainer.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: AppTextLabelSm(
                        '${results.length} ICONS FOUND',
                        color: cs.onSecondaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (_searchController.text.isNotEmpty || _activePackId != AppIconCatalog.allPackId)
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _activePackId = AppIconCatalog.allPackId;
                            _searchController.clear();
                          });
                        },
                        icon: Icon(Icons.refresh, size: 14.r),
                        label: const Text('Reset Filters'),
                      ),
                  ],
                ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
          sliver: results.isEmpty
              ? SliverToBoxAdapter(
                  child: _EmptyState(
                    message: _searchController.text.isEmpty
                        ? 'This icon pack is currently empty.'
                        : 'No icons match "${_searchController.text}".',
                  ),
                )
              : SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 12.h,
                    crossAxisSpacing: 12.w,
                    mainAxisExtent: 100.h,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final option = results[index];
                      final isSelected = selectedKey == option.storageKey;
                      return _IconTile(
                        option: option,
                        isSelected: isSelected,
                        selectedColor: widget.selectedColor,
                        onTap: () => widget.onIconSelected(option.storageKey),
                      );
                    },
                    childCount: results.length,
                  ),
                ),
        ),
      ],
    );
  }

  String _packFromKey(String key) {
    final normalizedKey = AppIconCatalog.normalizeKey(key);
    final packId = normalizedKey.split(':').first;
    if (AppIconCatalog.packs.any((pack) => pack.id == packId)) {
      return packId;
    }
    return AppIconCatalog.materialPackId;
  }
}

class _IconTile extends StatelessWidget {
  const _IconTile({
    required this.option,
    required this.isSelected,
    required this.selectedColor,
    required this.onTap,
  });

  final AppIconOption option;
  final bool isSelected;
  final Color selectedColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final backgroundColor = isSelected
        ? selectedColor
        : cs.surfaceContainerLow;
    final foregroundColor = isSelected ? Colors.white : cs.onSurfaceVariant;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isSelected ? selectedColor : cs.outlineVariant,
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: selectedColor.withValues(alpha: 0.22),
                      blurRadius: 10.r,
                      offset: Offset(0, 4.h),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: option.packId == AppIconCatalog.customPackId 
                      ? Colors.transparent 
                      : (isSelected
                          ? Colors.white.withValues(alpha: 0.16)
                          : cs.surfaceContainerHighest),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: AppIcon(
                  option.storageKey,
                  size: option.packId == AppIconCatalog.customPackId ? 42.r : 22.r,
                  color: foregroundColor,
                ),
              ),
              SizedBox(height: 8.h),
              SizedBox(
                height: 24.h,
                child: AutoSizeText(
                  _prettyName(option.iconName),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  minFontSize: 8,
                  stepGranularity: 0.1,
                  wrapWords: false,
                  style: context.theme.textTheme.labelSmall?.copyWith(
                    color: foregroundColor,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _prettyName(String value) {
    return value
        .replaceAll('_fill', '')
        .replaceAll('_line', '')
        .replaceAll('_outline', '')
        .replaceAll('_solid', '')
        .replaceAll('_', ' ')
        .trim();
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.all(20.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 42.r, color: cs.onSurfaceVariant),
          SizedBox(height: 10.h),
          AppTextBodyMd(
            message,
            textAlign: TextAlign.center,
            color: cs.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

class _AddCustomIconButton extends StatelessWidget {
  const _AddCustomIconButton({required this.onAdded});

  final void Function(String name, String url) onAdded;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return Container(
      height: 54.h,
      width: 54.w,
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: IconButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => _AddCustomIconDialog(onAdded: onAdded),
        ),
        icon: Icon(Icons.add_link, color: cs.onPrimaryContainer),
        tooltip: 'Add Custom Icon URL',
      ),
    );
  }
}

class _AddCustomIconDialog extends StatefulWidget {
  const _AddCustomIconDialog({required this.onAdded});

  final void Function(String name, String url) onAdded;

  @override
  State<_AddCustomIconDialog> createState() => _AddCustomIconDialogState();
}

class _AddCustomIconDialogState extends State<_AddCustomIconDialog> {
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Custom Icon'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Icon Name',
                hintText: 'e.g. Netflix',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),
            TextFormField(
              controller: _urlController,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'Icon URL',
                hintText: 'https://example.com/icon.png',
              ),
              validator: (value) {
                final raw = value?.trim() ?? '';
                if (raw.isEmpty) {
                  return 'Please enter a URL';
                }
                final uri = Uri.tryParse(raw);
                if (uri == null ||
                    !uri.hasScheme ||
                    !(uri.scheme == 'http' || uri.scheme == 'https') ||
                    uri.host.isEmpty) {
                  return 'Enter a valid http(s) URL';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              widget.onAdded(
                _nameController.text.trim(),
                _urlController.text.trim(),
              );
              Navigator.pop(context);
            }
          },
          child: const Text('Add Icon'),
        ),
      ],
    );
  }
}

