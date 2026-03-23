// lib/home_screen.dart

import 'package:flutter/material.dart';
import 'package:librarybookshelf/book_detail_screen.dart';
import 'package:librarybookshelf/profile_screen.dart';
import 'package:librarybookshelf/services/auther_service.dart';
import 'package:librarybookshelf/services/user_library_service.dart';
import '../models/book_model.dart';
import '../services/book_service.dart';
import '../theme/app_theme.dart';
import 'package:librarybookshelf/admin/screens/admin_home_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _bookService = BookService();
  final _libraryService = UserLibraryService();

  late Future<List<BookModel>> _futureBooks;

  final _searchController = TextEditingController();
  String _selectedGenre = 'Tất cả';
  final _genres = ['Tất cả', 'Tiểu thuyết', 'Kỹ năng', 'Kinh tế', 'Lịch sử'];

  bool _isLoggedIn = false;
  String _displayName = '';
  bool _isAdmin = false;

  // ── Set bookId đã lưu — để BookCard biết trạng thái ────────────
  Set<int> _savedBookIds = {};

  @override
  void initState() {
    super.initState();
    _futureBooks = _bookService.fetchBooks();
    _checkLoginState();
  }

  Future<void> _checkLoginState() async {
    final loggedIn = await AuthService.isLoggedIn();
    if (loggedIn) {
      final info = await AuthService.getUserInfo();
      final admin = await AuthService.isAdmin();
      setState(() {
        _isLoggedIn = true;
        _isAdmin = admin;
        final fn = info?['fullName'] ?? '';
        final uname = info?['username'] ?? '';
        _displayName = fn.isNotEmpty ? fn.split(' ').last : uname;
      });
      // Load danh sách sách đã lưu để hiện đúng icon bookmark
      await _loadSavedIds();
    } else {
      setState(() {
        _isLoggedIn = false;
        _savedBookIds = {};
        _isAdmin = false;
      });
    }
  }

  Future<void> _loadSavedIds() async {
    try {
      final saved = await _libraryService.fetchSavedBooks();
      if (mounted) {
        setState(() => _savedBookIds = saved.map((b) => b.bookId).toSet());
      }
    } catch (_) {}
  }

  // ── Search text ──────────────────────────────────────────────────
  void _onSearch(String query) {
    setState(() {
      _selectedGenre = 'Tất cả';
      _futureBooks = _bookService.fetchBooks(searchTerm: query);
    });
  }

  // ── Filter thể loại ──────────────────────────────────────────────
  void _onGenreSelected(String genre) {
    setState(() {
      _selectedGenre = genre;
      _searchController.clear();
      if (genre == 'Tất cả') {
        _futureBooks = _bookService.fetchBooks();
      } else {
        // ── FIX: gọi endpoint Genre riêng, không dùng searchTerm ────
        _futureBooks = _bookService.fetchBooksByGenre(genre);
      }
    });
  }

  // ── Toggle save từ HomeScreen ────────────────────────────────────
  Future<void> _toggleSave(BookModel book) async {
    if (!_isLoggedIn) {
      if (!mounted) return;
      Navigator.of(context).pushNamed('/login').then((_) => _checkLoginState());
      return;
    }
    try {
      final isNowSaved = await _libraryService.toggleSaveBook(book.bookId);
      if (!mounted) return;
      setState(() {
        if (isNowSaved) {
          _savedBookIds.add(book.bookId);
        } else {
          _savedBookIds.remove(book.bookId);
        }
      });
      AppSnack.show(
        context,
        isNowSaved ? 'Đã lưu "${book.title}"' : 'Đã bỏ lưu "${book.title}"',
        isSuccess: isNowSaved,
      );
    } catch (e) {
      if (mounted) AppSnack.show(context, 'Lỗi: $e', isError: true);
    }
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
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context)),
            SliverToBoxAdapter(child: _buildSearchBar()),
            SliverToBoxAdapter(child: _buildGenreChips()),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 18,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _selectedGenre == 'Tất cả'
                          ? 'Khám phá sách'
                          : _selectedGenre,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: FutureBuilder<List<BookModel>>(
                future: _futureBooks,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 300,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.accent,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return SliverToBoxAdapter(
                      child: _buildErrorState(snapshot.error.toString()),
                    );
                  }
                  final books = snapshot.data ?? [];
                  if (books.isEmpty) {
                    return SliverToBoxAdapter(child: _buildEmptyState());
                  }
                  return _buildBookGrid(books);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
      color: AppColors.bg,
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.auto_stories,
              color: AppColors.accent,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BookShelf',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                'Thư viện cá nhân',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textLight,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const Spacer(),
          if (_isLoggedIn) ...[
            if (_isAdmin) ...[
              IconButton(
                onPressed: () => Navigator.pushNamed(context, '/admin'),
                icon: const Icon(
                  Icons.admin_panel_settings_rounded,
                  color: AppColors.accent,
                  size: 18,
                ),
              ),
            ],
            GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
                _checkLoginState(); // refresh sau khi quay về
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          _displayName.isNotEmpty
                              ? _displayName[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      _displayName,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.accent,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            _HeaderButton(
              label: 'Đăng ký',
              filled: false,
              onTap: () async {
                await Navigator.of(context).pushNamed('/register');
                _checkLoginState();
              },
            ),
            const SizedBox(width: 8),
            _HeaderButton(
              label: 'Đăng nhập',
              filled: true,
              onTap: () async {
                await Navigator.of(context).pushNamed('/login');
                _checkLoginState();
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.textDark.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onSubmitted: _onSearch,
          style: const TextStyle(color: AppColors.textDark, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Tìm tên sách, tác giả...',
            hintStyle: const TextStyle(
              color: AppColors.textLight,
              fontSize: 14,
            ),
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
                      _onGenreSelected(_selectedGenre);
                    },
                  )
                : IconButton(
                    icon: const Icon(
                      Icons.tune_rounded,
                      color: AppColors.accent,
                      size: 20,
                    ),
                    onPressed: () {},
                  ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onChanged: (_) => setState(() {}),
        ),
      ),
    );
  }

  Widget _buildGenreChips() {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
        itemCount: _genres.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final genre = _genres[index];
          final selected = _selectedGenre == genre;
          return GestureDetector(
            onTap: () => _onGenreSelected(genre),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: selected ? AppColors.card : AppColors.chip,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                genre,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : AppColors.textMid,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  SliverGrid _buildBookGrid(List<BookModel> books) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) => _BookCard(
          book: books[index],
          isSaved: _savedBookIds.contains(books[index].bookId),
          onToggleSave: () => _toggleSave(books[index]),

          onTapDetail: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BookDetailScreen(
                  bookId: books[index].bookId,
                  heroTag: 'book_${books[index].bookId}',
                ),
              ),
            );
            _loadSavedIds();
          },
        ),
        childCount: books.length,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.58,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off_rounded,
              color: AppColors.textLight,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              _selectedGenre == 'Tất cả'
                  ? 'Không tìm thấy sách nào.'
                  : 'Không có sách thể loại "$_selectedGenre".',
              style: const TextStyle(color: AppColors.textMid),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Container(
      height: 220,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off_rounded, color: Colors.red.shade300, size: 40),
          const SizedBox(height: 12),
          const Text(
            'Không thể tải dữ liệu',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Kiểm tra kết nối và thử lại',
            style: TextStyle(fontSize: 12, color: AppColors.textLight),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () =>
                setState(() => _futureBooks = _bookService.fetchBooks()),
            child: const Text(
              'Thử lại',
              style: TextStyle(color: AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }
}

// ── HEADER BUTTON ─────────────────────────────────────────────────────
class _HeaderButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool filled;
  const _HeaderButton({
    required this.label,
    required this.onTap,
    required this.filled,
  });
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: filled ? AppColors.card : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: filled
            ? null
            : Border.all(color: AppColors.textLight.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: filled ? Colors.white : AppColors.textMid,
        ),
      ),
    ),
  );
}

