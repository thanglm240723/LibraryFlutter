import 'package:flutter/material.dart';
import 'package:librarybookshelf/models/user_stats_model.dart';
import 'package:librarybookshelf/services/auther_service.dart';
import 'package:librarybookshelf/services/user_stats_service.dart';
import 'package:librarybookshelf/services/profile_service.dart';
import 'package:librarybookshelf/theme/app_theme.dart';
import 'package:librarybookshelf/saved_books_screen.dart';
import 'package:librarybookshelf/leaderboard_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _userInfo;
  UserStatsModel? _stats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() => _isLoading = true);
    final results = await Future.wait([
      AuthService.getUserInfo(),
      UserStatsService.getMyStats(),
    ]);
    if (!mounted) return;
    setState(() {
      _userInfo = results[0] as Map<String, dynamic>?;
      _stats = results[1] as UserStatsModel?;
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
          'Đăng xuất',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        content: const Text(
          'Bạn có chắc muốn đăng xuất không?',
          style: TextStyle(color: AppColors.textMid),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Huỷ',
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
              'Đăng xuất',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await AuthService.logout();
      if (mounted) Navigator.of(context).pop();
    }
  }

  // ── Thông tin cá nhân — gọi API thật ─────────────────────────────
  void _showEditProfile() {
    final nameCtrl = TextEditingController(text: _userInfo?['fullName'] ?? '');
    final emailCtrl = TextEditingController(text: _userInfo?['email'] ?? '');
    bool isLoading = false;

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
                'Thông tin cá nhân',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 20),
              _InputField(
                ctrl: nameCtrl,
                label: 'Họ và tên',
                icon: Icons.person_outline_rounded,
              ),
              const SizedBox(height: 12),
              _InputField(
                ctrl: emailCtrl,
                label: 'Email',
                icon: Icons.email_outlined,
                keyboard: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          final name = nameCtrl.text.trim();
                          final email = emailCtrl.text.trim();
                          if (name.isEmpty && email.isEmpty) {
                            AppSnack.show(
                              ctx,
                              'Vui lòng nhập thông tin cần sửa',
                              isError: true,
                            );
                            return;
                          }
                          setModal(() => isLoading = true);
                          try {
                            await ProfileService.updateProfile(
                              fullName: name.isNotEmpty ? name : null,
                              email: email.isNotEmpty ? email : null,
                            );
                            if (ctx.mounted) Navigator.pop(ctx);
                            // Reload userInfo local + stats
                            if (mounted) {
                              AppSnack.show(
                                context,
                                'Cập nhật thành công',
                                isSuccess: true,
                              );
                              _loadAll();
                            }
                          } catch (e) {
                            setModal(() => isLoading = false);
                            if (ctx.mounted) {
                              AppSnack.show(
                                ctx,
                                e.toString().replaceAll('Exception: ', ''),
                                isError: true,
                              );
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.card,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: AppColors.accent,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Lưu thay đổi',
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

  // ── Đổi mật khẩu — gọi API thật ──────────────────────────────────
  void _showChangePassword() {
    final oldCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    bool obscureOld = true, obscureNew = true, obscureConfirm = true;
    bool isLoading = false;

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
                'Đổi mật khẩu',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 20),
              _PassField(
                ctrl: oldCtrl,
                label: 'Mật khẩu hiện tại',
                obscure: obscureOld,
                onToggle: () => setModal(() => obscureOld = !obscureOld),
              ),
              const SizedBox(height: 12),
              _PassField(
                ctrl: newCtrl,
                label: 'Mật khẩu mới (≥6 ký tự)',
                obscure: obscureNew,
                onToggle: () => setModal(() => obscureNew = !obscureNew),
              ),
              const SizedBox(height: 12),
              _PassField(
                ctrl: confirmCtrl,
                label: 'Xác nhận mật khẩu mới',
                obscure: obscureConfirm,
                onToggle: () =>
                    setModal(() => obscureConfirm = !obscureConfirm),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (oldCtrl.text.isEmpty || newCtrl.text.isEmpty) {
                            AppSnack.show(
                              ctx,
                              'Vui lòng nhập đầy đủ',
                              isError: true,
                            );
                            return;
                          }
                          if (newCtrl.text.length < 6) {
                            AppSnack.show(
                              ctx,
                              'Mật khẩu mới phải ít nhất 6 ký tự',
                              isError: true,
                            );
                            return;
                          }
                          if (newCtrl.text != confirmCtrl.text) {
                            AppSnack.show(
                              ctx,
                              'Mật khẩu xác nhận không khớp',
                              isError: true,
                            );
                            return;
                          }
                          setModal(() => isLoading = true);
                          final ok = await ProfileService.changePassword(
                            currentPassword: oldCtrl.text,
                            newPassword: newCtrl.text,
                          );
                          setModal(() => isLoading = false);
                          if (ctx.mounted) Navigator.pop(ctx);
                          if (mounted) {
                            if (ok) {
                              AppSnack.show(
                                context,
                                'Đổi mật khẩu thành công',
                                isSuccess: true,
                              );
                            } else {
                              AppSnack.show(
                                context,
                                'Mật khẩu hiện tại không đúng',
                                isError: true,
                              );
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.card,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: AppColors.accent,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Xác nhận',
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

  // ── Lịch sử đọc — hiện bottom sheet đơn giản ─────────────────────
  void _showReadingHistory() async {
    final history = await ProfileService.getReadingHistory();

    if (!mounted) return;
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
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SheetHandle(),
              const SizedBox(height: 16),
              const Text(
                'Lịch sử đọc',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              if (history.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text(
                      'Chưa có lịch sử đọc.',
                      style: TextStyle(color: AppColors.textMid),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    controller: sc,
                    itemCount: history.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: AppColors.divider),
                    itemBuilder: (_, i) {
                      final h = history[i];
                      final mins = h['minutesRead'] ?? 0;
                      final title = h['bookTitle'] ?? 'Không rõ';
                      final cover = h['bookCover'] as String?;
                      final readAt = h['readAt'] != null
                          ? DateTime.tryParse(h['readAt'])
                          : null;
                      final dateStr = readAt != null
                          ? '${readAt.day}/${readAt.month}/${readAt.year}'
                          : '';
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 0,
                        ),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: cover != null
                              ? Image.network(
                                  cover,
                                  width: 40,
                                  height: 54,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      _bookPlaceholder(),
                                )
                              : _bookPlaceholder(),
                        ),
                        title: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                        subtitle: Text(
                          '$mins phút  ·  $dateStr',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textLight,
                          ),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accentL,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '$mins ph',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bookPlaceholder() => Container(
    width: 40,
    height: 54,
    color: AppColors.accentL,
    child: const Icon(
      Icons.menu_book_rounded,
      color: AppColors.accent,
      size: 20,
    ),
  );

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
    final initial = fullName.isNotEmpty ? fullName[0].toUpperCase() : 'U';

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.accent,
          onRefresh: _loadAll,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                        'Tài khoản',
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
                                  _stats != null
                                      ? '📚  ${_stats!.rank}'
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

                // ── STATS CARDS ────────────────────────────────────────
                if (_stats != null) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Row(
                      children: [
                        _StatCard(
                          'Đã đọc',
                          '${_stats!.totalBooksRead}',
                          Icons.check_circle_outline_rounded,
                        ),
                        const SizedBox(width: 10),
                        _StatCard(
                          'Đang đọc',
                          '${_stats!.booksInProgress}',
                          Icons.auto_stories_outlined,
                        ),
                        const SizedBox(width: 10),
                        _StatCard(
                          'Streak',
                          '${_stats!.currentStreak}🔥',
                          Icons.local_fire_department_outlined,
                        ),
                      ],
                    ),
                  ),

                  // ── Detail stats ──────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          _StatsRow(
                            icon: Icons.menu_book_rounded,
                            label: 'Tổng trang đã đọc',
                            value: '${_stats!.totalPagesRead} trang',
                          ),
                          const Divider(height: 20, color: AppColors.divider),
                          _StatsRow(
                            icon: Icons.timer_outlined,
                            label: 'Tổng giờ đọc',
                            // Hiển thị "0 giờ" thay vì số lớn bất thường
                            value: _stats!.totalMinutesRead > 0
                                ? '${_stats!.totalHoursRead} giờ'
                                : '0 giờ',
                          ),
                          const Divider(height: 20, color: AppColors.divider),
                          _StatsRow(
                            icon: Icons.text_fields_rounded,
                            label: 'Tổng từ đã đọc',
                            value: _stats!.totalWordsRead > 0
                                ? _stats!.totalWordsReadLabel
                                : '0 từ',
                          ),
                          if (_stats!.favoriteGenre != null) ...[
                            const Divider(height: 20, color: AppColors.divider),
                            _StatsRow(
                              icon: Icons.favorite_outline_rounded,
                              label: 'Thể loại yêu thích',
                              value: _stats!.favoriteGenre!,
                            ),
                          ],
                          if (_stats!.nextRank != null) ...[
                            const Divider(height: 20, color: AppColors.divider),
                            _StatsRow(
                              icon: Icons.trending_up_rounded,
                              label:
                                  'Còn ${_stats!.booksToNextRank} cuốn → ${_stats!.nextRank}',
                              value: '',
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // ── Badges ─────────────────────────────────────────────
                  if (_stats!.badges.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'HUY HIỆU',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textLight,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _stats!.badges
                                .where((b) => b.isEarned)
                                .map((b) => _BadgeChip(badge: b))
                                .toList(),
                          ),
                          if (_stats!.badges.any((b) => !b.isEarned)) ...[
                            const SizedBox(height: 12),
                            const Text(
                              'Chưa đạt được',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textLight,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _stats!.badges
                                  .where((b) => !b.isEarned)
                                  .take(6)
                                  .map(
                                    (b) => _BadgeChip(badge: b, locked: true),
                                  )
                                  .toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
                ],

                const SizedBox(height: 20),

                // ── MENU ───────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SectionLabel('TÀI KHOẢN'),
                      const SizedBox(height: 8),
                      _MenuGroup(
                        items: [
                          _MenuItem(
                            icon: Icons.person_outline_rounded,
                            label: 'Thông tin cá nhân',
                            sub: '@$username',
                            onTap: _showEditProfile,
                          ),
                          _MenuItem(
                            icon: Icons.lock_outline_rounded,
                            label: 'Đổi mật khẩu',
                            sub: 'Cập nhật mật khẩu bảo mật',
                            onTap: _showChangePassword,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      const _SectionLabel('THƯ VIỆN'),
                      const SizedBox(height: 8),
                      _MenuGroup(
                        items: [
                          _MenuItem(
                            icon: Icons.bookmark_outline_rounded,
                            label: 'Sách đã lưu',
                            sub: 'Danh sách yêu thích',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SavedBooksScreen(),
                              ),
                            ),
                          ),
                          // ── Lịch sử đọc — không code màn mới ────────────
                          _MenuItem(
                            icon: Icons.history_rounded,
                            label: 'Lịch sử đọc',
                            sub: 'Các phiên đọc gần đây',
                            onTap: _showReadingHistory,
                          ),
                          _MenuItem(
                            icon: Icons.leaderboard_rounded,
                            label: 'Bảng xếp hạng',
                            sub: 'So sánh với cộng đồng',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LeaderboardScreen(),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      const _SectionLabel('HỖ TRỢ'),
                      const SizedBox(height: 8),
                      _MenuGroup(
                        items: [
                          _MenuItem(
                            icon: Icons.info_outline_rounded,
                            label: 'Về ứng dụng',
                            sub: 'BookShelf v1.0.0',
                            onTap: () => _showAbout(),
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
                                'Đăng xuất',
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
              'BookShelf',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Phiên bản 1.0.0',
              style: TextStyle(color: AppColors.textLight, fontSize: 13),
            ),
            const SizedBox(height: 12),
            const Text(
              'Ứng dụng thư viện sách cá nhân.\nĐọc sách mọi lúc, mọi nơi.',
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
              'Đóng',
              style: TextStyle(color: AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }
}

// ── HELPER WIDGETS ────────────────────────────────────────────────────

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
              fontSize: 16,
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

class _StatsRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _StatsRow({
    required this.icon,
    required this.label,
    required this.value,
  });
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.chip,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.accent, size: 16),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.textMid),
        ),
      ),
      if (value.isNotEmpty)
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
    ],
  );
}

class _BadgeChip extends StatelessWidget {
  final BadgeModel badge;
  final bool locked;
  const _BadgeChip({required this.badge, this.locked = false});
  @override
  Widget build(BuildContext context) => Tooltip(
    message: badge.description ?? badge.name,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: locked ? AppColors.chip : AppColors.accentL,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: locked ? AppColors.border : AppColors.accent.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            locked ? '🔒' : badge.icon,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 6),
          Text(
            badge.name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: locked ? AppColors.textLight : AppColors.textDark,
            ),
          ),
        ],
      ),
    ),
  );
}

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
              const Divider(height: 1, color: AppColors.divider, indent: 52),
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
  final TextInputType? keyboard;
  const _InputField({
    required this.ctrl,
    required this.label,
    required this.icon,
    this.keyboard,
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
      keyboardType: keyboard,
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
