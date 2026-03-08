import 'package:flutter/material.dart';
import 'package:librarybookshelf/theme/app_theme.dart';
// Import các màn hình con sau khi tạo
// import 'manage_users_screen.dart';
import 'book_detail_screen.dart';
// import 'create_book_screen.dart';
import 'create_book_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: AppColors.card,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildOptionCard(
              context,
              icon: Icons.people_alt_rounded,
              title: 'Quản lý người dùng',
              description: 'Xem, thêm, sửa, xóa người dùng',
              color: Colors.blue,
              onTap: () {
                // Điều hướng tới ManageUsersScreen
                Navigator.pushNamed(context, '/admin/users');
              },
            ),
            const SizedBox(height: 20),
            _buildOptionCard(
              context,
              icon: Icons.library_add_rounded,
              title: 'Tạo sách mới',
              description: 'Thêm sách và các chapter',
              color: Colors.green,
              onTap: () {
                // Điều hướng tới CreateBookScreen
                Navigator.pushNamed(context, '/admin/create-book');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.textDark.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, size: 40, color: color),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.accent,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
