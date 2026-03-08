import 'package:flutter/material.dart';
import 'package:librarybookshelf/book_detail_screen.dart';
import 'package:librarybookshelf/models/book_model.dart';
import 'package:librarybookshelf/services/user_library_service.dart';
import 'package:librarybookshelf/theme/app_theme.dart';

class SavedBooksScreen extends StatefulWidget {
  const SavedBooksScreen({super.key});

  @override
  State<SavedBooksScreen> createState() => _SavedBooksScreenState();
}

class _SavedBooksScreenState extends State<SavedBooksScreen> {
  final _service = UserLibraryService();
  late Future<List<BookModel>> _futureSavedBooks;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _futureSavedBooks = _service.fetchSavedBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        title: const Text(
          "Sách đã lưu",
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      body: FutureBuilder<List<BookModel>>(
        future: _futureSavedBooks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text("Lỗi tải dữ liệu: ${snapshot.error}"));
          }

          final books = snapshot.data ?? [];
          if (books.isEmpty) {
            return const Center(
              child: Text(
                "Bạn chưa lưu cuốn sách nào.",
                style: TextStyle(color: AppColors.textMid),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.58,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
            ),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return _buildSavedBookCard(context, book);
            },
          );
        },
      ),
    );
  }

  // Tái sử dụng giao diện card sách tương tự HomeScreen
  Widget _buildSavedBookCard(BuildContext context, BookModel book) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BookDetailScreen(
            bookId: book.bookId,
            heroTag: 'saved_book_${book.bookId}',
          ),
        ),
      ).then((_) => _loadData()), // Load lại list phòng khi user bỏ lưu trong màn Detail
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.textDark.withOpacity(0.07),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: book.coverImageUrl != null
                    ? Image.network(
                        book.coverImageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (_, __, ___) => _placeholder(),
                      )
                    : _placeholder(),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textLight,
                      ),
                    ),
                    const Spacer(),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.bookmark_rounded, // Hiển thị icon đã lưu
                          size: 18,
                          color: AppColors.accent,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
    color: AppColors.accentL,
    child: const Center(
      child: Icon(Icons.menu_book_rounded, color: AppColors.accent, size: 40),
    ),
  );
}