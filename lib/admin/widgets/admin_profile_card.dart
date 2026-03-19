import 'package:flutter/material.dart';
import 'package:librarybookshelf/theme/app_theme.dart';

/// Card hiển thị avatar + tên + email + badge (Admin) cho tab Tài khoản.
class AdminProfileCard extends StatelessWidget {
  final String fullName;
  final String email;
  final String username;
  final VoidCallback? onTap;

  const AdminProfileCard({
    super.key,
    required this.fullName,
    required this.email,
    this.username = '',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final initial = fullName.isNotEmpty ? fullName[0].toUpperCase() : 'U';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.textDark.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppColors.accent.withOpacity(0.35),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  initial,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.accent,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fullName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    email,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.accent.withOpacity(0.25),
                      ),
                    ),
                    child: const Text(
                      '👑  Admin',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(
                Icons.edit_outlined,
                color: AppColors.textLight,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }
}
