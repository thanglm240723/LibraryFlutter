import 'package:flutter/material.dart';
import 'package:librarybookshelf/theme/app_theme.dart';

/// Tab Booking: đặt sách / yêu cầu mượn (placeholder).
class AdminBookingTab extends StatelessWidget {
  const AdminBookingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quản lý đặt sách',
            style: AppText.h2,
          ),
          const SizedBox(height: 8),
          Text(
            'Duyệt và theo dõi các yêu cầu mượn sách từ người dùng.',
            style: AppText.body,
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
            decoration: AppDecorations.whiteCard,
            child: Column(
              children: [
                Icon(
                  Icons.menu_book_rounded,
                  size: 56,
                  color: AppColors.textLight,
                ),
                const SizedBox(height: 16),
                Text(
                  'Danh sách booking',
                  style: AppText.h4,
                ),
                const SizedBox(height: 8),
                Text(
                  'Tính năng đang được phát triển. Kết nối API booking khi sẵn sàng.',
                  textAlign: TextAlign.center,
                  style: AppText.bodySmall.copyWith(color: AppColors.textLight),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
