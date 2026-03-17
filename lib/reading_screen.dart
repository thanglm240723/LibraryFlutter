// lib/reading_screen.dart
// ── FIX: xóa import dart:io và http không dùng ──────────────────────

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:librarybookshelf/models/reading_screen_model.dart';
import 'package:librarybookshelf/models/user_stats_model.dart';
import 'package:librarybookshelf/services/reading_progress_service.dart';
import 'package:librarybookshelf/services/reading_service.dart';
import 'package:librarybookshelf/services/auther_service.dart';
import 'package:librarybookshelf/theme/app_theme.dart';

class ReadingScreen extends StatefulWidget {
  final int bookId;
  final String bookTitle;
  final int initialChapter;

  const ReadingScreen({
    super.key,
    required this.bookId,
    required this.bookTitle,
    this.initialChapter = 1,
  });

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  final _service = ReadingService();
  final _scrollController = ScrollController();

  late int _currentChapter;
  int _totalChapters = 0;
  List<ChapterListItem> _chapterList = [];
  ChapterContent? _currentContent;
  bool _isLoading = true;
  bool _isEndOfBook = false;

  double _fontSize = 16.0;
  bool _isDarkMode = false;
  bool _showSettings = false;

  Color get _bg =>
      _isDarkMode ? const Color(0xFF181410) : const Color(0xFFFAF7F2);
  Color get _surface => _isDarkMode ? const Color(0xFF242018) : Colors.white;
  Color get _textPrimary =>
      _isDarkMode ? const Color(0xFFE8DDD0) : const Color(0xFF1C1712);
  Color get _textSub =>
      _isDarkMode ? const Color(0xFF8A7A6A) : const Color(0xFFA89880);
  Color get _border =>
      _isDarkMode ? const Color(0xFF3A3028) : const Color(0xFFE0D8CC);
  static const _accent = Color(0xFFD4A853);

  @override
  void initState() {
    super.initState();
    _currentChapter = widget.initialChapter;
    _loadAll();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Future<void> _loadAll() async {
    setState(() => _isLoading = true);
    try {
      final list = await _service.fetchChapterList(widget.bookId);
      setState(() {
        _chapterList = list;
        _totalChapters = list.length;
      });
      await _loadChapterContent(_currentChapter);
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnack('Lỗi tải dữ liệu: $e');
    }
  }

  Future<void> _loadChapter(int chapterNumber) async {
    if (chapterNumber < 1) return;
    setState(() => _isLoading = true);
    await _loadChapterContent(chapterNumber);
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> _loadChapterContent(int chapterNumber) async {
    try {
      final content = await _service.fetchChapter(widget.bookId, chapterNumber);

      if (content == null) {
        setState(() {
          _isEndOfBook = true;
          _isLoading = false;
          _showSettings = false;
        });
        return;
      }

      setState(() {
        _currentChapter = chapterNumber;
        _currentContent = content;
        _isLoading = false;
        _isEndOfBook = false;
        _showSettings = false;
      });

      // Lưu tiến trình + xử lý gamification
      await _saveProgress(chapterNumber);
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnack('Lỗi tải chương: $e');
    }
  }

  Future<void> _saveProgress(int chapter) async {
    final result = await ReadingProgressService.saveProgress(
      bookId: widget.bookId,
      currentChapter: chapter,
    );

    // ── Hiện popup nếu có reward mới ────────────────────────────────
    if (result.hasReward && mounted) {
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) _showRewardPopup(result.gamification!);
    }
  }

  // ── Popup thông báo badge/rank/hoàn thành sách ───────────────────
  void _showRewardPopup(GamificationResultModel gam) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Sách hoàn thành ──────────────────────────────────────
            if (gam.bookJustCompleted) ...[
              const Text('🎉', style: TextStyle(fontSize: 40)),
              const SizedBox(height: 8),
              Text(
                'Hoàn thành sách!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Bạn đã đọc ≥70% — cuốn sách này được tính vào thư viện',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: _textSub),
              ),
              const SizedBox(height: 16),
            ],

