import 'package:flutter/material.dart';
import 'package:librarybookshelf/theme/app_theme.dart';
import 'package:librarybookshelf/admin/models/admin_user_model.dart';
import 'package:librarybookshelf/admin/services/admin_user_service.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_user_detail_header.dart';
import '../widgets/admin_user_stats_section.dart';

/// Màn hình chi tiết user (admin): thông tin + thống kê đọc sách.
class AdminUserDetailScreen extends StatefulWidget {
  final int userId;

  const AdminUserDetailScreen({super.key, required this.userId});

  @override
  State<AdminUserDetailScreen> createState() => _AdminUserDetailScreenState();
}

class _AdminUserDetailScreenState extends State<AdminUserDetailScreen> {
  AdminUserModel? _user;
  Exception? _error;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final user = await AdminUserService.getUserById(widget.userId);
      if (mounted) {
        setState(() {
          _user = user;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e is Exception ? e : Exception(e.toString());
          _user = null;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AdminAppBar(
        title: 'Chi tiết user',
        showBackButton: true,
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _user == null) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.accent,
          strokeWidth: 2,
        ),
      );
    }
    if (_error != null && _user == null) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: Colors.red.shade400,
              ),
              const SizedBox(height: 12),
              Text(
                _error!.toString().replaceFirst('Exception: ', ''),
                textAlign: TextAlign.center,
                style: AppText.body.copyWith(color: Colors.red.shade700),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadUser,
                style: AppButtons.primary,
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }
    final user = _user!;
    return RefreshIndicator(
      onRefresh: _loadUser,
      color: AppColors.accent,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AdminUserDetailHeader(user: user),
            const SizedBox(height: 24),
            if (user.userStatsSummary != null)
              AdminUserStatsSection(stats: user.userStatsSummary!)
            else
              Container(
                padding: const EdgeInsets.symmetric(vertical: 32),
                decoration: AppDecorations.whiteCard,
                child: Column(
                  children: [
                    Icon(
                      Icons.bar_chart_rounded,
                      size: 48,
                      color: AppColors.textLight,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Chưa có thống kê đọc sách',
                      style: AppText.body.copyWith(color: AppColors.textLight),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
