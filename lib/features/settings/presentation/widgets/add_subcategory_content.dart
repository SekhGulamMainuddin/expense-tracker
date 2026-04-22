import 'package:expense_tracker/core/di/service_locator.dart';
import 'package:expense_tracker/core/styles/app_dimensions.dart';
import 'package:expense_tracker/core/styles/app_palette.dart';
import 'package:expense_tracker/core/styles/app_texts.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:expense_tracker/features/settings/domain/entities/settings_category.dart';
import 'package:expense_tracker/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:expense_tracker/features/settings/presentation/cubit/settings_state.dart';
import 'package:expense_tracker/features/settings/presentation/widgets/color_picker_row.dart';
import 'package:expense_tracker/features/settings/presentation/widgets/icon_grid_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddSubcategoryContent extends StatefulWidget {
  const AddSubcategoryContent({
    super.key,
    this.parentCategory,
    this.parentId,
    this.initialCategory,
  });

  final String? parentCategory;
  final int? parentId;
  final SettingsCategory? initialCategory;

  @override
  State<AddSubcategoryContent> createState() => _AddSubcategoryContentState();
}

class _AddSubcategoryContentState extends State<AddSubcategoryContent> {
  final _nameController = TextEditingController();
  final _settingsCubit = getIt<SettingsCubit>();
  String _selectedIcon = 'local_bar';
  Color _selectedColor = AppPalette.vividBlue;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final category = widget.initialCategory;
    if (category != null) {
      _nameController.text = category.title;
      _selectedIcon = category.icon;
      _selectedColor = Color(category.color);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isEditing = widget.initialCategory != null;
    final title = isEditing
        ? (widget.initialCategory!.parentId == null
            ? 'Edit Category'
            : 'Edit Subcategory')
        : (widget.parentCategory == null
            ? 'Add Category'
            : 'Add Subcategory for ${widget.parentCategory}');

    return BlocListener<SettingsCubit, SettingsState>(
      bloc: _settingsCubit,
      listener: (context, state) {
        if (state is SettingsFailure) {
          context.showAppSnackBar(state.errorMessage);
        }
      },
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextHeadlineSm(title),
            SizedBox(height: 24.h),
            _fieldLabel(context, 'Category Name'),
            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              style: theme.textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: 'e.g. Fine Dining',
                hintStyle: theme.textTheme.bodyMedium,
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerLow,
                border: OutlineInputBorder(
                  borderRadius: AppRadii.xl,
                  borderSide: BorderSide.none,
                ),
                suffixIcon: Icon(
                  Icons.edit,
                  size: 18.r,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            _fieldLabel(context, 'Select Icon'),
            IconGridSelector(
              selectedIcon: _selectedIcon,
              selectedColor: _selectedColor,
              onIconSelected: (icon) => setState(() => _selectedIcon = icon),
            ),
            SizedBox(height: 24.h),
            _fieldLabel(context, 'Accent Color'),
            ColorPickerRow(
              selectedColor: _selectedColor,
              onColorSelected: (color) => setState(() => _selectedColor = color),
            ),
            SizedBox(height: 32.h),
            _actionButtons(context, isEditing),
          ],
        ),
      ),
    );
  }

  Widget _fieldLabel(BuildContext context, String text) {
    final cs = context.theme.colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
      child: AppTextLabelMd(
        text,
        uppercase: true,
        letterSpacing: 1.2,
        color: cs.onSurfaceVariant,
      ),
    );
  }

  Widget _actionButtons(BuildContext context, bool isEditing) {
    final cs = context.theme.colorScheme;
    final navigator = Navigator.of(context);
    return ColoredBox(
      color: cs.surfaceContainerLow.withOpacity(0.5),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: _isSubmitting ? null : () => Navigator.pop(context),
              child: AppTextBodyMd(
                'Cancel',
                color: cs.onSurfaceVariant,
                style: context.theme.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _isSubmitting
                  ? null
                  : () async {
                      final title = _nameController.text.trim();
                      if (title.isEmpty) {
                        context.showAppSnackBar('Please enter a category name');
                        return;
                      }

                      setState(() => _isSubmitting = true);
                      final success = isEditing
                          ? await _settingsCubit.updateCategory(
                              id: widget.initialCategory!.id,
                              title: title,
                              icon: _selectedIcon,
                              color: _selectedColor.toARGB32(),
                              parentId: widget.initialCategory!.parentId,
                            )
                          : await _settingsCubit.addCategory(
                              title: title,
                              icon: _selectedIcon,
                              color: _selectedColor.toARGB32(),
                              parentId: widget.parentId,
                            );
                      if (!mounted) {
                        return;
                      }
                      setState(() => _isSubmitting = false);
                      if (success) {
                        navigator.pop();
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(borderRadius: AppRadii.full),
                elevation: 0,
              ),
              child: _isSubmitting
                  ? SizedBox(
                      height: 20.h,
                      width: 20.w,
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : AppTextBodyMd(
                      isEditing
                          ? 'Save Changes'
                          : (widget.parentCategory == null
                              ? 'Add Category'
                              : 'Add Subcategory'),
                      style: context.theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      color: Colors.white,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
