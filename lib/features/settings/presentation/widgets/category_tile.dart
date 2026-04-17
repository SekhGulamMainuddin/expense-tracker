import 'package:flutter/material.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:expense_tracker/features/settings/presentation/widgets/add_subcategory_content.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.isExpanded,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isExpanded;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          ListTile(
            onTap: onTap,
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color),
            ),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              subtitle,
              style: const TextStyle(fontSize: 12),
            ),
            trailing: Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
            ),
          ),
          if (isExpanded)
            Container(
              width: double.infinity,
              color: Colors.grey.shade50,
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 8,
                children: [
                  _subCategoryChip('Groceries'),
                  _subCategoryChip('Restaurants'),
                  _subCategoryChip('Coffee'),
                  ActionChip(
                    avatar: const Icon(Icons.add, size: 16),
                    label: const Text('Add', style: TextStyle(fontSize: 11)),
                    onPressed: () => context.parentContext.showAppBottomSheet(
                      isScrollControlled: true,
                      customWidget: AddSubcategoryContent(
                        parentCategory: title,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _subCategoryChip(String label) {
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 11)),
      deleteIcon: const Icon(Icons.close, size: 14),
      onDeleted: () {},
      backgroundColor: Colors.white,
      shape: StadiumBorder(side: BorderSide(color: Colors.grey.shade200)),
    );
  }
}

