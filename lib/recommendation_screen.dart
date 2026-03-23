import 'package:flutter/material.dart';
import 'package:librarybookshelf/book_detail_screen.dart';
import 'package:librarybookshelf/theme/app_theme.dart';

class RecommendationScreen extends StatelessWidget {
  const RecommendationScreen({super.key});

  final List<Map<String, dynamic>> _samples = const [
    {'id': 1, 'title': 'Những người khốn khổ', 'author': 'Victor Hugo'},
    {'id': 2, 'title': 'Dế Mèn phiêu lưu ký', 'author': 'Tô Hoài'},
    {'id': 3, 'title': 'Sapiens', 'author': 'Yuval Noah Harari'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        title: const Text(
          'Gợi ý sách',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w800,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _samples.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = _samples[index];
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
              item['author'],
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
                  heroTag: 'recommend_${item['id']}',
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
