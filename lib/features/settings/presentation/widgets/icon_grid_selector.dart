import 'package:expense_tracker/core/styles/app_texts.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:expense_tracker/core/widgets/app_icon.dart';
import 'package:expense_tracker/features/settings/presentation/widgets/icon_catalog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IconGridSelector extends StatefulWidget {
  const IconGridSelector({
    super.key,
    required this.selectedIcon,
    required this.selectedColor,
    required this.onIconSelected,
  });

  final String selectedIcon;
  final Color selectedColor;
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
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
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
        SizedBox(height: 14.h),
        SizedBox(
          height: 40.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: AppIconCatalog.packs.length,
            separatorBuilder: (_, __) => SizedBox(width: 8.w),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppTextLabelSm(
              '${results.length} icons',
              color: cs.onSurfaceVariant,
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _activePackId = AppIconCatalog.allPackId;
                  _searchController.clear();
                });
              },
              child: const Text('Reset'),
            ),
          ],
        ),
        SizedBox(
          height: 420.h,
          child: results.isEmpty
              ? _EmptyState(
                  message: _searchController.text.isEmpty
                      ? 'No icons available in this pack.'
                      : 'No icons match "${_searchController.text}".',
                )
              : GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 12.h,
                    crossAxisSpacing: 12.w,
                    mainAxisExtent: 94.h,
                  ),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final option = results[index];
                    final isSelected = selectedKey == option.storageKey;
                    return _IconTile(
                      option: option,
                      isSelected: isSelected,
                      selectedColor: widget.selectedColor,
                      onTap: () => widget.onIconSelected(option.storageKey),
                    );
                  },
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
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.16)
                      : cs.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: AppIcon(
                  option.storageKey,
                  size: 22.r,
                  color: foregroundColor,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                _prettyName(option.iconName),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.theme.textTheme.labelSmall?.copyWith(
                  color: foregroundColor,
                  fontWeight: FontWeight.w600,
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
