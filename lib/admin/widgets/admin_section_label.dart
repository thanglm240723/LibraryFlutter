import 'package:flutter/material.dart';
import 'package:librarybookshelf/theme/app_theme.dart';

/// Label section (TÀI KHOẢN, QUẢN LÝ, ...) dùng trong menu admin.
class AdminSectionLabel extends StatelessWidget {
  final String text;

  const AdminSectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.textLight,
        letterSpacing: 1.2,
      ),
    );
  }
}
