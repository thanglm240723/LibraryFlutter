import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:librarybookshelf/models/book_detail_model.dart';
import 'package:librarybookshelf/reading_screen.dart';
import 'package:librarybookshelf/services/book_detail_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// =====================================================================
//  COLORS
// =====================================================================
class _C {
  static const bg = Color(0xFFFAF7F2);
  static const card = Color(0xFF1C1712);
  static const accent = Color(0xFFD4A853);
  static const accentL = Color(0xFFF5E6C8);
  static const textD = Color(0xFF1C1712);
  static const textM = Color(0xFF6B5B45);
  static const textL = Color(0xFFA89880);
}

// =====================================================================
//  BOOK DETAIL SCREEN
// =====================================================================
class BookDetailScreen extends StatefulWidget {
  final int bookId;
  final String? heroTag;

  const BookDetailScreen({super.key, required this.bookId, this.heroTag});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  final _service = BookDetailService();
  late Future<BookDetail> _futureDetail;

  bool _isSaved = false;
  bool _isDownloading = false;
  double _downloadProgress = 0;
  bool _hasStartedReading = false; // true sau khi user đã bắt đầu đọc

  @override
  void initState() {
    super.initState();
    _futureDetail = _service.fetchDetail(widget.bookId);
    _checkIfSaved();
    _checkReadingProgress();
  }

