import 'package:flutter/material.dart';
import 'package:librarybookshelf/admin/models/admin_book_model.dart';
import 'package:librarybookshelf/admin/models/admin_book_content_model.dart';
import 'package:librarybookshelf/admin/services/admin_book_content_service.dart';
import 'package:librarybookshelf/admin/screens/admin_book_content_form_screen.dart';
import 'package:librarybookshelf/theme/app_theme.dart';

class AdminBookContentScreen extends StatefulWidget {
  final AdminBookModel book;

  const AdminBookContentScreen({super.key, required this.book});

  @override
  State<AdminBookContentScreen> createState() => _AdminBookContentScreenState();
}

class _AdminBookContentScreenState extends State<AdminBookContentScreen> {
  List<AdminBookContentModel> contents = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadContents();
  }

  Future<void> _loadContents() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final loadedContents = await AdminBookContentService.getBookContents(
        bookId: widget.book.bookId,
        pageSize: 100,
      );
      setState(() {
        contents = loadedContents;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString().replaceAll('Exception: ', '');
        isLoading = false;
      });
    }
  }

  void _showAddContentDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => AdminBookContentFormScreen(
          book: widget.book,
          onSuccess: _loadContents,
        ),
      ),
    );
  }

  void _showEditContentDialog(AdminBookContentModel content) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => AdminBookContentFormScreen(
          book: widget.book,
          content: content,
          onSuccess: _loadContents,
        ),
      ),
    );
  }

  Future<void> _deleteContent(int chapterNumber, String chapterTitle) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Xác nhận xóa',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Bạn có chắc chắn muốn xóa chương "$chapterTitle"?',
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
              'Xóa',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await AdminBookContentService.deleteContent(
          widget.book.bookId,
          chapterNumber,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Xóa chương thành công'),
              backgroundColor: AppColors.success,
            ),
          );
          _loadContents();
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quản lý nội dung',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            Text(
              widget.book.title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textMid,
              ),
            ),
          ],
        ),
      ),
      body: isLoading
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
                    onPressed: _loadContents,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Thử lại'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                    ),
                  ),
                ],
              ),
            )
          : contents.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.library_books_rounded,
                    color: AppColors.textLight,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Chưa có chương nào',
                    style: TextStyle(
                      color: AppColors.textMid,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Nhấn nút + để thêm chương đầu tiên',
                    style: TextStyle(color: AppColors.textLight, fontSize: 12),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _showAddContentDialog,
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Thêm chương'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ...contents.map((content) {
                    return _ContentCard(
                      content: content,
                      onEdit: () => _showEditContentDialog(content),
                      onDelete: () => _deleteContent(
                        content.chapterNumber,
                        content.chapterTitle,
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 120),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent,
        onPressed: _showAddContentDialog,
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}

// ── CONTENT CARD ────────────────────────────────────────────────────────
class _ContentCard extends StatelessWidget {
  final AdminBookContentModel content;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ContentCard({
    required this.content,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Chương ${content.chapterNumber}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.accent,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            content.chapterTitle,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: onEdit,
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: AppColors.accent,
                        size: 22,
                      ),
                    ),
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.red,
                        size: 22,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _ContentPreview(content: content.content),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── CONTENT PREVIEW ─────────────────────────────────────────────────────
class _ContentPreview extends StatefulWidget {
  final String content;

  const _ContentPreview({required this.content});

  @override
  State<_ContentPreview> createState() => _ContentPreviewState();
}

class _ContentPreviewState extends State<_ContentPreview> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final previewText = widget.content.length > 300
        ? widget.content.substring(0, 300) + '...'
        : widget.content;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          previewText,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textMid,
            height: 1.6,
          ),
        ),
        if (widget.content.length > 200)
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _isExpanded ? 'Thu gọn' : 'Xem thêm',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accent,
                ),
              ),
            ),
          ),
        if (_isExpanded)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              widget.content,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textMid,
                height: 1.5,
              ),
            ),
          ),
      ],
    );
  }
}
