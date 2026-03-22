import 'package:flutter/material.dart';
import 'package:librarybookshelf/admin/services/admin_book_service.dart';
import 'package:librarybookshelf/theme/app_theme.dart';
import 'package:librarybookshelf/admin/widgets/admin_ui_components.dart';

// ── EDIT BOOK FORM ────────────────────────────────────────────────────

class EditBookForm extends StatefulWidget {
  final Map<String, dynamic> book;
  final VoidCallback? onSuccessCallback;

  const EditBookForm({required this.book, this.onSuccessCallback});

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

        language: _languageController.text.isEmpty
            ? null
            : _languageController.text,
        fileUrl: _fileUrlController.text.isEmpty
            ? null
            : _fileUrlController.text,
      );

      if (mounted) {
        widget.onSuccessCallback?.call();
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
        AdminSheetHandle(),
        const SizedBox(height: 20),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _coverImageUrlController,
          builder: (context, value, child) =>
              AdminImagePreview(imageUrl: value.text),
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
                AdminInputField(
                  ctrl: _titleController,
                  label: "Tiêu đề *",
                  icon: Icons.title_rounded,
                ),
                const SizedBox(height: 12),
                AdminInputField(
                  ctrl: _authorController,
                  label: "Tác giả *",
                  icon: Icons.person_outline_rounded,
                ),
                const SizedBox(height: 12),
                AdminInputField(
                  ctrl: _descriptionController,
                  label: "Mô tả",
                  icon: Icons.description_outlined,
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                AdminInputField(
                  ctrl: _coverImageUrlController,
                  label: "URL Hình ảnh bìa",
                  icon: Icons.image,
                ),
                const SizedBox(height: 12),
                AdminInputField(
                  ctrl: _genreController,
                  label: "Thể loại",
                  icon: Icons.category,
                ),
                const SizedBox(height: 12),
                AdminInputField(
                  ctrl: _pageCountController,
                  label: "Số trang",
                  icon: Icons.pages,
                ),
                const SizedBox(height: 12),
                AdminInputField(
                  ctrl: _publishedYearController,
                  label: "Năm xuất bản",
                  icon: Icons.calendar_today,
                ),
                const SizedBox(height: 12),
                AdminInputField(
                  ctrl: _ratingController,
                  label: "Rating (0-5)",
                  icon: Icons.star,
                ),
                const SizedBox(height: 12),
                AdminInputField(
                  ctrl: _languageController,
                  label: "Ngôn ngữ",
                  icon: Icons.language,
                ),
                const SizedBox(height: 12),
                AdminInputField(
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
  final VoidCallback? onSuccessCallback;

  const CreateBookForm({this.onSuccessCallback});

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

        language: _languageController.text.isEmpty
            ? null
            : _languageController.text,
        fileUrl: _fileUrlController.text.isEmpty
            ? null
            : _fileUrlController.text,
      );

      if (mounted) {
        widget.onSuccessCallback?.call();
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
        AdminSheetHandle(),
        const SizedBox(height: 20),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _coverImageUrlController,
          builder: (context, value, child) =>
              AdminImagePreview(imageUrl: value.text),
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
                AdminInputField(
                  ctrl: _titleController,
                  label: "Tiêu đề *",
                  icon: Icons.title_rounded,
                ),
                const SizedBox(height: 12),
                AdminInputField(
                  ctrl: _authorController,
                  label: "Tác giả *",
                  icon: Icons.person_outline_rounded,
                ),
                const SizedBox(height: 12),
                AdminInputField(
                  ctrl: _descriptionController,
                  label: "Mô tả",
                  icon: Icons.description_outlined,
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                AdminInputField(
                  ctrl: _coverImageUrlController,
                  label: "URL Hình ảnh bìa",
                  icon: Icons.image,
                ),
                const SizedBox(height: 12),
                AdminInputField(
                  ctrl: _genreController,
                  label: "Thể loại",
                  icon: Icons.category,
                ),
                const SizedBox(height: 12),
                AdminInputField(
                  ctrl: _pageCountController,
                  label: "Số trang",
                  icon: Icons.pages,
                ),
                const SizedBox(height: 12),
                AdminInputField(
                  ctrl: _publishedYearController,
                  label: "Năm xuất bản",
                  icon: Icons.calendar_today,
                ),
                const SizedBox(height: 12),
                AdminInputField(
                  ctrl: _ratingController,
                  label: "Rating (0-5)",
                  icon: Icons.star,
                ),
                const SizedBox(height: 12),
                AdminInputField(
                  ctrl: _languageController,
                  label: "Ngôn ngữ",
                  icon: Icons.language,
                ),
                const SizedBox(height: 12),
                AdminInputField(
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
