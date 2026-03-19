import 'package:flutter/material.dart';
import 'package:librarybookshelf/theme/app_theme.dart';
import '../models/admin_user_model.dart';

/// Khối hiển thị thống kê đọc sách (UserStatsSummary).
class AdminUserStatsSection extends StatelessWidget {
  final UserStatsSummary stats;

  const AdminUserStatsSection({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thống kê đọc sách',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 12),
        if (stats.rank != null && stats.rank!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.accentL,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.accent.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.emoji_events_rounded,
                    color: AppColors.accent,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    stats.rank!,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.4,
          children: [
            _StatTile(
              icon: Icons.menu_book_rounded,
              label: 'Sách đã đọc',
              value: '${stats.totalBooksRead}',
            ),
            _StatTile(
              icon: Icons.play_circle_outline_rounded,
              label: 'Đã bắt đầu',
              value: '${stats.totalBooksStarted}',
            ),
            _StatTile(
              icon: Icons.description_rounded,
              label: 'Trang đã đọc',
              value: '${stats.totalPagesRead}',
            ),
            _StatTile(
              icon: Icons.schedule_rounded,
              label: 'Phút đọc',
              value: '${stats.totalMinutesRead}',
            ),
            _StatTile(
              icon: Icons.text_fields_rounded,
              label: 'Từ đã đọc',
              value: _formatNumber(stats.totalWordsRead),
            ),
            _StatTile(
              icon: Icons.local_fire_department_rounded,
              label: 'Streak hiện tại',
              value: '${stats.currentStreak} ngày',
            ),
            _StatTile(
              icon: Icons.whatshot_rounded,
              label: 'Streak dài nhất',
              value: '${stats.longestStreak} ngày',
            ),
            if (stats.favoriteGenre != null && stats.favoriteGenre!.isNotEmpty)
              _StatTile(
                icon: Icons.category_rounded,
                label: 'Thể loại yêu thích',
                value: stats.favoriteGenre!,
                small: true,
              )
            else
              _StatTile(
                icon: Icons.category_rounded,
                label: 'Thể loại yêu thích',
                value: '—',
                small: true,
              ),
          ],
        ),
        if (stats.statsUpdatedAt != null) ...[
          const SizedBox(height: 8),
          Text(
            'Cập nhật: ${_formatDate(stats.statsUpdatedAt!)}',
            style: AppText.caption,
          ),
        ],
      ],
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

  static String _formatNumber(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return '$n';
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool small;

  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.accent),
          const SizedBox(height: 6),
          Text(
            label,
            style: AppText.caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: small
                ? AppText.bodySmall
                : const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
