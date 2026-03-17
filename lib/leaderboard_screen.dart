// lib/screens/leaderboard_screen.dart

import 'package:flutter/material.dart';
import 'package:librarybookshelf/models/user_stats_model.dart';
import 'package:librarybookshelf/services/user_stats_service.dart';
import 'package:librarybookshelf/theme/app_theme.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Cache mỗi tab
  final Map<String, List<LeaderboardEntryModel>> _cache = {};
  final Map<String, bool> _loading = {
    'books': true,
    'streak': true,
    'pages': true,
    'hours': true,
  };

  final _tabs = const [
    ('books', '📚 Sách', 'cuốn'),
    ('streak', '🔥 Streak', 'ngày'),
    ('pages', '📄 Trang', 'trang'),
    ('hours', '⏱ Giờ', 'giờ'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        final type = _tabs[_tabController.index].$1;
        if (!_cache.containsKey(type)) _loadLeaderboard(type);
      }
    });
    _loadLeaderboard('books');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadLeaderboard(String type) async {
    setState(() => _loading[type] = true);
    final data = await UserStatsService.getLeaderboard(type: type);
    if (mounted) {
      setState(() {
        _cache[type] = data;
        _loading[type] = false;
      });
    }
  }

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
          'Bảng xếp hạng',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: AppColors.accent,
          unselectedLabelColor: AppColors.textLight,
          indicatorColor: AppColors.accent,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
          tabs: _tabs.map((t) => Tab(text: t.$2)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabs.map((t) => _buildTab(t.$1, t.$3)).toList(),
      ),
    );
  }

  Widget _buildTab(String type, String unit) {
    if (_loading[type] == true) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.accent,
          strokeWidth: 2,
        ),
      );
    }

    final entries = _cache[type] ?? [];
    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.leaderboard_outlined,
              color: AppColors.textLight,
              size: 48,
            ),
            const SizedBox(height: 12),
            const Text(
              'Chưa có dữ liệu',
              style: TextStyle(color: AppColors.textMid),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.accent,
      onRefresh: () => _loadLeaderboard(type),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          return _buildEntry(entry, unit);
        },
      ),
    );
  }

  Widget _buildEntry(LeaderboardEntryModel entry, String unit) {
    final isTop3 = entry.rank <= 3;
    final isMine = entry.isCurrentUser;
    final initial = entry.displayName.isNotEmpty
        ? entry.displayName[0].toUpperCase()
        : '?';

    final rankColor = switch (entry.rank) {
      1 => const Color(0xFFFFD700),
      2 => const Color(0xFFC0C0C0),
      3 => const Color(0xFFCD7F32),
      _ => AppColors.textLight,
    };

    final rankEmoji = switch (entry.rank) {
      1 => '🥇',
      2 => '🥈',
      3 => '🥉',
      _ => '#${entry.rank}',
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isMine
            ? AppColors.accent.withOpacity(0.08)
            : (isTop3 ? Colors.white : Colors.white),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isMine
              ? AppColors.accent.withOpacity(0.3)
              : (isTop3 ? rankColor.withOpacity(0.3) : AppColors.border),
          width: isMine || isTop3 ? 1.5 : 1,
        ),
        boxShadow: isTop3
            ? [
                BoxShadow(
                  color: rankColor.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          // Rank
          SizedBox(
            width: 36,
            child: Center(
              child: isTop3
                  ? Text(rankEmoji, style: const TextStyle(fontSize: 20))
                  : Text(
                      rankEmoji,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textLight,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),

          // Avatar
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isMine
                  ? AppColors.accent.withOpacity(0.15)
                  : AppColors.chip,
              borderRadius: BorderRadius.circular(12),
              border: isMine
                  ? Border.all(
                      color: AppColors.accent.withOpacity(0.4),
                      width: 1.5,
                    )
                  : null,
            ),
            child: entry.avatarUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      entry.avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Center(
                        child: Text(
                          initial,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: isMine
                                ? AppColors.accent
                                : AppColors.textMid,
                          ),
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      initial,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: isMine ? AppColors.accent : AppColors.textMid,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 12),

          // Name + rank title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        entry.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isMine ? AppColors.accent : AppColors.textDark,
                        ),
                      ),
                    ),
                    if (isMine) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Bạn',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  entry.rankTitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),

          // Value
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${entry.value}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isTop3 ? rankColor : AppColors.textDark,
                ),
              ),
              Text(
                unit,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
