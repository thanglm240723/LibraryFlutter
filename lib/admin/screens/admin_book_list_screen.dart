import 'package:flutter/material.dart';
import 'package:librarybookshelf/admin/models/admin_book_model.dart';
import 'package:librarybookshelf/admin/services/admin_book_service.dart';
import 'package:librarybookshelf/admin/screens/admin_create_book_screen.dart';
import 'package:librarybookshelf/admin/screens/admin_edit_book_screen.dart';
import 'package:librarybookshelf/theme/app_theme.dart';
import 'admin_book_content_screen.dart';

class AdminBookListScreen extends StatefulWidget {
  const AdminBookListScreen({super.key});

  @override
  State<AdminBookListScreen> createState() => _AdminBookListScreenState();
}

class _AdminBookListScreenState extends State<AdminBookListScreen> {
  List<Map<String, dynamic>> books = [];
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
        books = loadedBooks.map((book) => book.toJson()).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString().replaceAll('Exception: ', '');
        isLoading = false;
      });
    }
  }

  void _navigateToCreateBook() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (ctx) => const AdminCreateBookScreen()),
    );

    if (result == true) {
      _loadBooks();
    }
  }

  void _navigateToEditBook(Map<String, dynamic> book) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (ctx) => AdminEditBookScreen(book: book)),
    );

    if (result == true) {
      _loadBooks();
    }
  }

  void _navigateToBookContent(Map<String, dynamic> bookData) {
    // Convert Map to AdminBookModel
    final book = AdminBookModel(
      bookId: bookData['bookId'] ?? 0,
      title: bookData['title'] ?? '',
      author: bookData['author'] ?? '',
      description: bookData['description'],
      coverImageUrl: bookData['coverImageUrl'],
      genre: bookData['genre'],
      pageCount: bookData['pageCount'],
      publishedYear: bookData['publishedYear'],
      rating: bookData['rating']?.toDouble(),
      language: bookData['language'],
      fileUrl: bookData['fileUrl'],
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => AdminBookContentScreen(book: book)),
    );
  }

  Future<void> _deleteBook(int bookId, String title) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Xác nhận xoá',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Bạn có chắc chắn muốn xoá sách "$title"?',
          style: const TextStyle(color: AppColors.textMid),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Huỷ',
              style: TextStyle(color: AppColors.textMid),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Xoá',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await AdminBookService.deleteBook(bookId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Xoá sách thành công'),
              backgroundColor: AppColors.success,
            ),
          );
          _loadBooks();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                e.toString().replaceAll('Exception: ', ''),
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _performSearch() {
    setState(() {
      currentPage = 1;
    });
    _loadBooks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
          'Quản lý sách',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm sách...',
                        hintStyle: const TextStyle(
                          color: AppColors.textLight,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: AppColors.textLight,
                          size: 20,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.clear_rounded,
                                  color: AppColors.textLight,
                                  size: 18,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  searchQuery = '';
                                  currentPage = 1;
                                  _loadBooks();
                                },
                              )
                            : null,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontSize: 14,
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                      onSubmitted: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                        _performSearch();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Error Message
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        errorMessage!,
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Content
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.accent),
                  )
                : books.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.library_books,
                          size: 64,
                          color: AppColors.textLight,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Không có sách nào',
                          style: AppText.h3.copyWith(color: AppColors.textMid),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Nhấn nút + để thêm sách mới',
                          style: AppText.body.copyWith(
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border, width: 1),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: book['coverImageUrl'] != null
                                ? Image.network(
                                    book['coverImageUrl'],
                                    width: 50,
                                    height: 70,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              width: 50,
                                              height: 70,
                                              color: AppColors.chip,
                                              child: const Icon(
                                                Icons.image_not_supported,
                                                color: AppColors.textLight,
                                              ),
                                            ),
                                  )
                                : Container(
                                    width: 50,
                                    height: 70,
                                    color: AppColors.chip,
                                    child: const Icon(
                                      Icons.book,
                                      color: AppColors.textLight,
                                    ),
                                  ),
                          ),
                          title: Text(
                            book['title'] ?? 'N/A',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.h4,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                book['author'] ?? 'N/A',
                                style: AppText.bodySmall,
                              ),
                              if (book['genre'] != null)
                                Text(
                                  'Thể loại: ${book['genre']}',
                                  style: AppText.caption,
                                ),
                            ],
                          ),
                          trailing: SizedBox(
                            width: 130,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.library_books_rounded,
                                    color: AppColors.accent,
                                    size: 20,
                                  ),
                                  onPressed: () => _navigateToBookContent(book),
                                  tooltip: 'Quản lý nội dung',
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit_rounded,
                                    color: AppColors.accent,
                                    size: 20,
                                  ),
                                  onPressed: () => _navigateToEditBook(book),
                                  tooltip: 'Chỉnh sửa',
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  onPressed: () => _deleteBook(
                                    book['bookId'],
                                    book['title'] ?? 'N/A',
                                  ),
                                  tooltip: 'Xoá',
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateBook,
        backgroundColor: AppColors.accent,
        tooltip: 'Thêm sách mới',
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }
}
