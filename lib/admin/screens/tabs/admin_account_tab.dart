import 'package:flutter/material.dart';
import 'package:librarybookshelf/services/auther_service.dart';
import 'package:librarybookshelf/theme/app_theme.dart';
import 'package:librarybookshelf/admin/screens/admin_book_list_screen.dart';
import '../../widgets/admin_section_label.dart';
import '../../widgets/admin_menu_group.dart';
import '../../widgets/admin_menu_item.dart';
import '../../widgets/admin_profile_card.dart';

/// Tab Tài khoản: thông tin admin + menu (Quản lý sách, Đổi mật khẩu, Đăng xuất).
class AdminAccountTab extends StatefulWidget {
  const AdminAccountTab({super.key});

  @override
  State<AdminAccountTab> createState() => _AdminAccountTabState();
}

class _AdminAccountTabState extends State<AdminAccountTab> {
  Map<String, dynamic>? _userInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final info = await AuthService.getUserInfo();
    if (mounted) {
      setState(() {
        _userInfo = info;
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Đăng xuất",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        content: const Text(
          "Bạn có chắc muốn đăng xuất không?",
          style: TextStyle(color: AppColors.textMid),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              "Huỷ",
              style: TextStyle(color: AppColors.textLight),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: const Text(
              "Đăng xuất",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await AuthService.logout();
      if (mounted) Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  void _showChangePassword() {
    // TODO: mở bottom sheet đổi mật khẩu (logic giống AdminProfileScreen)
    AppSnack.show(context, "Chức năng đổi mật khẩu", isSuccess: true);
  }

  void _showEditProfile() {
    // TODO: mở bottom sheet sửa thông tin
    AppSnack.show(context, "Chức năng sửa thông tin", isSuccess: true);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.accent,
          strokeWidth: 2,
        ),
      );
    }

    final username = _userInfo?['username'] ?? 'Người dùng';
    final fullName = _userInfo?['fullName'] ?? username;
    final email = _userInfo?['email'] ?? '';

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminProfileCard(
            fullName: fullName,
            email: email,
            username: username,
            onTap: _showEditProfile,
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AdminSectionLabel("TÀI KHOẢN"),
                const SizedBox(height: 8),
                AdminMenuGroup(
                  items: [
                    AdminMenuItem(
                      icon: Icons.person_outline_rounded,
                      label: "Thông tin cá nhân",
                      sub: "@$username",
                      onTap: _showEditProfile,
                    ),
                    AdminMenuItem(
                      icon: Icons.lock_outline_rounded,
                      label: "Đổi mật khẩu",
                      sub: "Cập nhật mật khẩu bảo mật",
                      onTap: _showChangePassword,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const AdminSectionLabel("QUẢN LÝ"),
                const SizedBox(height: 8),
                AdminMenuGroup(
                  items: [
                    AdminMenuItem(
                      icon: Icons.auto_stories_rounded,
                      label: "Quản lý sách",
                      sub: "Thêm, sửa, xóa sách",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => const AdminBookListScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _logout,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.red.shade100),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.logout_rounded,
                          color: Colors.red.shade400,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Đăng xuất",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.red.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 36),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
