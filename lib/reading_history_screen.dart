import 'package:flutter/material.dart';
import 'package:librarybookshelf/theme/app_theme.dart';
import 'package:librarybookshelf/services/reading_progress_service.dart';
import 'package:librarybookshelf/reading_screen.dart';

class ReadingHistoryScreen extends StatefulWidget {
  const ReadingHistoryScreen({super.key});

  @override
  State<ReadingHistoryScreen> createState() => _ReadingHistoryScreenState();
}

class _ReadingHistoryScreenState extends State<ReadingHistoryScreen> {
  late Future<List<dynamic>> futureHistory;
  late Future<List<dynamic>> futureBookmarks;

  @override
  void initState() {
    super.initState();
    futureHistory = ReadingProgressService.getReadingHistory();
    futureBookmarks = ReadingProgressService.getBookmarks();
  }

  Widget _bookPlaceholder() => Container(
    width: 44,
    height: 60,
    decoration: BoxDecoration(
      color: AppColors.accentL,
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Icon(
      Icons.menu_book_rounded,
      color: AppColors.accent,
      size: 24,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(
          backgroundColor: AppColors.bg,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.textDark,
              size: 18,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Lịch sử & Dấu trang',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          bottom: const TabBar(
            labelColor: AppColors.accent,
            unselectedLabelColor: AppColors.textLight,
            indicatorColor: AppColors.accent,
            tabs: [
              Tab(icon: Icon(Icons.history_rounded), text: 'Lịch sử đọc'),
              Tab(
                icon: Icon(Icons.bookmark_outline_rounded),
                text: 'Dấu trang',
              ),
            ],
          ),
        ),
        body: TabBarView(children: [_buildHistoryTab(), _buildBookmarkTab()]),
      ),
    );
  }

  Widget _buildHistoryTab() {
    return FutureBuilder<List<dynamic>>(
      future: futureHistory,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.accent),
          );
        }
        final history = snapshot.data ?? [];
        if (history.isEmpty) {
          return const Center(
            child: Text(
              'Chưa có lịch sử đọc.',
              style: TextStyle(color: AppColors.textMid),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: history.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final h = history[index];
            final cover =
                h['coverImage'] ??
                h['bookCover']; // Tùy thuộc vào JSON API trả về
            final readAt = h['readAt'] != null
                ? DateTime.tryParse(h['readAt'].toString())
                : null;
            final dateStr = readAt != null
                ? '${readAt.day}/${readAt.month}/${readAt.year}'
                : '';

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: cover != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          cover,
                          width: 44,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _bookPlaceholder(),
                        ),
                      )
                    : _bookPlaceholder(),
                title: Text(
                  h['title'] ?? 'Không rõ',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    'Đọc lần cuối: $dateStr',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReadingScreen(
                        bookId: h['bookId'],
                        bookTitle: h['title'] ?? 'Không rõ',
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBookmarkTab() {
    return FutureBuilder<List<dynamic>>(
      future: futureBookmarks,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.accent),
          );
        }
        final bookmarks = snapshot.data ?? [];
        if (bookmarks.isEmpty) {
          return const Center(
            child: Text(
              'Chưa có dấu trang nào.',
              style: TextStyle(color: AppColors.textMid),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: bookmarks.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final b = bookmarks[index];
            final cover = b['coverImage'] ?? b['bookCover'];
            final pageNum = b['pageNumber'];
            final chapterId = b['chapterId'] ?? '';
            // Nếu có số trang và lớn hơn 0 thì hiện Trang, ngược lại hiện Chương
            final pageStr = (pageNum != null && pageNum > 0)
                ? 'Trang $pageNum'
                : 'Chương $chapterId';
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: cover != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          cover,
                          width: 44,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _bookPlaceholder(),
                        ),
                      )
                    : _bookPlaceholder(),
                title: Text(
                  b['title'] ?? 'Không rõ',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    'Đánh dấu tại: $pageStr',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
                  ),
                ),
                trailing: const Icon(
                  Icons.bookmark,
                  color: Colors.orange,
                  size: 28,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReadingScreen(
                        bookId: b['bookId'],
                        bookTitle: b['title'] ?? 'Không rõ',
                        // Lấy chapterId từ API, nếu không có thì mặc định là 1
                        initialChapter: b['chapterId'] ?? 1, 
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
