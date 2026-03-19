import 'package:flutter/material.dart';
import 'package:librarybookshelf/theme/app_theme.dart';
import 'package:librarybookshelf/admin/models/admin_user_model.dart';
import 'package:librarybookshelf/admin/services/admin_user_service.dart';
import 'package:librarybookshelf/admin/screens/admin_user_detail_screen.dart';
import '../../widgets/admin_user_tile.dart';

/// Tab User: danh sách user từ API, search + phân trang.
class AdminUsersTab extends StatefulWidget {
  const AdminUsersTab({super.key});

  @override
  State<AdminUsersTab> createState() => _AdminUsersTabState();
}

class _AdminUsersTabState extends State<AdminUsersTab> {
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();

  PagedUsersResponse? _data;
  Exception? _error;
  bool _isLoading = true;

  int _page = 1;
  static const int _pageSize = 20;
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final res = await AdminUserService.getUsers(
        page: _page,
        pageSize: _pageSize,
        searchTerm: _searchTerm.isEmpty ? null : _searchTerm,
      );
      if (mounted) {
        setState(() {
          _data = res;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e is Exception ? e : Exception(e.toString());
          _data = null;
          _isLoading = false;
        });
      }
    }
  }

  void _onSearch(String value) {
    _searchTerm = value.trim();
    _page = 1;
    _loadUsers();
  }

  void _goToPage(int page) {
    if (page < 1 || (_data != null && page > _data!.totalPages)) return;
    _page = page;
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Ô tìm kiếm
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocus,
            decoration: InputDecoration(
              hintText: 'Tìm theo tên, email, username...',
              hintStyle: const TextStyle(
                color: AppColors.textLight,
                fontSize: 14,
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: AppColors.textLight,
                size: 22,
              ),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 14,
            ),
            onSubmitted: _onSearch,
            onChanged: (value) {
              // Tìm khi gõ xong (debounce đơn giản: chỉ search khi submit)
            },
          ),
        ),
        // Nút tìm
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                _searchFocus.unfocus();
                _onSearch(_searchController.text);
              },
              icon: const Icon(Icons.search_rounded, size: 18),
              label: const Text('Tìm kiếm'),
              style: AppButtons.outlined,
            ),
          ),
        ),
        Expanded(
          child: _buildBody(),
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (_isLoading && _data == null) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.accent,
          strokeWidth: 2,
        ),
      );
    }
    if (_error != null && _data == null) {
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
                onPressed: _loadUsers,
                style: AppButtons.primary,
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }
    final items = _data?.items ?? <AdminUserModel>[];
    final totalCount = _data?.totalCount ?? 0;
    final totalPages = _data?.totalPages ?? 0;

    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.people_outline_rounded,
                size: 56,
                color: AppColors.textLight,
              ),
              const SizedBox(height: 16),
              Text(
                'Không có user nào',
                style: AppText.h4,
              ),
              const SizedBox(height: 8),
              Text(
                _searchTerm.isNotEmpty
                    ? 'Thử đổi từ khóa tìm kiếm.'
                    : 'Chưa có dữ liệu.',
                style: AppText.bodySmall.copyWith(color: AppColors.textLight),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadUsers,
      color: AppColors.accent,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          Text(
            'Tổng: $totalCount user',
            style: AppText.caption,
          ),
          const SizedBox(height: 12),
          ...items.map((u) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AdminUserTile(
                  user: u,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => AdminUserDetailScreen(userId: u.userId),
                      ),
                    );
                  },
                ),
              )),
          if (totalPages > 1) ...[
            const SizedBox(height: 16),
            _buildPagination(totalPages),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }

  Widget _buildPagination(int totalPages) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: _data?.hasPreviousPage == true
              ? () => _goToPage(_page - 1)
              : null,
          icon: const Icon(Icons.chevron_left_rounded),
          color: AppColors.textDark,
        ),
        const SizedBox(width: 8),
        Text(
          'Trang $_page / $totalPages',
          style: AppText.bodySmall,
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed:
              _data?.hasNextPage == true ? () => _goToPage(_page + 1) : null,
          icon: const Icon(Icons.chevron_right_rounded),
          color: AppColors.textDark,
        ),
      ],
    );
  }
}
