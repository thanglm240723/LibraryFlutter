import 'package:flutter/material.dart';
import 'package:librarybookshelf/book_detail_screen.dart';
import 'package:librarybookshelf/profile_screen.dart';
import 'package:librarybookshelf/services/auther_service.dart';
import '../models/book_model.dart';
import '../services/book_service.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BookService _bookService = BookService();
  late Future<List<BookModel>> _futureBooks;

  final _searchController = TextEditingController();
  String _selectedGenre = "Tất cả";
  final _genres = ["Tất cả", "Tiểu thuyết", "Kỹ năng", "Kinh tế", "Lịch sử"];

  bool _isLoggedIn = false;
  String _displayName = '';

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
      setState(() {
        _isLoggedIn = true;

        final fullName = info?['fullName'] ?? '';
        final username = info?['username'] ?? '';
        _displayName = fullName.isNotEmpty
            ? fullName.split(' ').last
            : username;
      });
    } else {
      setState(() => _isLoggedIn = false);
    }
  }

  void _onSearch(String query) {
    setState(() {
      _futureBooks = _bookService.fetchBooks(searchTerm: query);
    });
  }

  void _onGenreSelected(String genre) {
    setState(() {
      _selectedGenre = genre;
      _futureBooks = genre == "Tất cả"
          ? _bookService.fetchBooks()
          : _bookService.fetchBooks(searchTerm: genre);
    });
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
                    const Text(
                      "Khám phá sách",
                      style: TextStyle(
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
                    return const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 200,
                        child: Center(
                          child: Text(
                            "Không tìm thấy sách nào.",
                            style: TextStyle(color: AppColors.textMid),
                          ),
                        ),
                      ),
                    );
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
          // Logo
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
                "BookShelf",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                "Thư viện cá nhân",
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textLight,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const Spacer(),

          // ── AUTH BUTTONS: ẩn/hiện theo trạng thái đăng nhập ──────
          if (_isLoggedIn) ...[
            // Nút "Tài khoản" khi đã đăng nhập
            GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
                // Refresh lại trạng thái khi quay về (vd sau khi đăng xuất)
                _checkLoginState();
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
            // Nút Đăng ký + Đăng nhập khi chưa đăng nhập
            _HeaderButton(
              label: "Đăng ký",
              onTap: () async {
                await Navigator.of(context).pushNamed('/register');
                _checkLoginState();
              },
              filled: false,
            ),
            const SizedBox(width: 8),
            _HeaderButton(
              label: "Đăng nhập",
              onTap: () async {
                await Navigator.of(context).pushNamed('/login');
                _checkLoginState();
              },
              filled: true,
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
            hintText: "Tìm tên sách, tác giả...",
            hintStyle: const TextStyle(
              color: AppColors.textLight,
              fontSize: 14,
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: AppColors.textLight,
              size: 20,
            ),
            suffixIcon: IconButton(
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
        (context, index) => _BookCard(book: books[index]),
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
            "Không thể tải dữ liệu",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Kiểm tra kết nối và thử lại",
            style: TextStyle(fontSize: 12, color: AppColors.textLight),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () =>
                setState(() => _futureBooks = _bookService.fetchBooks()),
            child: const Text(
              "Thử lại",
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

// ── BOOK CARD ─────────────────────────────────────────────────────────
class _BookCard extends StatelessWidget {
  final BookModel book;
  const _BookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BookDetailScreen(
            bookId: book.bookId,
            heroTag: 'book_${book.bookId}',
          ),
        ),
      ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: AppColors.chip,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.bookmark_border_rounded,
                            size: 15,
                            color: AppColors.textMid,
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
