import 'package:flutter/material.dart';
import 'package:librarybookshelf/services/auther_service.dart';
import 'package:librarybookshelf/theme/app_theme.dart';
import 'package:librarybookshelf/saved_books_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _userInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final info = await AuthService.getUserInfo();
    setState(() {
      _userInfo = info;
      _isLoading = false;
    });
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
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
      if (mounted) Navigator.of(context).pop(); // Quay về HomeScreen
    }
  }

  void _showChangePassword() {
    final oldCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    bool obscureOld = true, obscureNew = true, obscureConfirm = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            20,
            24,
            MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SheetHandle(),
              const SizedBox(height: 20),
              const Text(
                "Đổi mật khẩu",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 20),
              _PassField(
                ctrl: oldCtrl,
                label: "Mật khẩu hiện tại",
                obscure: obscureOld,
                onToggle: () => setModal(() => obscureOld = !obscureOld),
              ),
              const SizedBox(height: 12),
              _PassField(
                ctrl: newCtrl,
                label: "Mật khẩu mới",
                obscure: obscureNew,
                onToggle: () => setModal(() => obscureNew = !obscureNew),
              ),
              const SizedBox(height: 12),
              _PassField(
                ctrl: confirmCtrl,
                label: "Xác nhận mật khẩu mới",
                obscure: obscureConfirm,
                onToggle: () =>
                    setModal(() => obscureConfirm = !obscureConfirm),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (newCtrl.text != confirmCtrl.text) {
                      AppSnack.show(
                        ctx,
                        "Mật khẩu xác nhận không khớp",
                        isError: true,
                      );
                      return;
                    }
                    // TODO: gọi API đổi mật khẩu
                    Navigator.pop(ctx);
                    AppSnack.show(
                      context,
                      "Đổi mật khẩu thành công",
                      isSuccess: true,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.card,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Xác nhận",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditProfile() {
    final nameCtrl = TextEditingController(text: _userInfo?['fullName'] ?? '');
    final emailCtrl = TextEditingController(text: _userInfo?['email'] ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          20,
          24,
          MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SheetHandle(),
            const SizedBox(height: 20),
            const Text(
              "Thông tin cá nhân",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 20),
            _InputField(
              ctrl: nameCtrl,
              label: "Họ và tên",
              icon: Icons.person_outline_rounded,
            ),
            const SizedBox(height: 12),
            _InputField(
              ctrl: emailCtrl,
              label: "Email",
              icon: Icons.email_outlined,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: gọi API cập nhật
                  Navigator.pop(ctx);
                  AppSnack.show(
                    context,
                    "Cập nhật thành công",
                    isSuccess: true,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.card,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Lưu thay đổi",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTerms() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        builder: (_, sc) => Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SheetHandle(),
              const SizedBox(height: 16),
              const Text(
                "Điều khoản sử dụng",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  controller: sc,
                  children: const [
                    _TermSection(
                      "1. Chấp nhận điều khoản",
                      "Bằng cách sử dụng BookShelf, bạn đồng ý tuân thủ các điều khoản này.",
                    ),
                    _TermSection(
                      "2. Quyền sở hữu trí tuệ",
                      "Mọi nội dung trong ứng dụng thuộc sở hữu của BookShelf hoặc được cấp phép hợp lệ.",
                    ),
                    _TermSection(
                      "3. Tài khoản người dùng",
                      "Bạn có trách nhiệm bảo mật tài khoản. Không chia sẻ mật khẩu với người khác.",
                    ),
                    _TermSection(
                      "4. Bảo mật dữ liệu",
                      "Chúng tôi cam kết bảo vệ dữ liệu cá nhân. Dữ liệu được mã hoá và không chia sẻ bên thứ ba.",
                    ),
                    _TermSection(
                      "5. Giới hạn trách nhiệm",
                      "BookShelf không chịu trách nhiệm về thiệt hại phát sinh từ việc sử dụng dịch vụ.",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAbout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.auto_stories,
                color: AppColors.accent,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "BookShelf",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Phiên bản 1.0.0",
              style: TextStyle(color: AppColors.textLight, fontSize: 13),
            ),
            const SizedBox(height: 12),
            const Text(
              "Ứng dụng thư viện sách cá nhân.\nĐọc sách mọi lúc, mọi nơi.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textMid,
                fontSize: 13,
                height: 1.6,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              "Đóng",
              style: TextStyle(color: AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.accent,
            strokeWidth: 2,
          ),
        ),
      );
    }

    final username = _userInfo?['username'] ?? 'Người dùng';
    final fullName = _userInfo?['fullName'] ?? username;
    final email = _userInfo?['email'] ?? '';
    final role = _userInfo?['role'] ?? 'user';
    final initial = fullName.isNotEmpty ? fullName[0].toUpperCase() : 'U';

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ── HEADER ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 20, 0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.textDark,
                        size: 18,
                      ),
                    ),
                    const Text(
                      "Tài khoản",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),

              // ── PROFILE CARD ───────────────────────────────────────
              GestureDetector(
                onTap: _showEditProfile,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      // Avatar chữ cái đầu
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
                              child: Text(
                                role == 'admin'
                                    ? '👑  Admin'
                                    : '📚  Thành viên',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.accent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.edit_outlined,
                        color: AppColors.textLight,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),

              // ── STATS ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    _StatCard("Đang đọc", "3", Icons.auto_stories_outlined),
                    const SizedBox(width: 10),
                    _StatCard(
                      "Đã xong",
                      "12",
                      Icons.check_circle_outline_rounded,
                    ),
                    const SizedBox(width: 10),
                    _StatCard("Yêu thích", "5", Icons.favorite_border_rounded),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── MENU ───────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tài khoản
                    _SectionLabel("TÀI KHOẢN"),
                    const SizedBox(height: 8),
                    _MenuGroup(
                      items: [
                        _MenuItem(
                          icon: Icons.person_outline_rounded,
                          label: "Thông tin cá nhân",
                          sub: "@$username",
                          onTap: _showEditProfile,
                        ),
                        _MenuItem(
                          icon: Icons.lock_outline_rounded,
                          label: "Đổi mật khẩu",
                          sub: "Cập nhật mật khẩu bảo mật",
                          onTap: _showChangePassword,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    _SectionLabel("THƯ VIỆN"),
                    const SizedBox(height: 8),
                    _MenuGroup(
                      items: [
                        _MenuItem(
                          icon: Icons.history_rounded,
                          label: "Lịch sử đọc",
                          sub: "Các sách bạn đã đọc gần đây",
                          onTap: () => AppSnack.show(
                            context,
                            "Tính năng đang phát triển",
                          ),
                        ),
                        // _MenuItem(
                        //   icon: Icons.bookmark_outline_rounded,
                        //   label: "Sách đã lưu",
                        //   sub: "Danh sách yêu thích của bạn",
                        //   onTap: () => AppSnack.show(
                        //     context,
                        //     "Tính năng đang phát triển",
                        //   ),
                        // ),

                        // Thay thế đoạn code _MenuItem của sách đã lưu
                        _MenuItem(
                          icon: Icons.bookmark_outline_rounded,
                          label: "Sách đã lưu",
                          sub: "Danh sách yêu thích của bạn",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SavedBooksScreen(),
                              ),
                            );
                          },
                        ),

                        _MenuItem(
                          icon: Icons.download_outlined,
                          label: "Đã tải xuống",
                          sub: "Quản lý sách offline",
                          onTap: () => AppSnack.show(
                            context,
                            "Tính năng đang phát triển",
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    _SectionLabel("HỖ TRỢ"),
                    const SizedBox(height: 8),
                    _MenuGroup(
                      items: [
                        _MenuItem(
                          icon: Icons.description_outlined,
                          label: "Điều khoản sử dụng",
                          onTap: _showTerms,
                        ),
                        _MenuItem(
                          icon: Icons.privacy_tip_outlined,
                          label: "Chính sách bảo mật",
                          onTap: () => AppSnack.show(
                            context,
                            "Tính năng đang phát triển",
                          ),
                        ),
                        _MenuItem(
                          icon: Icons.help_outline_rounded,
                          label: "Trợ giúp & Phản hồi",
                          onTap: () => AppSnack.show(
                            context,
                            "Tính năng đang phát triển",
                          ),
                        ),
                        _MenuItem(
                          icon: Icons.info_outline_rounded,
                          label: "Về ứng dụng",
                          sub: "BookShelf v1.0.0",
                          onTap: _showAbout,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Nút đăng xuất
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
        ),
      ),
    );
  }
}

// ── HELPER WIDGETS ────────────────────────────────────────────────────

class _SheetHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      width: 36,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(2),
      ),
    ),
  );
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  const _StatCard(this.label, this.value, this.icon);

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.accent, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: AppColors.textLight),
          ),
        ],
      ),
    ),
  );
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: AppColors.textLight,
      letterSpacing: 1.2,
    ),
  );
}

