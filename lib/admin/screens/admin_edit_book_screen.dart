import 'package:flutter/material.dart';
import 'package:librarybookshelf/admin/services/admin_book_service.dart';
import 'package:librarybookshelf/theme/app_theme.dart';

class AdminEditBookScreen extends StatefulWidget {
  final Map<String, dynamic> book;

  const AdminEditBookScreen({super.key, required this.book});

  @override
  State<AdminEditBookScreen> createState() => _AdminEditBookScreenState();
}

class _AdminEditBookScreenState extends State<AdminEditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _coverImageUrlController = TextEditingController();
  final _genreController = TextEditingController();
  final _pageCountController = TextEditingController();
  final _publishedYearController = TextEditingController();
  final _ratingController = TextEditingController();
  final _languageController = TextEditingController();
  final _fileUrlController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _titleController.text = widget.book['title'] ?? '';
    _authorController.text = widget.book['author'] ?? '';
    _descriptionController.text = widget.book['description'] ?? '';
    _coverImageUrlController.text = widget.book['coverImageUrl'] ?? '';
    _genreController.text = widget.book['genre'] ?? '';
    _pageCountController.text = (widget.book['pageCount'] ?? '')
        .toString()
        .replaceAll('null', '');
    _publishedYearController.text = (widget.book['publishedYear'] ?? '')
        .toString()
        .replaceAll('null', '');
    _ratingController.text = (widget.book['rating'] ?? '')
        .toString()
        .replaceAll('null', '');
    _languageController.text = widget.book['language'] ?? '';
    _fileUrlController.text = widget.book['fileUrl'] ?? '';
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

  InputDecoration _buildInputDecoration(
    String label,
    String hint,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: AppColors.textMid),
      hintStyle: const TextStyle(color: AppColors.textLight),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.accent, width: 2),
      ),
      prefixIcon: Icon(icon, color: AppColors.accent),
      filled: true,
      fillColor: AppColors.surface,
    );
  }

  Future<void> _updateBook() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Cập nhật sách thành công'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context, true);
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
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text(
          'Chỉnh Sửa Sách',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.surface,
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (widget.book['coverImageUrl'] != null &&
                        (widget.book['coverImageUrl'] as String).isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            widget.book['coverImageUrl'],
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  height: 200,
                                  color: AppColors.chip,
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    color: AppColors.textLight,
                                  ),
                                ),
                          ),
                        ),
                      ),
                    TextFormField(
                      controller: _titleController,
                      decoration: _buildInputDecoration(
                        'Tiêu đề *',
                        'Nhập tiêu đề sách',
                        Icons.title,
                      ),
                      style: const TextStyle(color: AppColors.textDark),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tiêu đề không được để trống';
                        }
                        if (value.length > 255) {
                          return 'Tiêu đề không vượt quá 255 ký tự';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _authorController,
                      decoration: _buildInputDecoration(
                        'Tác giả *',
                        'Nhập tác giả',
                        Icons.person,
                      ),
                      style: const TextStyle(color: AppColors.textDark),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tác giả không được để trống';
                        }
                        if (value.length > 100) {
                          return 'Tác giả không vượt quá 100 ký tự';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: _buildInputDecoration(
                        'Mô tả',
                        'Nhập mô tả sách',
                        Icons.description,
                      ),
                      style: const TextStyle(color: AppColors.textDark),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _coverImageUrlController,
                      decoration: _buildInputDecoration(
                        'URL Hình ảnh bìa',
                        'https://example.com/cover.jpg',
                        Icons.image,
                      ),
                      style: const TextStyle(color: AppColors.textDark),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _genreController,
                      decoration: _buildInputDecoration(
                        'Thể loại',
                        'VD: Tiểu thuyết, Khoa học...',
                        Icons.category,
                      ),
                      style: const TextStyle(color: AppColors.textDark),
                      validator: (value) {
                        if (value != null && value.length > 50) {
                          return 'Thể loại không vượt quá 50 ký tự';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _pageCountController,
                      decoration: _buildInputDecoration(
                        'Số trang',
                        '0',
                        Icons.pages,
                      ),
                      style: const TextStyle(color: AppColors.textDark),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final page = int.tryParse(value);
                          if (page == null || page < 1 || page > 99999) {
                            return 'Số trang phải từ 1 đến 99999';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _publishedYearController,
                      decoration: _buildInputDecoration(
                        'Năm xuất bản',
                        '2024',
                        Icons.calendar_today,
                      ),
                      style: const TextStyle(color: AppColors.textDark),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final year = int.tryParse(value);
                          if (year == null || year < 1000 || year > 2100) {
                            return 'Năm xuất bản không hợp lệ';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _ratingController,
                      decoration: _buildInputDecoration(
                        'Rating (0-5)',
                        '0.0',
                        Icons.star,
                      ),
                      style: const TextStyle(color: AppColors.textDark),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final rating = double.tryParse(value);
                          if (rating == null || rating < 0 || rating > 5) {
                            return 'Rating phải từ 0 đến 5';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _languageController,
                      decoration: _buildInputDecoration(
                        'Ngôn ngữ',
                        'VD: Tiếng Việt, English...',
                        Icons.language,
                      ),
                      style: const TextStyle(color: AppColors.textDark),
                      validator: (value) {
                        if (value != null && value.length > 20) {
                          return 'Ngôn ngữ không vượt quá 20 ký tự';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _fileUrlController,
                      decoration: _buildInputDecoration(
                        'URL File',
                        'https://example.com/book.pdf',
                        Icons.file_download,
                      ),
                      style: const TextStyle(color: AppColors.textDark),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.border),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text(
                              'Huỷ',
                              style: TextStyle(color: AppColors.textDark),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _updateBook,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accent,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text(
                              'Cập Nhật',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
