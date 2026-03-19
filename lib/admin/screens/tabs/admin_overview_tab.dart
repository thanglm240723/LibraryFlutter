import 'package:flutter/material.dart';
import 'package:librarybookshelf/theme/app_theme.dart';
import '../../widgets/admin_stat_card.dart';

/// Tab Tổng quan: thống kê nhanh (sách, user, booking, ...).
class AdminOverviewTab extends StatelessWidget {
  const AdminOverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chào bạn trở lại',
            style: AppText.h3.copyWith(color: AppColors.textMid),
          ),
          const SizedBox(height: 4),
          Text(
            'Tổng quan thư viện',
            style: AppText.h1,
          ),
          const SizedBox(height: 24),
          // Grid thống kê 2 cột
          Row(
            children: [
              Expanded(
                child: AdminStatCard(
                  title: 'Sách',
                  value: '0',
                  icon: Icons.auto_stories_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AdminStatCard(
                  title: 'User',
                  value: '0',
                  icon: Icons.people_outline_rounded,
                  iconColor: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: AdminStatCard(
                  title: 'Booking',
                  value: '0',
                  icon: Icons.menu_book_rounded,
                  iconColor: AppColors.success,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AdminStatCard(
                  title: 'Đang đọc',
                  value: '0',
                  icon: Icons.trending_up_rounded,
                  iconColor: const Color(0xFF8B6914),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          const Text(
            'Hoạt động gần đây',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
            decoration: AppDecorations.whiteCard,
            child: Column(
              children: [
                Icon(
                  Icons.history_rounded,
                  size: 40,
                  color: AppColors.textLight,
                ),
                const SizedBox(height: 12),
                Text(
                  'Chưa có hoạt động',
                  style: AppText.body.copyWith(color: AppColors.textLight),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