  Future<void> _checkIfSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('saved_books') ?? [];
    if (mounted)
      setState(() => _isSaved = saved.contains(widget.bookId.toString()));
  }

  Future<void> _checkReadingProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final readBooks = prefs.getStringList('reading_books') ?? [];
    if (mounted) {
      setState(
        () => _hasStartedReading = readBooks.contains(widget.bookId.toString()),
      );
    }
  }

  Future<void> _toggleSave(BookDetail book) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('saved_books') ?? [];
    final id = book.bookId.toString();
    if (_isSaved) {
      saved.remove(id);
      _showSnack("Đã bỏ lưu \"${book.title}\"");
    } else {
      saved.add(id);
      _showSnack("Đã lưu \"${book.title}\"", isSuccess: true);
    }
    await prefs.setStringList('saved_books', saved);
    setState(() => _isSaved = !_isSaved);
  }

  Future<void> _startReading(BookDetail book) async {
    final prefs = await SharedPreferences.getInstance();
    final readBooks = prefs.getStringList('reading_books') ?? [];
    if (!readBooks.contains(book.bookId.toString())) {
      readBooks.add(book.bookId.toString());
      await prefs.setStringList('reading_books', readBooks);
      setState(() => _hasStartedReading = true);
    }

    // Lấy chương đang đọc dở (nếu có)
    final savedChapter = prefs.getInt('reading_chapter_${book.bookId}') ?? 1;

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ReadingScreen(
            bookId: book.bookId,
            bookTitle: book.title,
            initialChapter: savedChapter,
          ),
        ),
      );
    }
  }

  Future<void> _download(BookDetail book) async {
    if (book.fileUrl == null || book.fileUrl!.isEmpty) {
      _showSnack("Sách này chưa có file để tải về", isError: true);
      return;
    }
    if (kIsWeb) {
      _showSnack("Tính năng tải về chỉ hỗ trợ trên mobile", isError: true);
      return;
    }
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0;
    });
    try {
      final request = http.Request('GET', Uri.parse(book.fileUrl!));
      final response = await request.send();
      if (response.statusCode != 200) throw Exception('Lỗi tải file');
      final total = response.contentLength ?? 0;
      int received = 0;
      final bytes = <int>[];
      await for (final chunk in response.stream) {
        bytes.addAll(chunk);
        received += chunk.length;
        if (total > 0) setState(() => _downloadProgress = received / total);
      }
      final dir = await getApplicationDocumentsDirectory();
      final ext = book.fileUrl!.split('.').last;
      final fileName = '${book.bookId}_${book.title.replaceAll(' ', '_')}.$ext';
      await File('${dir.path}/$fileName').writeAsBytes(bytes);
      _showSnack("Đã tải về: $fileName", isSuccess: true);
    } catch (e) {
      _showSnack("Tải về thất bại: $e", isError: true);
    } finally {
      setState(() {
        _isDownloading = false;
        _downloadProgress = 0;
      });
    }
  }

  void _showSnack(String msg, {bool isError = false, bool isSuccess = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError
            ? Colors.red.shade600
            : isSuccess
            ? const Color(0xFF4CAF50)
            : _C.card,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // =====================================================================
  //  BUILD
  // =====================================================================
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BookDetail>(
      future: _futureDetail,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: _C.bg,
            body: Center(
              child: CircularProgressIndicator(
                color: _C.accent,
                strokeWidth: 2,
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: _C.bg,
            body: _buildError(snapshot.error.toString()),
          );
        }

        final book = snapshot.data!;
        return Scaffold(
          backgroundColor: _C.bg,
          // ── NÚT ĐỌC NGAY / ĐỌC TIẾP cố định ở bottom ───────────
          bottomNavigationBar: _buildReadButton(book),
          body: CustomScrollView(
            slivers: [
              _buildSliverAppBar(book),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title + Author
                      Text(
                        book.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: _C.textD,
                          height: 1.2,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        book.author,
                        style: const TextStyle(
                          fontSize: 15,
                          color: _C.textM,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Stats
                      _buildStatsRow(book),
                      const SizedBox(height: 20),

                      // ── GENRE + NÚT LƯU & TẢI VỀ ─────────────────
                      _buildGenreAndActions(book),
                      const SizedBox(height: 24),

                      const Divider(color: Color(0xFFEAE4D8)),
                      const SizedBox(height: 20),

                      // Mô tả
                      _buildDescription(book),
                      const SizedBox(height: 28),

                      // Thông tin chi tiết
                      _buildInfoTable(book),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── SLIVER APP BAR ────────────────────────────────────────────────
  Widget _buildSliverAppBar(BookDetail book) {
    return SliverAppBar(
      expandedHeight: 380,
      pinned: true,
      backgroundColor: _C.card,
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black45,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => _toggleSave(book),
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: _isSaved ? _C.accent : Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (book.coverImageUrl != null)
              Image.network(
                book.coverImageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: _C.card),
              )
            else
              Container(color: _C.card),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black38, Colors.black87],
                  stops: [0.3, 0.6, 1.0],
                ),
              ),
            ),
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Center(
                child: Hero(
                  tag: widget.heroTag ?? 'book_${book.bookId}',
                  child: Container(
                    width: 130,
                    height: 190,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: book.coverImageUrl != null
                          ? Image.network(
                              book.coverImageUrl!,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              color: _C.accentL,
                              child: const Icon(
                                Icons.menu_book_rounded,
                                color: _C.accent,
                                size: 50,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── GENRE + NÚT LƯU & TẢI VỀ ────────────────────────────────────
  Widget _buildGenreAndActions(BookDetail book) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Genre tag
        if (book.genre != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: _C.accentL,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              book.genre!,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF8B6914),
              ),
            ),
          ),
        const SizedBox(height: 14),

        // 2 nút nằm ngang
        Row(
          children: [
            // Nút LƯU
            Expanded(
              child: GestureDetector(
                onTap: () => _toggleSave(book),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 46,
                  decoration: BoxDecoration(
                    color: _isSaved ? _C.accentL : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isSaved ? _C.accent : const Color(0xFFE0D8CC),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isSaved
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                        color: _isSaved ? _C.accent : _C.textM,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _isSaved ? "Đã lưu" : "Lưu sách",
                        style: TextStyle(
                          color: _isSaved ? _C.accent : _C.textM,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Nút TẢI VỀ
            Expanded(
              child: GestureDetector(
                onTap: _isDownloading ? null : () => _download(book),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE0D8CC),
                      width: 1.5,
                    ),
                  ),
                  child: _isDownloading
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              LinearProgressIndicator(
                                value: _downloadProgress > 0
                                    ? _downloadProgress
                                    : null,
                                backgroundColor: const Color(0xFFE0D8CC),
                                valueColor: const AlwaysStoppedAnimation(
                                  _C.accent,
                                ),
                                minHeight: 3,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _downloadProgress > 0
                                    ? "${(_downloadProgress * 100).toInt()}%"
                                    : "Chuẩn bị...",
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: _C.textL,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.download_rounded,
                              color: _C.textM,
                              size: 18,
                            ),
                            SizedBox(width: 6),
                            Text(
                              "Tải về",
                              style: TextStyle(
                                color: _C.textM,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── MÔ TẢ ────────────────────────────────────────────────────────
  Widget _buildDescription(BookDetail book) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Giới thiệu",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: _C.textD,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          book.description ?? "Chưa có mô tả cho cuốn sách này.",
          style: const TextStyle(fontSize: 14, color: _C.textM, height: 1.7),
        ),
      ],
    );
  }

  // ── STATS ROW ─────────────────────────────────────────────────────
  Widget _buildStatsRow(BookDetail book) {
    return Row(
      children: [
        if (book.rating != null) ...[
          _StatChip(
            icon: Icons.star_rounded,
            iconColor: _C.accent,
            value: book.rating!.toStringAsFixed(1),
            label: "Đánh giá",
          ),
          const SizedBox(width: 10),
        ],
        if (book.pageCount != null) ...[
          _StatChip(
            icon: Icons.description_outlined,
            iconColor: Colors.blueAccent,
            value: "${book.pageCount}",
            label: "Trang",
          ),
          const SizedBox(width: 10),
        ],
        if (book.totalChapters > 0)
          _StatChip(
            icon: Icons.bookmark_outline_rounded,
            iconColor: Colors.green,
            value: "${book.totalChapters}",
            label: "Chương",
          ),
      ],
    );
  }

  // ── INFO TABLE ────────────────────────────────────────────────────
  Widget _buildInfoTable(BookDetail book) {
    final rows = <_InfoRow>[
      if (book.publishedYear != null)
        _InfoRow("Năm xuất bản", "${book.publishedYear}"),
      if (book.language != null) _InfoRow("Ngôn ngữ", book.language!),
      if (book.genre != null) _InfoRow("Thể loại", book.genre!),
      if (book.pageCount != null)
        _InfoRow("Số trang", "${book.pageCount} trang"),
    ];
    if (rows.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Thông tin sách",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: _C.textD,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: _C.textD.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: rows.asMap().entries.map((entry) {
              final isLast = entry.key == rows.length - 1;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Text(
                          entry.value.label,
                          style: const TextStyle(fontSize: 13, color: _C.textL),
                        ),
                        const Spacer(),
                        Text(
                          entry.value.value,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _C.textD,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    const Divider(
                      height: 1,
                      color: Color(0xFFF0EBE3),
                      indent: 16,
                      endIndent: 16,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ── NÚT ĐỌC NGAY / ĐỌC TIẾP — fixed bottom ───────────────────────
  Widget _buildReadButton(BookDetail book) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: const BoxDecoration(
        color: _C.bg,
        border: Border(top: BorderSide(color: Color(0xFFEAE4D8), width: 1)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: () => _startReading(book),
          style: ElevatedButton.styleFrom(
            backgroundColor: _C.card,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _hasStartedReading
                    ? Icons.play_circle_outline_rounded
                    : Icons.menu_book_rounded,
                color: _C.accent,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                _hasStartedReading ? "Đọc tiếp" : "Đọc ngay",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              // Badge chương đang đọc
              if (_hasStartedReading) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: _C.accent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Chương 1", // TODO: lấy từ ReadingProgress API
                    style: TextStyle(
                      color: _C.accent,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ── ERROR ─────────────────────────────────────────────────────────
  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, color: _C.textL, size: 48),
            const SizedBox(height: 16),
            const Text(
              "Không thể tải thông tin sách",
              style: TextStyle(fontWeight: FontWeight.w600, color: _C.textD),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: _C.textL),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => setState(
                () => _futureDetail = _service.fetchDetail(widget.bookId),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: _C.card),
              child: const Text(
                "Thử lại",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
//  HELPER WIDGETS
// =====================================================================
class _StatChip extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _StatChip({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: _C.textD.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(width: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _C.textD,
                ),
              ),
              Text(
                label,
                style: const TextStyle(fontSize: 10, color: _C.textL),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow {
  final String label;
  final String value;
  _InfoRow(this.label, this.value);
}
