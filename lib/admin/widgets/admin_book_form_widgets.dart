import 'package:flutter/material.dart';
import 'package:librarybookshelf/admin/services/admin_book_service.dart';
import 'package:librarybookshelf/theme/app_theme.dart';

// ── EDIT BOOK FORM ────────────────────────────────────────────────────

class EditBookForm extends StatefulWidget {
  final Map<String, dynamic> book;
  const EditBookForm({required this.book});

  @override
  State<EditBookForm> createState() => _EditBookFormState();
}

class _EditBookFormState extends State<EditBookForm> {
  late final TextEditingController _titleController;
  late final TextEditingController _authorController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _coverImageUrlController;
  late final TextEditingController _genreController;
  late final TextEditingController _pageCountController;
  late final TextEditingController _publishedYearController;
  late final TextEditingController _ratingController;
  late final TextEditingController _languageController;
  late final TextEditingController _fileUrlController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book['title'] ?? '');
    _authorController = TextEditingController(
      text: widget.book['author'] ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.book['description'] ?? '',
    );
    _coverImageUrlController = TextEditingController(
      text: widget.book['coverImageUrl'] ?? '',
    );
    _genreController = TextEditingController(text: widget.book['genre'] ?? '');
    _pageCountController = TextEditingController(
      text: (widget.book['pageCount'] ?? '').toString().replaceAll('null', ''),
    );
    _publishedYearController = TextEditingController(
      text: (widget.book['publishedYear'] ?? '').toString().replaceAll(
        'null',
        '',
      ),
    );
    _ratingController = TextEditingController(
      text: (widget.book['rating'] ?? '').toString().replaceAll('null', ''),
    );
    _languageController = TextEditingController(
      text: widget.book['language'] ?? '',
    );
    _fileUrlController = TextEditingController(
      text: widget.book['fileUrl'] ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _coverImageUrlController.dispose();
    _genreController.dispose();
    _pageCountController.dispose();
    _publishedYearController.dispose();
    _ratingController.dispose();
    _languageController.dispose();
    _fileUrlController.dispose();
    super.dispose();
  }

  Future<void> _updateBook() async {
    if (_titleController.text.isEmpty || _authorController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tiêu đề và tác giả không được để trống'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await AdminBookService.updateBook(
        widget.book['bookId'],
        title: _titleController.text,
        author: _authorController.text,
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
        coverImageUrl: _coverImageUrlController.text.isEmpty
            ? null
            : _coverImageUrlController.text,
        genre: _genreController.text.isEmpty ? null : _genreController.text,
        pageCount: _pageCountController.text.isEmpty
            ? null
            : int.tryParse(_pageCountController.text),
        publishedYear: _publishedYearController.text.isEmpty
            ? null
            : int.tryParse(_publishedYearController.text),
        rating: _ratingController.text.isEmpty
            ? null
            : double.tryParse(_ratingController.text),
        language: _languageController.text.isEmpty
            ? null
            : _languageController.text,
        fileUrl: _fileUrlController.text.isEmpty
            ? null
            : _fileUrlController.text,
      );

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(
      24,
      20,
      24,
      MediaQuery.of(context).viewInsets.bottom + 24,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BookSheetHandle(),
        const SizedBox(height: 20),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _coverImageUrlController,
          builder: (context, value, child) =>
              BookImagePreview(imageUrl: value.text),
        ),
        const SizedBox(height: 20),
        const Text(
          "Chỉnh sửa sách",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                BookField(
                  ctrl: _titleController,
                  label: "Tiêu đề *",
                  icon: Icons.title_rounded,
                ),
                const SizedBox(height: 12),
                BookField(
                  ctrl: _authorController,
                  label: "Tác giả *",
                  icon: Icons.person_outline_rounded,
                ),
                const SizedBox(height: 12),
                BookField(
                  ctrl: _descriptionController,
                  label: "Mô tả",
                  icon: Icons.description_outlined,
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                BookField(
                  ctrl: _coverImageUrlController,
                  label: "URL Hình ảnh bìa",
                  icon: Icons.image,
                ),
                const SizedBox(height: 12),
                BookField(
                  ctrl: _genreController,
                  label: "Thể loại",
                  icon: Icons.category,
                ),
                const SizedBox(height: 12),
                BookField(
                  ctrl: _pageCountController,
                  label: "Số trang",
                  icon: Icons.pages,
                ),
                const SizedBox(height: 12),
                BookField(
                  ctrl: _publishedYearController,
                  label: "Năm xuất bản",
                  icon: Icons.calendar_today,
                ),
                const SizedBox(height: 12),
                BookField(
                  ctrl: _ratingController,
                  label: "Rating (0-5)",
                  icon: Icons.star,
                ),
                const SizedBox(height: 12),
                BookField(
                  ctrl: _languageController,
                  label: "Ngôn ngữ",
                  icon: Icons.language,
                ),
                const SizedBox(height: 12),
                BookField(
                  ctrl: _fileUrlController,
                  label: "URL File",
                  icon: Icons.file_download,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _updateBook,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.card,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    "Lưu thay đổi",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
          ),
        ),
      ],
    ),
  );
}

// ── CREATE BOOK FORM ───────────────────────────────────────────────────

class CreateBookForm extends StatefulWidget {
  const CreateBookForm();

  @override
  State<CreateBookForm> createState() => _CreateBookFormState();
}

