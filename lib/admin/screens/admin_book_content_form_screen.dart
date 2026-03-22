import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:docx_to_text/docx_to_text.dart';
import 'package:librarybookshelf/admin/widgets/admin_ui_components.dart';
import 'package:librarybookshelf/admin/models/admin_book_model.dart';
import 'package:librarybookshelf/admin/models/admin_book_content_model.dart';
import 'package:librarybookshelf/admin/services/admin_book_content_service.dart';
import 'package:librarybookshelf/theme/app_theme.dart';

class AdminBookContentFormScreen extends StatefulWidget {
  final AdminBookModel book;
  final AdminBookContentModel? content;
  final VoidCallback? onSuccess;

  const AdminBookContentFormScreen({
    super.key,
    required this.book,
    this.content,
    this.onSuccess,
  });

  @override
  State<AdminBookContentFormScreen> createState() =>
      _AdminBookContentFormScreenState();
}

class _AdminBookContentFormScreenState
    extends State<AdminBookContentFormScreen> {
  late TextEditingController _chapterNumberCtrl;
  late TextEditingController _chapterTitleCtrl;
  late TextEditingController _contentCtrl;
  bool _isLoading = false;
  String? _selectedFileName; // Use string instead of File for web support
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadContentIfEditing();
  }

  void _initializeControllers() {
    _chapterNumberCtrl = TextEditingController(
      text: widget.content?.chapterNumber.toString() ?? '',
    );
    _chapterTitleCtrl = TextEditingController(
      text: widget.content?.chapterTitle ?? '',
    );
    _contentCtrl = TextEditingController(text: widget.content?.content ?? '');
  }

  Future<void> _loadContentIfEditing() async {
    if (widget.content != null) {
      try {
        // Load chi tiết content từ DB
        final fullContent =
            await AdminBookContentService.getContentByChapterNumber(
              widget.book.bookId,
              widget.content!.chapterNumber,
            );

        if (mounted) {
          setState(() {
            _contentCtrl.text = fullContent.content;
            _isInitialized = true;
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi load nội dung: $e'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() => _isInitialized = true);
        }
      }
    } else {
      setState(() => _isInitialized = true);
    }
  }

  @override
  void dispose() {
    _chapterNumberCtrl.dispose();
    _chapterTitleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt', 'docx'],
        withData: true,
      );

      if (result != null) {
        final platformFile = result.files.single;
        final fileName = platformFile.name;

        setState(() => _selectedFileName = fileName);

        try {
          String extractedContent = '';
          
          if (fileName.toLowerCase().endsWith('.docx')) {
            // Parse docx from bytes
            if (platformFile.bytes != null) {
              extractedContent = docxToText(platformFile.bytes!);
            } else if (platformFile.path != null) {
              final bytes = await File(platformFile.path!).readAsBytes();
              extractedContent = docxToText(bytes);
            }

            // Fallback: Nếu docx_to_text trả về raw XML (thường chứa thẻ <w:t>), ta sẽ lọc bỏ XML
            if (extractedContent.contains('<w:t') || extractedContent.contains('</w:')) {
              extractedContent = extractedContent.replaceAll(RegExp(r'<[^>]*>'), '');
            }
          } else {
            // Read as text
            if (platformFile.bytes != null) {
              extractedContent = utf8.decode(platformFile.bytes!);
            } else if (platformFile.path != null) {
              extractedContent = await File(platformFile.path!).readAsString();
            }
          }

          if (!mounted) return;

          setState(() => _contentCtrl.text = extractedContent);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Đọc file "$fileName" thành công'),
              backgroundColor: AppColors.success,
            ),
          );
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi đọc nội dung file: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi chọn file: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _submitForm() async {
    if (_chapterNumberCtrl.text.isEmpty ||
        _chapterTitleCtrl.text.isEmpty ||
        _contentCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng điền đầy đủ thông tin'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (widget.content == null) {
        // Tạo mới
        await AdminBookContentService.createContent(
          bookId: widget.book.bookId,
          chapterNumber: int.parse(_chapterNumberCtrl.text),
          chapterTitle: _chapterTitleCtrl.text,
          content: _contentCtrl.text,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thêm chương thành công'),
            backgroundColor: AppColors.success,
          ),
        );
      } else {
        // Cập nhật
        await AdminBookContentService.updateContent(
          widget.book.bookId,
          widget.content!.chapterNumber,
          chapterTitle: _chapterTitleCtrl.text,
          content: _contentCtrl.text,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật chương thành công'),
            backgroundColor: AppColors.success,
          ),
        );
      }
      widget.onSuccess?.call();
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.content != null;

    if (!_isInitialized) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context, false),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textDark,
            size: 18,
          ),
        ),
        title: Text(
          isEditing ? 'Chỉnh sửa chương' : 'Thêm chương mới',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chapter number
            AdminInputField(
              ctrl: _chapterNumberCtrl,
              label: 'Số chương',
              keyboardType: TextInputType.number,
              icon: Icons.numbers_rounded,
            ),
            const SizedBox(height: 16),

            // Chapter title
            AdminInputField(
              ctrl: _chapterTitleCtrl,
              label: 'Tên chương',
              icon: Icons.title_rounded,
            ),
            const SizedBox(height: 24),

            // Khung Upload file
            GestureDetector(
              onTap: _pickFile,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.border,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.chip,
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.cloud_upload_outlined,
                      color: AppColors.accent,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _selectedFileName ?? 'Chọn file TXT/DOCX',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _selectedFileName != null
                            ? AppColors.accent
                            : AppColors.textMid,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Nội dung file tải lên sẽ được điền tự động vào khung bên dưới',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Khung nhập nội dung (Content field)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    'Nội dung chương',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: AppDecorations.inputField,
                  child: TextField(
                    controller: _contentCtrl,
                    maxLines: 20,
                    decoration: const InputDecoration(
                      hoverColor: Colors.transparent,
                      hintText: 'Nhập nội dung chương hoặc tải file lên...',
                      hintStyle: TextStyle(color: AppColors.textLight, fontSize: 13),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textDark,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Submit button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  disabledBackgroundColor: AppColors.accent.withOpacity(0.5),
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
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        isEditing ? 'Cập nhật chương' : 'Thêm chương',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}
