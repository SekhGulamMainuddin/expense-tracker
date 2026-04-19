import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expense_tracker/features/settings/presentation/cubit/subcategory_cubit.dart';
import 'package:expense_tracker/features/settings/presentation/cubit/subcategory_state.dart';
import 'package:expense_tracker/features/settings/presentation/widgets/icon_grid_selector.dart';
import 'package:expense_tracker/features/settings/presentation/widgets/color_picker_row.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddSubcategoryContent extends StatefulWidget {
  const AddSubcategoryContent({super.key, required this.parentCategory});

  final String parentCategory;

  @override
  State<AddSubcategoryContent> createState() => _AddSubcategoryContentState();
}

class _AddSubcategoryContentState extends State<AddSubcategoryContent> {
  final _nameController = TextEditingController();
  String _selectedIcon = 'local_bar';
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    // Initialize with a default color or theme primary
    _selectedColor = const Color(0xFF2B8CEE);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (_) => SubcategoryCubit(),
      child: BlocListener<SubcategoryCubit, SubcategoryState>(
        listener: (context, state) {
          if (state.success) Navigator.pop(context);
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Subcategory for ${widget.parentCategory}',
                style: GoogleFonts.manrope(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 24.h),

              // Name Input
              _fieldLabel(context, 'Subcategory Name'),
              TextField(
                controller: _nameController,
                style: theme.textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'e.g. Fine Dining',
                  hintStyle: TextStyle(fontSize: 14.sp),
                  filled: true,
                  fillColor: theme.colorScheme.secondary.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
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

              // Icon Grid
              _fieldLabel(context, 'Select Icon'),
              IconGridSelector(
                selectedIcon: _selectedIcon,
                selectedColor: _selectedColor,
                onIconSelected: (icon) =>
                    setState(() => _selectedIcon = icon),
              ),
              SizedBox(height: 24.h),

              // Color Picker
              _fieldLabel(context, 'Accent Color'),
              ColorPickerRow(
                selectedColor: _selectedColor,
                onColorSelected: (color) =>
                    setState(() => _selectedColor = color),
              ),
              SizedBox(height: 32.h),

              // Action Buttons
              _actionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fieldLabel(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurfaceVariant,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _actionButtons(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.secondary.withOpacity(0.02),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            flex: 2,
            child: BlocBuilder<SubcategoryCubit, SubcategoryState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: state.isSubmitting
                      ? null
                      : () {
                          context.read<SubcategoryCubit>().addSubcategory(
                                name: _nameController.text,
                                icon: _selectedIcon,
                                colorValue: _selectedColor.value,
                              );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 4,
                  ),
                  child: state.isSubmitting
                      ? SizedBox(
                          height: 20.h,
                          width: 20.w,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Add Subcategory',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
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

