import 'package:flutter/material.dart';
import 'package:librarybookshelf/models/book_detail_model.dart';
import 'package:librarybookshelf/theme/app_theme.dart';

// =====================================================================
//  BOOK DETAIL VIEW - toàn bộ UI
// =====================================================================
class BookDetailView extends StatelessWidget {
  final BookDetail book;
  final String? heroTag;
  final bool isSaved;
  final bool isDownloading;
  final double downloadProgress;
  final bool hasStartedReading;
  final int savedChapter;
  final VoidCallback onToggleSave;
  final VoidCallback onDownload;
  final VoidCallback onStartReading;

  const BookDetailView({
    super.key,
    required this.book,
    required this.heroTag,
    required this.isSaved,
    required this.isDownloading,
    required this.downloadProgress,
    required this.hasStartedReading,
    required this.savedChapter,
    required this.onToggleSave,
    required this.onDownload,
    required this.onStartReading,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      bottomNavigationBar: _buildReadButton(context),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(book.title, style: AppText.h2),
                  const SizedBox(height: 6),
                  Text(
                    book.author,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textMid,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  BookStatsRow(book: book),
                  const SizedBox(height: 20),
                  BookGenreAndActions(
                    book: book,
                    isSaved: isSaved,
                    isDownloading: isDownloading,
                    downloadProgress: downloadProgress,
                    onToggleSave: onToggleSave,
                    onDownload: onDownload,
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: 20),
                  BookDescriptionSection(book: book),
                  const SizedBox(height: 28),
                  BookInfoTable(book: book),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 380,
      pinned: true,
      backgroundColor: AppColors.card,
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
          onTap: onToggleSave,
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: isSaved ? AppColors.accent : Colors.white,
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
                errorBuilder: (_, __, ___) => Container(color: AppColors.card),
              )
            else
              Container(color: AppColors.card),
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
                  tag: heroTag ?? 'book_${book.bookId}',
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
                              color: AppColors.accentL,
                              child: const Icon(
                                Icons.menu_book_rounded,
                                color: AppColors.accent,
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

  Widget _buildReadButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: AppDecorations.bottomBar,
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: onStartReading,
          style: AppButtons.primary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                hasStartedReading
                    ? Icons.play_circle_outline_rounded
                    : Icons.menu_book_rounded,
                color: AppColors.accent,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                hasStartedReading ? "Đọc tiếp" : "Đọc ngay",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (hasStartedReading) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Chương $savedChapter",
                    style: const TextStyle(
                      color: AppColors.accent,
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
}

// ── Stats Row ─────────────────────────────────────────────────────────
class BookStatsRow extends StatelessWidget {
  final BookDetail book;
  const BookStatsRow({super.key, required this.book});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      if (book.rating != null) ...[
        _StatChip(
          icon: Icons.star_rounded,
          iconColor: AppColors.accent,
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
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: AppDecorations.whiteCard,
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
                color: AppColors.textDark,
              ),
            ),
            Text(label, style: AppText.caption),
          ],
        ),
      ],
    ),
  );
}

// ── Genre + Actions Row ───────────────────────────────────────────────
class BookGenreAndActions extends StatelessWidget {
  final BookDetail book;
  final bool isSaved;
  final bool isDownloading;
  final double downloadProgress;
  final VoidCallback onToggleSave;
  final VoidCallback onDownload;

  const BookGenreAndActions({
    super.key,
    required this.book,
    required this.isSaved,
    required this.isDownloading,
    required this.downloadProgress,
    required this.onToggleSave,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (book.genre != null)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: AppDecorations.genreTag,
          child: Text(book.genre!, style: AppText.accentLabel),
        ),
      const SizedBox(height: 14),
      Row(
        children: [
          // Nút Lưu
          Expanded(
            child: GestureDetector(
              onTap: onToggleSave,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 46,
                decoration: BoxDecoration(
                  color: isSaved ? AppColors.accentL : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSaved ? AppColors.accent : AppColors.border,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isSaved
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color: isSaved ? AppColors.accent : AppColors.textMid,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isSaved ? "Đã lưu" : "Lưu sách",
                      style: TextStyle(
                        color: isSaved ? AppColors.accent : AppColors.textMid,
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
          // Nút Tải về
          Expanded(
            child: GestureDetector(
              onTap: isDownloading ? null : onDownload,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border, width: 1.5),
                ),
                child: isDownloading
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LinearProgressIndicator(
                              value: downloadProgress > 0
                                  ? downloadProgress
                                  : null,
                              backgroundColor: AppColors.border,
                              valueColor: const AlwaysStoppedAnimation(
                                AppColors.accent,
                              ),
                              minHeight: 3,
                              borderRadius: BorderRadius.circular(2),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              downloadProgress > 0
                                  ? "${(downloadProgress * 100).toInt()}%"
                                  : "Chuẩn bị...",
                              style: AppText.caption,
                            ),
                          ],
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.download_rounded,
                            color: AppColors.textMid,
                            size: 18,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "Tải về",
                            style: TextStyle(
                              color: AppColors.textMid,
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

// ── Description ────────────────────────────────────────────────────────
class BookDescriptionSection extends StatelessWidget {
  final BookDetail book;
  const BookDescriptionSection({super.key, required this.book});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("Giới thiệu", style: AppText.h4),
      const SizedBox(height: 10),
      Text(
        book.description ?? "Chưa có mô tả cho cuốn sách này.",
        style: AppText.body,
      ),
    ],
  );
}

// ── Info Table ─────────────────────────────────────────────────────────
class BookInfoTable extends StatelessWidget {
  final BookDetail book;
  const BookInfoTable({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final rows = [
      if (book.publishedYear != null)
        _Row("Năm xuất bản", "${book.publishedYear}"),
      if (book.language != null) _Row("Ngôn ngữ", book.language!),
      if (book.genre != null) _Row("Thể loại", book.genre!),
      if (book.pageCount != null) _Row("Số trang", "${book.pageCount} trang"),
    ];
    if (rows.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Thông tin sách", style: AppText.h4),
        const SizedBox(height: 12),
        Container(
          decoration: AppDecorations.whiteCard,
          child: Column(
            children: rows.asMap().entries.map((e) {
              final isLast = e.key == rows.length - 1;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Text(e.value.label, style: AppText.caption),
                        const Spacer(),
                        Text(
                          e.value.value,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
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
}

class _Row {
  final String label, value;
  _Row(this.label, this.value);
}

// ── Error view ─────────────────────────────────────────────────────────
class BookDetailErrorView extends StatelessWidget {
  final VoidCallback onRetry;
  const BookDetailErrorView({super.key, required this.onRetry});
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.textLight,
            size: 48,
          ),
          const SizedBox(height: 16),
          const Text(
            "Không thể tải thông tin sách",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onRetry,
            style: AppButtons.primary,
            child: const Text("Thử lại", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ),
  );
}

// ── Login Required Dialog ──────────────────────────────────────────────
void showLoginRequiredDialog({
  required BuildContext context,
  required VoidCallback onLogin,
}) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        "Cần đăng nhập",
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
        ),
      ),
      content: const Text(
        "Vui lòng đăng nhập để đọc sách.",
        style: TextStyle(color: AppColors.textMid),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text(
            "Để sau",
            style: TextStyle(color: AppColors.textLight),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(ctx);
            onLogin();
          },
          style: AppButtons.dialogAction,
          child: const Text(
            "Đăng nhập",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );
}
