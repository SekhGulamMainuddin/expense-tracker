import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/settings/presentation/cubit/subcategory_cubit.dart';
import 'package:expense_tracker/features/settings/presentation/cubit/subcategory_state.dart';
import 'package:expense_tracker/features/settings/presentation/widgets/icon_grid_selector.dart';
import 'package:expense_tracker/features/settings/presentation/widgets/color_picker_row.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/styles/app_dimensions.dart';
import '../../../../core/styles/app_palette.dart';
import '../../../../core/styles/app_texts.dart';
import '../../../../core/utils/ui_extensions.dart';

class AddSubcategoryContent extends StatefulWidget {
  const AddSubcategoryContent({super.key, required this.parentCategory});

  final String parentCategory;

  @override
  State<AddSubcategoryContent> createState() => _AddSubcategoryContentState();
}

class _AddSubcategoryContentState extends State<AddSubcategoryContent> {
  final _nameController = TextEditingController();
  final _subcategoryCubit = getIt<SubcategoryCubit>();
  String _selectedIcon = 'local_bar';
  Color _selectedColor = AppPalette.vividBlue;

  @override
  void dispose() {
    _nameController.dispose();
    _subcategoryCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return BlocListener<SubcategoryCubit, SubcategoryState>(
      bloc: _subcategoryCubit,
      listener: (context, state) {
        if (state is SubcategorySuccess) Navigator.pop(context);
        if (state is SubcategoryFailure) {
          context.showAppSnackBar(state.errorMessage);
        }
      },
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextHeadlineSm(
              'Add Subcategory for ${widget.parentCategory}',

            ),
            SizedBox(height: 24.h),
            _fieldLabel(context, 'Subcategory Name'),
            TextField(
              controller: _nameController,
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
            _actionButtons(context),
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

  Widget _actionButtons(BuildContext context) {
    final cs = context.theme.colorScheme;
    return ColoredBox(
      color: cs.surfaceContainerLow.withOpacity(0.5),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
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
            child: BlocBuilder<SubcategoryCubit, SubcategoryState>(
              bloc: _subcategoryCubit,
              builder: (context, state) {
                final isLoading = state is SubcategoryLoading;
                return ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                    _subcategoryCubit.addSubcategory(
                      name: _nameController.text,
                      icon: _selectedIcon,
                      colorValue: _selectedColor.value,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(borderRadius: AppRadii.full),
                    elevation: 0,
                  ),
                  child: isLoading
                      ? SizedBox(
                    height: 20.h,
                    width: 20.w,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : AppTextBodyMd(
                    'Add Subcategory',

                    style: context.theme.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