class _CreateBookFormState extends State<CreateBookForm> {
  late final TextEditingController _titleController;
  late final TextEditingController _authorController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _coverImageUrlController;
  late final TextEditingController _genreController;
  late final TextEditingController _pageCountController;
  late final TextEditingController _publishedYearController;
  late final TextEditingController _ratingController;
  late final TextEditingController _languageController;
  late final TextEditingController _fileUrlController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _authorController = TextEditingController();
    _descriptionController = TextEditingController();
    _coverImageUrlController = TextEditingController();
    _genreController = TextEditingController();
    _pageCountController = TextEditingController();
    _publishedYearController = TextEditingController();
    _ratingController = TextEditingController();
    _languageController = TextEditingController();
    _fileUrlController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _coverImageUrlController.dispose();
    _genreController.dispose();
    _pageCountController.dispose();
    _publishedYearController.dispose();
    _ratingController.dispose();
    _languageController.dispose();
    _fileUrlController.dispose();
    super.dispose();
  }

  Future<void> _createBook() async {
    if (_titleController.text.isEmpty || _authorController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tiêu đề và tác giả không được để trống'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await AdminBookService.createBook(
        title: _titleController.text,
        author: _authorController.text,
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
        coverImageUrl: _coverImageUrlController.text.isEmpty
            ? null
            : _coverImageUrlController.text,
        genre: _genreController.text.isEmpty ? null : _genreController.text,
        pageCount: _pageCountController.text.isEmpty
            ? null
            : int.tryParse(_pageCountController.text),
        publishedYear: _publishedYearController.text.isEmpty
            ? null
            : int.tryParse(_publishedYearController.text),
        rating: _ratingController.text.isEmpty
            ? null
            : double.tryParse(_ratingController.text),
        language: _languageController.text.isEmpty
            ? null
            : _languageController.text,
        fileUrl: _fileUrlController.text.isEmpty
            ? null
            : _fileUrlController.text,
      );

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(
      24,
      20,
      24,
      MediaQuery.of(context).viewInsets.bottom + 24,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BookSheetHandle(),
        const SizedBox(height: 20),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _coverImageUrlController,
          builder: (context, value, child) =>
              BookImagePreview(imageUrl: value.text),
        ),
        const SizedBox(height: 20),
        const Text(
          "Thêm sách mới",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                BookField(
                  ctrl: _titleController,
                  label: "Tiêu đề *",
                  icon: Icons.title_rounded,
                ),
                const SizedBox(height: 12),
                BookField(
                  ctrl: _authorController,
                  label: "Tác giả *",
                  icon: Icons.person_outline_rounded,
                ),
                const SizedBox(height: 12),
                BookField(
                  ctrl: _descriptionController,
                  label: "Mô tả",
                  icon: Icons.description_outlined,
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                BookField(
                  ctrl: _coverImageUrlController,
                  label: "URL Hình ảnh bìa",
                  icon: Icons.image,
                ),
                const SizedBox(height: 12),
                BookField(
                  ctrl: _genreController,
                  label: "Thể loại",
                  icon: Icons.category,
                ),
                const SizedBox(height: 12),
                BookField(
                  ctrl: _pageCountController,
                  label: "Số trang",
                  icon: Icons.pages,
                ),
                const SizedBox(height: 12),
                BookField(
                  ctrl: _publishedYearController,
                  label: "Năm xuất bản",
                  icon: Icons.calendar_today,
                ),
                const SizedBox(height: 12),
                BookField(
                  ctrl: _ratingController,
                  label: "Rating (0-5)",
                  icon: Icons.star,
                ),
                const SizedBox(height: 12),
                BookField(
                  ctrl: _languageController,
                  label: "Ngôn ngữ",
                  icon: Icons.language,
                ),
                const SizedBox(height: 12),
                BookField(
                  ctrl: _fileUrlController,
                  label: "URL File",
                  icon: Icons.file_download,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _createBook,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.card,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    "Tạo sách",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
          ),
        ),
      ],
    ),
  );
}

// ── SHARED WIDGETS ────────────────────────────────────────────────────

class BookSheetHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      width: 36,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(2),
      ),
    ),
  );
}

class BookField extends StatelessWidget {
  final TextEditingController ctrl;
  final String label;
  final IconData icon;
  final int maxLines;

  const BookField({
    required this.ctrl,
    required this.label,
    required this.icon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AppColors.bg,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.border),
    ),
    child: TextField(
      controller: ctrl,
      maxLines: maxLines,
      minLines: 1,
      style: const TextStyle(color: AppColors.textDark, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textLight, fontSize: 13),
        prefixIcon: Icon(icon, color: AppColors.textLight, size: 18),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
      ),
    ),
  );
}

class BookImagePreview extends StatelessWidget {
  final String imageUrl;

  const BookImagePreview({required this.imageUrl});

  void _showFullScreenImage(BuildContext context) {
    if (imageUrl.isEmpty) return;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: InteractiveViewer(
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.broken_image, size: 64, color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Không thể tải hình ảnh',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showFullScreenImage(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: double.infinity,
          height: 300,
          child: imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: AppColors.bg,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.accent,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.chip,
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image,
                            color: AppColors.textLight,
                            size: 48,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'URL hình ảnh không hợp lệ',
                            style: TextStyle(color: AppColors.textLight),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(
                  color: AppColors.chip,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported,
                          color: AppColors.textLight,
                          size: 48,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Chưa nhập URL hình ảnh',
                          style: TextStyle(color: AppColors.textLight),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
