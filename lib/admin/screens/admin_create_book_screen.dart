// Removed dart:io import
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:librarybookshelf/admin/services/admin_book_service.dart';
import 'package:librarybookshelf/services/firebase_storage_service.dart';
import 'package:librarybookshelf/theme/app_theme.dart';

class AdminCreateBookScreen extends StatefulWidget {
  const AdminCreateBookScreen({super.key});

  @override
  State<AdminCreateBookScreen> createState() => _AdminCreateBookScreenState();
}

class _AdminCreateBookScreenState extends State<AdminCreateBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _genreController = TextEditingController();
  final _pageCountController = TextEditingController();
  final _publishedYearController = TextEditingController();
  final _languageController = TextEditingController();
  final _fileUrlController = TextEditingController();

  bool _isLoading = false;
  bool _isUploadingImage = false;
  String? _coverImageUrl;

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _genreController.dispose();
    _pageCountController.dispose();
    _publishedYearController.dispose();
    _languageController.dispose();
    _fileUrlController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _isUploadingImage = true;
        });
        await Future.delayed(const Duration(milliseconds: 100)); // Yield to renderer

        try {
          final fileBytes = await pickedFile.readAsBytes();
          _coverImageUrl = await FirebaseStorageService.uploadCoverImageTemp(
            fileBytes,
            pickedFile.name,
          );
          if (mounted) {
            setState(() {
              _isUploadingImage = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Upload ảnh thành công'),
                backgroundColor: AppColors.success,
              ),
            );
          }
        } catch (e) {
          if (mounted) {
            setState(() {
              _isUploadingImage = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.toString().replaceAll('Exception: ', '')),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi chọn ảnh: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: AppDecorations.inputField,
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
        style: const TextStyle(color: AppColors.textDark, fontSize: 14),
        decoration: InputDecoration(
          hoverColor: Colors.transparent,
          labelText: label,
          hintText: hint,
          labelStyle: const TextStyle(color: AppColors.textMid, fontSize: 13),
          floatingLabelStyle: const TextStyle(color: AppColors.accent, fontSize: 13, fontWeight: FontWeight.w600),
          hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 13),
          prefixIcon: Icon(icon, color: AppColors.textLight, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Future<void> _createBook() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await AdminBookService.createBook(
        title: _titleController.text,
        author: _authorController.text,
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
        coverImageUrl: _coverImageUrl,
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Tạo sách thành công'),
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
          'Thêm sách mới',
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
                    // Image Preview Section
                    GestureDetector(
                      onTap: _isUploadingImage ? null : _pickImage,
                      child: Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                _coverImageUrl != null &&
                                    _coverImageUrl!.isNotEmpty
                                ? AppColors.accent
                                : AppColors.border,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.chip,
                        ),
                        child: _isUploadingImage
                            ? const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      color: AppColors.accent,
                                    ),
                                  ],
                                ),
                              )
                            : _coverImageUrl != null &&
                                  _coverImageUrl!.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  _coverImageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.image_not_supported,
                                              size: 48,
                                              color: AppColors.textLight,
                                            ),
                                            const SizedBox(height: 16),
                                            const Text(
                                              'Ảnh lỗi, nhấn để tải lại',
                                              style: TextStyle(
                                                color: AppColors.textMid,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                ),
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.cloud_upload_outlined,
                                      size: 48,
                                      color: AppColors.accent,
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Nhấn để tải lên ảnh bìa',
                                      style: TextStyle(
                                        color: AppColors.textMid,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'JPG, PNG hoặc WebP',
                                      style: TextStyle(
                                        color: AppColors.textLight,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    _buildModernTextField(
                      controller: _titleController,
                      label: 'Tiêu đề *',
                      hint: 'Nhập tiêu đề sách',
                      icon: Icons.title,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Tiêu đề không được để trống';
                        if (value.length > 255) return 'Tiêu đề không vượt quá 255 ký tự';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildModernTextField(
                      controller: _authorController,
                      label: 'Tác giả *',
                      hint: 'Nhập tác giả',
                      icon: Icons.person,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Tác giả không được để trống';
                        if (value.length > 100) return 'Tác giả không vượt quá 100 ký tự';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildModernTextField(
                      controller: _descriptionController,
                      label: 'Mô tả',
                      hint: 'Nhập mô tả sách',
                      icon: Icons.description,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 16),
                    _buildModernTextField(
                      controller: _genreController,
                      label: 'Thể loại',
                      hint: 'VD: Tiểu thuyết, Khoa học...',
                      icon: Icons.category,
                      validator: (value) {
                        if (value != null && value.length > 50) return 'Thể loại không vượt quá 50 ký tự';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildModernTextField(
                      controller: _pageCountController,
                      label: 'Số trang',
                      hint: '0',
                      icon: Icons.pages,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final page = int.tryParse(value);
                          if (page == null || page < 1 || page > 99999) return 'Số trang phải từ 1 đến 99999';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildModernTextField(
                      controller: _publishedYearController,
                      label: 'Năm xuất bản',
                      hint: '2024',
                      icon: Icons.calendar_today,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final year = int.tryParse(value);
                          if (year == null || year < 1000 || year > 2100) return 'Năm xuất bản không hợp lệ';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildModernTextField(
                      controller: _languageController,
                      label: 'Ngôn ngữ',
                      hint: 'VD: Tiếng Việt, English...',
                      icon: Icons.language,
                      validator: (value) {
                        if (value != null && value.length > 20) return 'Ngôn ngữ không vượt quá 20 ký tự';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildModernTextField(
                      controller: _fileUrlController,
                      label: 'URL File',
                      hint: 'https://example.com/book.pdf',
                      icon: Icons.file_download,
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
                            onPressed: _isLoading ? null : _createBook,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accent,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text(
                              'Tạo Sách',
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
