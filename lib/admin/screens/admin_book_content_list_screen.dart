import 'package:flutter/material.dart';
import 'package:librarybookshelf/admin/models/admin_book_model.dart';
import 'package:librarybookshelf/admin/services/admin_book_service.dart';
import 'package:librarybookshelf/theme/app_theme.dart';
import 'package:librarybookshelf/admin/widgets/admin_ui_components.dart';
import 'admin_book_content_screen.dart';

class AdminBookContentListScreen extends StatefulWidget {
  const AdminBookContentListScreen({super.key});

  @override
  State<AdminBookContentListScreen> createState() =>
      _AdminBookContentListScreenState();
}

class _AdminBookContentListScreenState
    extends State<AdminBookContentListScreen> {
  List<AdminBookModel> books = [];
  bool isLoading = true;
  String? errorMessage;
  int currentPage = 1;
  final int pageSize = 10;
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final loadedBooks = await AdminBookService.getBooks(
        page: currentPage,
        pageSize: pageSize,
        searchTerm: searchQuery.isEmpty ? null : searchQuery,
      );
      setState(() {
        books = loadedBooks;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString().replaceAll('Exception: ', '');
        isLoading = false;
      });
    }
  }

  void _performSearch() {
    setState(() {
      currentPage = 1;
    });
    _loadBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
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
          'Quản lý nội dung',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
      ),
      body: Column(
        children: [
          // ── SEARCH BAR ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                searchQuery = value;
              },
              onSubmitted: (_) => _performSearch(),
              decoration: InputDecoration(
                hintText: 'Tìm kiếm sách...',
                hintStyle: const TextStyle(color: AppColors.textLight),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.textMid,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          searchQuery = '';
                          _performSearch();
                        },
                        icon: const Icon(
                          Icons.close_rounded,
                          color: AppColors.textMid,
                        ),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 12,
                ),
              ),
            ),
          ),

          // ── CONTENT ────────────────────────────────────────────
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.accent,
                      strokeWidth: 2,
                    ),
                  )
                : errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          color: Colors.red,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          errorMessage ?? 'Có lỗi xảy ra',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.textMid),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _loadBooks,
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Thử lại'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                  )
                : books.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.auto_stories_rounded,
                          color: AppColors.textLight,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Không tìm thấy sách',
                          style: TextStyle(
                            color: AppColors.textMid,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Hãy tạo sách trước để quản lý nội dung',
                          style: TextStyle(
                            color: AppColors.textLight,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: books.length,
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                    itemBuilder: (context, index) {
                      final book = books[index];
                      return AdminBookCard(
                        book: book,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) =>
                                  AdminBookContentScreen(book: book),
                            ),
                          );
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