// ── BOOK CARD — nhận isSaved + callbacks ──────────────────────────────
class _BookCard extends StatelessWidget {
  final BookModel book;
  final bool isSaved;
  final VoidCallback onToggleSave;
  final VoidCallback onTapDetail;

  const _BookCard({
    required this.book,
    required this.isSaved,
    required this.onToggleSave,
    required this.onTapDetail,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapDetail,
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
            // ── Cover ───────────────────────────────────────────────
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    book.coverImageUrl != null
                        ? Image.network(
                            book.coverImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _placeholder(),
                          )
                        : _placeholder(),
                    // Rating badge
                    if (book.rating != null)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.card.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: AppColors.accent,
                                size: 12,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                book.rating!.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // ── Info ─────────────────────────────────────────────────
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (book.genre != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        margin: const EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          color: AppColors.accentL,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          book.genre!,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF8B6914),
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    Text(
                      book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                        height: 1.3,
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
                    // ── Bookmark button — hiện đúng trạng thái ─────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: onToggleSave,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: isSaved
                                  ? AppColors.accentL
                                  : AppColors.chip,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              isSaved
                                  ? Icons.bookmark_rounded
                                  : Icons.bookmark_border_rounded,
                              size: 15,
                              color: isSaved
                                  ? AppColors.accent
                                  : AppColors.textMid,
                            ),
                          ),
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
