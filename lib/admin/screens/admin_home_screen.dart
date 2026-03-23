import 'package:flutter/material.dart';
import 'package:librarybookshelf/theme/app_theme.dart';
import 'admin_book_list_screen.dart';
import 'admin_book_content_list_screen.dart';
import 'admin_profile_screen.dart';
import 'package:librarybookshelf/admin/widgets/admin_ui_components.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textDark,
            size: 18,
          ),
        ),
        title: const Text(
          'Bảng điều khiển Admin',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Quản lý',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 8),

              AdminMenuGroup(
                items: [
                  AdminMenuItem(
                    icon: Icons.auto_stories_rounded,
                    label: 'Quản lý sách',
                    sub: 'Thêm, sửa, xóa sách',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => const AdminBookListScreen(),
                        ),
                      );
                    },
                  ),
                  AdminMenuItem(
                    icon: Icons.library_books_rounded,
                    label: 'Quản lý nội dung',
                    sub: 'Thêm, sửa, xóa chương',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => const AdminBookContentListScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const Text(
                'Tài khoản',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 8),

              AdminMenuGroup(
                items: [
                  AdminMenuItem(
                    icon: Icons.person_outline_rounded,
                    label: 'Tài khoản Admin',
                    sub: 'Thông tin & đặt lại mật khẩu',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => const AdminProfileScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Quick actions row
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => const AdminBookListScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Thêm sách'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.card,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) =>
                                const AdminBookContentListScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.library_books_rounded, size: 18),
                      label: const Text('Nội dung'),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
