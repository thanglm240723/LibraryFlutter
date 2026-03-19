import 'package:flutter/material.dart';
import 'package:librarybookshelf/theme/app_theme.dart';
import '../models/admin_user_model.dart';

/// Header card: avatar, tên, username, email, role, ngày tạo.
class AdminUserDetailHeader extends StatelessWidget {
  final AdminUserModel user;

  const AdminUserDetailHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final initial = (user.fullName?.isNotEmpty == true
            ? user.fullName![0]
            : user.username.isNotEmpty
                ? user.username[0]
                : '?')
        .toUpperCase();
    final displayName = user.fullName ?? user.username;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.whiteCard,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.accentL,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.accent.withOpacity(0.35),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                initial,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            displayName,
            style: AppText.h3,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '@${user.username}',
            style: AppText.bodySmall.copyWith(color: AppColors.textLight),
          ),
          if (user.email.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              user.email,
              style: AppText.bodySmall,
            ),
          ],
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: user.role == 'admin'
                  ? AppColors.accent.withOpacity(0.15)
                  : AppColors.chip,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              user.role == 'admin' ? 'Admin' : 'User',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: user.role == 'admin'
                    ? AppColors.accent
                    : AppColors.textMid,
              ),
            ),
          ),
          if (user.createdAt != null) ...[
            const SizedBox(height: 12),
            Text(
              'Tham gia: ${_formatDate(user.createdAt!)}',
              style: AppText.caption,
            ),
          ],
        ],
      ),
    );
  }

  static String _formatDate(String iso) {
    try {
      final d = DateTime.parse(iso);
      return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
    } catch (_) {
      return iso;
    }
  }
}
