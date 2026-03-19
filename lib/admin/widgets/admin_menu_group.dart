import 'package:flutter/material.dart';
import 'package:librarybookshelf/theme/app_theme.dart';
import 'admin_menu_item.dart';

/// Nhóm menu (container trắng + list AdminMenuItem).
class AdminMenuGroup extends StatelessWidget {
  final List<AdminMenuItem> items;

  const AdminMenuGroup({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.textDark.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            items[i],
            if (i < items.length - 1)
              const Divider(
                height: 1,
                color: AppColors.divider,
                indent: 52,
                endIndent: 0,
              ),
          ],
        ],
      ),
    );
  }
}