class _MenuGroup extends StatelessWidget {
  final List<_MenuItem> items;
  const _MenuGroup({required this.items});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      children: items.asMap().entries.map((e) {
        final isLast = e.key == items.length - 1;
        return Column(
          children: [
            e.value,
            if (!isLast)
              const Divider(
                height: 1,
                color: AppColors.divider,
                indent: 52,
                endIndent: 0,
              ),
          ],
        );
      }).toList(),
    ),
  );
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? sub;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    this.sub,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(14),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.chip,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.textMid, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                if (sub != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    sub!,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textLight,
            size: 18,
          ),
        ],
      ),
    ),
  );
}

class _PassField extends StatelessWidget {
  final TextEditingController ctrl;
  final String label;
  final bool obscure;
  final VoidCallback onToggle;
  const _PassField({
    required this.ctrl,
    required this.label,
    required this.obscure,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AppColors.bg,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.border),
    ),
    child: TextField(
      controller: ctrl,
      obscureText: obscure,
      style: const TextStyle(color: AppColors.textDark, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textLight, fontSize: 13),
        prefixIcon: const Icon(
          Icons.lock_outline_rounded,
          color: AppColors.textLight,
          size: 18,
        ),
        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: Icon(
            obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: AppColors.textLight,
            size: 18,
          ),
        ),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ),
  );
}

class _InputField extends StatelessWidget {
  final TextEditingController ctrl;
  final String label;
  final IconData icon;
  const _InputField({
    required this.ctrl,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AppColors.bg,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.border),
    ),
    child: TextField(
      controller: ctrl,
      style: const TextStyle(color: AppColors.textDark, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textLight, fontSize: 13),
        prefixIcon: Icon(icon, color: AppColors.textLight, size: 18),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ),
  );
}

class _TermSection extends StatelessWidget {
  final String title, content;
  const _TermSection(this.title, this.content);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          content,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textMid,
            height: 1.6,
          ),
        ),
      ],
    ),
  );
}
