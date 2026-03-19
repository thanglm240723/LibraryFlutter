import 'package:flutter/material.dart';
import 'package:librarybookshelf/theme/app_theme.dart';
import '../models/admin_user_model.dart';

/// Một dòng hiển thị user trong danh sách admin.
class AdminUserTile extends StatelessWidget {
  final AdminUserModel user;
  final VoidCallback? onTap;

  const AdminUserTile({super.key, required this.user, this.onTap});

  @override
  Widget build(BuildContext context) {
    final initial = (user.fullName?.isNotEmpty == true
            ? user.fullName![0]
            : user.username.isNotEmpty
                ? user.username[0]
                : '?')
        .toUpperCase();
    final child = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.accentL,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.accent.withOpacity(0.3)),
            ),
            child: Center(
              child: Text(
                initial,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName ?? user.username,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '@${user.username}',
                  style: AppText.bodySmall,
                ),
                if (user.email.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    user.email,
                    style: AppText.caption,
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: user.role == 'admin'
                  ? AppColors.accent.withOpacity(0.15)
                  : AppColors.chip,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              user.role == 'admin' ? 'Admin' : 'User',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: user.role == 'admin'
                    ? AppColors.accent
                    : AppColors.textMid,
              ),
            ),
          ),
        ],
      ),
    );
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: child,
      );
    }
    return child;
  }
}
