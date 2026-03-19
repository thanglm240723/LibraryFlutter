import 'package:flutter/material.dart';
import 'package:librarybookshelf/theme/app_theme.dart';

/// Card thống kê dùng trên tab Tổng quan.
class AdminStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? iconColor;

  const AdminStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? AppColors.accent;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.whiteCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Text(
                title,
                style: AppText.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppText.h2,
          ),
        ],
      ),
    );
  }
}