            // ── Lên rank ────────────────────────────────────────────
            if (gam.newRank != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _accent.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('👑', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lên cấp!',
                          style: TextStyle(fontSize: 11, color: _textSub),
                        ),
                        Text(
                          gam.newRank!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: _accent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // ── Badges mới ──────────────────────────────────────────
            if (gam.newBadges.isNotEmpty) ...[
              Text(
                'Huy hiệu mới!',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: gam.newBadges
                    .map(
                      (b) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _accent.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: _accent.withOpacity(0.25)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(b.icon, style: const TextStyle(fontSize: 18)),
                            const SizedBox(width: 6),
                            Text(
                              b.name,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: _textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 12),
            ],

            // ── Streak ──────────────────────────────────────────────
            if (gam.currentStreak > 1)
              Text(
                '🔥 Streak: ${gam.currentStreak} ngày liên tiếp',
                style: TextStyle(fontSize: 13, color: _textSub),
              ),

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1C1712),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Tiếp tục đọc',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1C1712),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  double get _progressValue =>
      _totalChapters > 0 ? _currentChapter / _totalChapters : 0;

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final botPad = MediaQuery.of(context).padding.bottom;

    if (_isLoading && _currentContent == null && !_isEndOfBook) {
      return Scaffold(
        backgroundColor: _bg,
        body: const Center(
          child: CircularProgressIndicator(color: _accent, strokeWidth: 2),
        ),
      );
    }

    if (_isEndOfBook) {
      return Scaffold(
        backgroundColor: _bg,
        appBar: AppBar(
          backgroundColor: _bg,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: _textPrimary,
              size: 18,
            ),
          ),
          title: Text(
            widget.bookTitle,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: _textPrimary,
            ),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5E6C8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    color: _accent,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Hết nội dung hiện có',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: _textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Bạn đã đọc đến chương $_currentChapter.\nNội dung tiếp theo chưa được cập nhật.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: _textSub, height: 1.6),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C1712),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Quay về',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.fromLTRB(
              24,
              topPad + 64,
              24,
              botPad + (_showSettings ? 220 : 160),
            ),
            child: _currentContent == null
                ? const SizedBox.shrink()
                : _buildBody(_currentContent!),
          ),
          Positioned(top: 0, left: 0, right: 0, child: _buildTopBar(topPad)),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomBar(botPad),
          ),
          if (_isLoading)
            Container(
              color: _bg.withOpacity(0.7),
              child: const Center(
                child: CircularProgressIndicator(
                  color: _accent,
                  strokeWidth: 2,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBody(ChapterContent chapter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CHƯƠNG ${chapter.chapterNumber}',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: _accent,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 10),
        if (chapter.chapterTitle != null)
          Text(
            chapter.chapterTitle!,
            style: TextStyle(
              fontSize: _fontSize + 8,
              fontWeight: FontWeight.w800,
              color: _textPrimary,
              height: 1.25,
              letterSpacing: -0.5,
            ),
          ),
        const SizedBox(height: 8),
        if (chapter.wordCount != null)
          Text(
            '${chapter.wordCount} từ  ·  ~${((chapter.wordCount ?? 0) / 200).ceil()} phút đọc',
            style: TextStyle(fontSize: 12, color: _textSub),
          ),
        const SizedBox(height: 28),
        Row(
          children: [
            Container(width: 32, height: 2, color: _accent),
            const SizedBox(width: 6),
            Container(width: 8, height: 2, color: _accent.withOpacity(0.35)),
          ],
        ),
        const SizedBox(height: 28),
        ...chapter.content.split('\n\n').map((p) {
          if (p.trim().isEmpty) return const SizedBox(height: 8);
          return Padding(
            padding: const EdgeInsets.only(bottom: 22),
            child: Text(
              p.trim(),
              style: TextStyle(
                fontSize: _fontSize,
                color: _textPrimary,
                height: 1.9,
                letterSpacing: 0.15,
              ),
              textAlign: TextAlign.justify,
            ),
          );
        }),
        const SizedBox(height: 40),
        _buildEndOfChapterNav(),
      ],
    );
  }

  Widget _buildTopBar(double topPad) {
    return Container(
      padding: EdgeInsets.fromLTRB(4, topPad + 4, 4, 8),
      decoration: BoxDecoration(
        color: _surface.withOpacity(0.97),
        border: Border(bottom: BorderSide(color: _border, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(_isDarkMode ? 0.3 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _TapIcon(
            icon: Icons.arrow_back_ios_new_rounded,
            color: _textPrimary,
            onTap: () => Navigator.pop(context),
          ),
          _ChapterNavBtn(
            icon: Icons.chevron_left_rounded,
            label: 'Trước',
            enabled: _currentChapter > 1,
            onTap: () => _loadChapter(_currentChapter - 1),
            textColor: _textPrimary,
            border: _border,
            isDark: _isDarkMode,
          ),
          Expanded(
            child: GestureDetector(
              onTap: _showChapterList,
              child: Column(
                children: [
                  Text(
                    widget.bookTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Ch.$_currentChapter/$_totalChapters',
                        style: TextStyle(fontSize: 11, color: _textSub),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 14,
                        color: _accent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _ChapterNavBtn(
            icon: Icons.chevron_right_rounded,
            label: 'Sau',
            enabled: _currentChapter < _totalChapters,
            onTap: () => _loadChapter(_currentChapter + 1),
            textColor: _textPrimary,
            border: _border,
            isDark: _isDarkMode,
            isNext: true,
          ),
          _TapIcon(
            icon: Icons.tune_rounded,
            color: _showSettings ? _accent : _textPrimary,
            onTap: () => setState(() => _showSettings = !_showSettings),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(double botPad) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      padding: EdgeInsets.fromLTRB(16, 10, 16, botPad + 10),
      decoration: BoxDecoration(
        color: _surface.withOpacity(0.97),
        border: Border(top: BorderSide(color: _border, width: 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                '${(_progressValue * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _accent,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _progressValue,
                    backgroundColor: _border,
                    valueColor: const AlwaysStoppedAnimation(_accent),
                    minHeight: 3,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Ch.$_currentChapter/$_totalChapters',
                style: TextStyle(fontSize: 11, color: _textSub),
              ),
            ],
          ),
          if (_showSettings) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _bg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _border),
              ),
              child: Row(
                children: [
                  Text(
                    'Giao diện',
                    style: TextStyle(fontSize: 12, color: _textSub),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => setState(() => _isDarkMode = false),
                    child: _ModeBtn(
                      icon: Icons.light_mode_rounded,
                      label: 'Sáng',
                      active: !_isDarkMode,
                      activeColor: _accent,
                      textColor: _textPrimary,
                      border: _border,
                    ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () => setState(() => _isDarkMode = true),
                    child: _ModeBtn(
                      icon: Icons.dark_mode_rounded,
                      label: 'Tối',
                      active: _isDarkMode,
                      activeColor: _accent,
                      textColor: _textPrimary,
                      border: _border,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Cỡ chữ',
                    style: TextStyle(fontSize: 12, color: _textSub),
                  ),
                  const SizedBox(width: 10),
                  _FontBtn(
                    icon: Icons.remove_rounded,
                    onTap: () => setState(
                      () => _fontSize = (_fontSize - 1).clamp(12.0, 26.0),
                    ),
                    enabled: _fontSize > 12,
                    border: _border,
                    textColor: _textPrimary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_fontSize.toInt()}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _FontBtn(
                    icon: Icons.add_rounded,
                    onTap: () => setState(
                      () => _fontSize = (_fontSize + 1).clamp(12.0, 26.0),
                    ),
                    enabled: _fontSize < 26,
                    border: _border,
                    textColor: _textPrimary,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEndOfChapterNav() {
    final hasNext = _currentChapter < _totalChapters;
    final hasPrev = _currentChapter > 1;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 20,
                height: 1.5,
                color: _accent.withOpacity(0.4),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Hết chương $_currentChapter',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _textSub,
                  ),
                ),
              ),
              Container(
                width: 20,
                height: 1.5,
                color: _accent.withOpacity(0.4),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (!hasNext)
            Column(
              children: [
                const Text('🎉', style: TextStyle(fontSize: 32)),
                const SizedBox(height: 8),
                Text(
                  'Bạn đã đọc xong cuốn sách!',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: _accent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Quay về',
                    style: TextStyle(
                      color: _accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                if (hasPrev)
                  GestureDetector(
                    onTap: () => _loadChapter(_currentChapter - 1),
                    child: Container(
                      height: 48,
                      width: 48,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _border, width: 1.5),
                      ),
                      child: Icon(
                        Icons.chevron_left_rounded,
                        color: _textPrimary,
                        size: 24,
                      ),
                    ),
                  ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _loadChapter(_currentChapter + 1),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1712),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Chương ${_currentChapter + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: _accent,
                            size: 22,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _showChapterList() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 4),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: _border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Row(
              children: [
                Text(
                  'Danh sách chương',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _textPrimary,
                  ),
                ),
                const Spacer(),
                Text(
                  '$_totalChapters chương',
                  style: TextStyle(fontSize: 12, color: _textSub),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
              itemCount: _chapterList.length,
              separatorBuilder: (_, __) => Divider(color: _border, height: 1),
              itemBuilder: (ctx, i) {
                final ch = _chapterList[i];
                final isCurrent = ch.chapterNumber == _currentChapter;
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isCurrent ? const Color(0xFF1C1712) : _bg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${ch.chapterNumber}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isCurrent ? _accent : _textSub,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    ch.chapterTitle ?? 'Chương ${ch.chapterNumber}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                      color: isCurrent ? _accent : _textPrimary,
                    ),
                  ),
                  subtitle: ch.wordCount != null
                      ? Text(
                          '${ch.wordCount} từ',
                          style: TextStyle(fontSize: 11, color: _textSub),
                        )
                      : null,
                  trailing: isCurrent
                      ? const Icon(
                          Icons.play_arrow_rounded,
                          color: _accent,
                          size: 20,
                        )
                      : null,
                  onTap: () {
                    Navigator.pop(ctx);
                    _loadChapter(ch.chapterNumber);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── HELPER WIDGETS ────────────────────────────────────────────────────
class _TapIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _TapIcon({
    required this.icon,
    required this.color,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Icon(icon, color: color, size: 20),
    ),
  );
}

class _ChapterNavBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool enabled;
  final bool isNext;
  final VoidCallback onTap;
  final Color textColor, border;
  final bool isDark;
  const _ChapterNavBtn({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.onTap,
    required this.textColor,
    required this.border,
    required this.isDark,
    this.isNext = false,
  });
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: enabled ? onTap : null,
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: enabled && isNext ? const Color(0xFF1C1712) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: enabled
              ? (isNext ? const Color(0xFF1C1712) : border)
              : border.withOpacity(0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isNext)
            Icon(
              icon,
              size: 16,
              color: enabled ? textColor : border.withOpacity(0.4),
            ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: enabled
                  ? (isNext ? Colors.white : textColor)
                  : border.withOpacity(0.4),
            ),
          ),
          if (isNext)
            Icon(
              icon,
              size: 16,
              color: enabled
                  ? const Color(0xFFD4A853)
                  : border.withOpacity(0.4),
            ),
        ],
      ),
    ),
  );
}

class _ModeBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final Color activeColor, textColor, border;
  const _ModeBtn({
    required this.icon,
    required this.label,
    required this.active,
    required this.activeColor,
    required this.textColor,
    required this.border,
  });
  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: const Duration(milliseconds: 200),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: active ? const Color(0xFF1C1712) : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: active ? const Color(0xFF1C1712) : border),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: active ? activeColor : textColor.withOpacity(0.5),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: active ? Colors.white : textColor.withOpacity(0.5),
          ),
        ),
      ],
    ),
  );
}

class _FontBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;
  final Color border, textColor;
  const _FontBtn({
    required this.icon,
    required this.onTap,
    required this.enabled,
    required this.border,
    required this.textColor,
  });
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: enabled ? onTap : null,
    child: Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: enabled ? border : border.withOpacity(0.3)),
      ),
      child: Icon(
        icon,
        size: 16,
        color: enabled ? textColor : border.withOpacity(0.3),
      ),
    ),
  );
}
