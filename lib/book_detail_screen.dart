import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:librarybookshelf/services/auther_service.dart';
import 'package:librarybookshelf/services/reading_progress_service.dart';
import 'package:librarybookshelf/theme/book_detail_widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:librarybookshelf/models/book_detail_model.dart';
import 'package:librarybookshelf/services/book_detail_service.dart';
import 'package:librarybookshelf/reading_screen.dart';
import 'package:librarybookshelf/theme/app_theme.dart';
import 'package:librarybookshelf/services/user_library_service.dart';

class BookDetailScreen extends StatefulWidget {
  final int bookId;
  final String? heroTag;
  const BookDetailScreen({super.key, required this.bookId, this.heroTag});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  final _service = BookDetailService();
  final _libraryService = UserLibraryService();

  late Future<BookDetail> _futureDetail;

  bool _isSaved = false;
  bool _isDownloading = false;
  double _downloadProgress = 0;
  bool _hasStartedReading = false;
  int _savedChapter = 1;

  @override
  void initState() {
    super.initState();
    _futureDetail = _service.fetchDetail(widget.bookId);
    _loadInitialState(); // ── FIX: gộp 2 lần gọi vào 1
  }

  // ── FIX: gọi cả checkSaved lẫn loadProgress cùng lúc ────────────
  Future<void> _loadInitialState() async {
    final loggedIn = await AuthService.isLoggedIn();
    if (!loggedIn) return;

    // Chạy song song
    final results = await Future.wait([
      _libraryService.checkIsSaved(widget.bookId),
      ReadingProgressService.getProgress(widget.bookId),
    ]);

    if (!mounted) return;

    final isSaved = results[0] as bool;
    final progress = results[1] as Map<String, dynamic>?;

    setState(() {
      _isSaved = isSaved;
      _hasStartedReading = progress?['hasProgress'] == true;
      _savedChapter = progress?['currentChapter'] ?? 1;
    });
  }

  Future<void> _loadReadingProgress() async {
    final loggedIn = await AuthService.isLoggedIn();
    if (!loggedIn) return;

    final progress = await ReadingProgressService.getProgress(widget.bookId);
    if (progress != null && mounted) {
      setState(() {
        _hasStartedReading = progress['hasProgress'] == true;
        _savedChapter = progress['currentChapter'] ?? 1;
      });
    }
  }

  Future<void> _toggleSave(BookDetail book) async {
    final loggedIn = await AuthService.isLoggedIn();
    if (!loggedIn) {
      if (!mounted) return;
      showLoginRequiredDialog(
        context: context,
        onLogin: () => Navigator.of(context).pushNamed('/login'),
      );
      return;
    }

    try {
      final isNowSaved = await _libraryService.toggleSaveBook(book.bookId);
      if (!mounted) return;
      setState(() => _isSaved = isNowSaved);
      AppSnack.show(
        context,
        _isSaved ? 'Đã lưu "${book.title}"' : 'Đã bỏ lưu "${book.title}"',
        isSuccess: _isSaved,
      );
    } catch (e) {
      if (mounted) AppSnack.show(context, 'Lỗi: $e', isError: true);
    }
  }

  Future<void> _startReading(BookDetail book) async {
    final loggedIn = await AuthService.isLoggedIn();
    if (!loggedIn) {
      if (!mounted) return;
      showLoginRequiredDialog(
        context: context,
        onLogin: () => Navigator.of(context).pushNamed('/login'),
      );
      return;
    }

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReadingScreen(
          bookId: book.bookId,
          bookTitle: book.title,
          initialChapter: _savedChapter,
        ),
      ),
    ).then((_) => _loadReadingProgress());
  }

  Future<void> _download(BookDetail book) async {
    if (book.fileUrl == null || book.fileUrl!.isEmpty) {
      AppSnack.show(context, 'Sách này chưa có file để tải về', isError: true);
      return;
    }
    if (kIsWeb) {
      AppSnack.show(
        context,
        'Tính năng tải về chỉ hỗ trợ trên mobile',
        isError: true,
      );
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

      if (mounted)
        AppSnack.show(context, 'Đã tải về: $fileName', isSuccess: true);
    } catch (e) {
      if (mounted) AppSnack.show(context, 'Tải về thất bại: $e', isError: true);
    } finally {
      if (mounted)
        setState(() {
          _isDownloading = false;
          _downloadProgress = 0;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BookDetail>(
      future: _futureDetail,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: AppColors.bg,
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.accent,
                strokeWidth: 2,
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: AppColors.bg,
            body: BookDetailErrorView(
              onRetry: () => setState(
                () => _futureDetail = _service.fetchDetail(widget.bookId),
              ),
            ),
          );
        }

        final book = snapshot.data!;
        return BookDetailView(
          book: book,
          heroTag: widget.heroTag,
          isSaved: _isSaved,
          isDownloading: _isDownloading,
          downloadProgress: _downloadProgress,
          hasStartedReading: _hasStartedReading,
          savedChapter: _savedChapter,
          onToggleSave: () => _toggleSave(book),
          onDownload: () => _download(book),
          onStartReading: () => _startReading(book),
        );
      },
    );
  }
}
