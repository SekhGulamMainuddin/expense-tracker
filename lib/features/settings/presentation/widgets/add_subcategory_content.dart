import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expense_tracker/features/settings/presentation/cubit/subcategory_cubit.dart';
import 'package:expense_tracker/features/settings/presentation/cubit/subcategory_state.dart';
import 'package:expense_tracker/features/settings/presentation/widgets/icon_grid_selector.dart';
import 'package:expense_tracker/features/settings/presentation/widgets/color_picker_row.dart';

class AddSubcategoryContent extends StatefulWidget {
  const AddSubcategoryContent({super.key, required this.parentCategory});

  final String parentCategory;

  @override
  State<AddSubcategoryContent> createState() => _AddSubcategoryContentState();
}

class _AddSubcategoryContentState extends State<AddSubcategoryContent> {
  final _nameController = TextEditingController();
  String _selectedIcon = 'local_bar';
  Color _selectedColor = const Color(0xFF2B8CEE);

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                child: Text(
                  'Add Subcategory for ${widget.parentCategory}',
                  style: GoogleFonts.manrope(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Name Input
              _fieldLabel('Subcategory Name'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'e.g. Fine Dining',
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: const Icon(
                      Icons.edit,
                      size: 18,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Icon Grid
              _fieldLabel('Select Icon'),
              IconGridSelector(
                selectedIcon: _selectedIcon,
                selectedColor: _selectedColor,
                onIconSelected: (icon) =>
                    setState(() => _selectedIcon = icon),
              ),
              const SizedBox(height: 24),

              // Color Picker
              _fieldLabel('Accent Color'),
              ColorPickerRow(
                selectedColor: _selectedColor,
                onColorSelected: (color) =>
                    setState(() => _selectedColor = color),
              ),
              const SizedBox(height: 32),

              // Action Buttons
              _actionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Color(0xFF64748B),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _actionButtons() {
    return Container(
      color: const Color(0xFFF8FAFC).withOpacity(0.5),
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
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
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: state.isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Add Subcategory',
                          style: TextStyle(fontWeight: FontWeight.bold),
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
