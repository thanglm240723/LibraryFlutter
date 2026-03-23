import 'package:flutter/material.dart';
import 'package:librarybookshelf/book_detail_screen.dart';
import 'package:librarybookshelf/theme/app_theme.dart';

class ReadingHistoryScreen extends StatelessWidget {
  const ReadingHistoryScreen({super.key});

  final List<Map<String, dynamic>> _history = const [
    {'id': 101, 'title': 'Chuyện cũ', 'time': 'Hôm qua'},
    {'id': 102, 'title': 'Tiểu thuyết hay', 'time': '3 ngày trước'},
    {'id': 103, 'title': 'Sách khoa học', 'time': '1 tuần trước'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        title: const Text(
          'Lịch sử đọc',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w800,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _history.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = _history[index];
          return ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text(
              item['title'],
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            subtitle: Text(
              item['time'],
              style: const TextStyle(color: AppColors.textLight),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textLight,
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BookDetailScreen(
                  bookId: item['id'] as int,
                  heroTag: 'history_${item['id']}',
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
