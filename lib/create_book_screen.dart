import 'package:flutter/material.dart';
import 'package:librarybookshelf/models/chapter_content.dart';
import 'package:librarybookshelf/services/book_detail_service.dart';
import 'package:librarybookshelf/services/book_service.dart';
import 'package:librarybookshelf/theme/app_theme.dart';

class CreateBookScreen extends StatefulWidget {
  const CreateBookScreen({super.key});

  @override
  State<CreateBookScreen> createState() => _CreateBookScreenState();
}

class _CreateBookScreenState extends State<CreateBookScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controllers for book fields
  final _titleCtrl = TextEditingController();
  final _authorCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _coverImageUrlCtrl = TextEditingController();
  final _genreCtrl = TextEditingController();
  final _pageCountCtrl = TextEditingController();
  final _publishedYearCtrl = TextEditingController();
  final _ratingCtrl = TextEditingController();
  final _languageCtrl = TextEditingController();
  final _totalChaptersCtrl = TextEditingController(text: '0'); // tự động

  // Chapters list
  final List<_ChapterInput> _chapters = [];

  @override
  void initState() {
    super.initState();
    _addChapter(); // thêm 1 chapter mặc định
  }

  void _addChapter() {
    setState(() {
      _chapters.add(_ChapterInput(number: _chapters.length + 1));
      _totalChaptersCtrl.text = _chapters.length.toString();
    });
  }

  void _removeChapter(int index) {
    setState(() {
      _chapters.removeAt(index);
      // Cập nhật lại số thứ tự
      for (int i = 0; i < _chapters.length; i++) {
        _chapters[i].number = i + 1;
      }
      _totalChaptersCtrl.text = _chapters.length.toString();
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_chapters.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Phải có ít nhất một chapter'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Tạo đối tượng book data
      final bookData = {
        'title': _titleCtrl.text,
        'author': _authorCtrl.text,
        'description': _descriptionCtrl.text.isNotEmpty
            ? _descriptionCtrl.text
            : null,
        'coverImageUrl': _coverImageUrlCtrl.text.isNotEmpty
            ? _coverImageUrlCtrl.text
            : null,
        'genre': _genreCtrl.text.isNotEmpty ? _genreCtrl.text : null,
        'pageCount': _pageCountCtrl.text.isNotEmpty
            ? int.parse(_pageCountCtrl.text)
            : null,
        'publishedYear': _publishedYearCtrl.text.isNotEmpty
            ? int.parse(_publishedYearCtrl.text)
            : null,
        'rating': _ratingCtrl.text.isNotEmpty
            ? double.parse(_ratingCtrl.text)
            : null,
        'language': _languageCtrl.text.isNotEmpty ? _languageCtrl.text : null,
        'totalChapters': _chapters.length,
      };

      // Gọi API tạo sách
      final createdBook = await BookService().createBook(bookData);
      final bookId = createdBook.bookId;

      // Tạo từng chapter
      for (var chapter in _chapters) {
        final chapterData = {
          'bookId': bookId,
          'chapterNumber': chapter.number,
          'chapterTitle': chapter.titleCtrl.text.isNotEmpty
              ? chapter.titleCtrl.text
              : null,
          'content': chapter.contentCtrl.text,
          'wordCount': chapter.wordCount, // có thể backend tự tính
        };
        await BookDetailService().createChapter(chapterData);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tạo sách thành công!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Thêm sách mới'),
        backgroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'Thông tin sách',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(_titleCtrl, 'Tên sách *', validator: true),
                  _buildTextField(_authorCtrl, 'Tác giả *', validator: true),
                  _buildTextField(_descriptionCtrl, 'Mô tả', maxLines: 3),
                  _buildTextField(_coverImageUrlCtrl, 'URL ảnh bìa'),
                  _buildTextField(_genreCtrl, 'Thể loại'),
                  _buildNumberField(_pageCountCtrl, 'Số trang'),
                  _buildNumberField(_publishedYearCtrl, 'Năm xuất bản'),
                  _buildNumberField(
                    _ratingCtrl,
                    'Đánh giá (0-5)',
                    isDouble: true,
                  ),
                  _buildTextField(_languageCtrl, 'Ngôn ngữ'),
                  const Divider(height: 32, thickness: 1),

                  // Header danh sách chapter
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Danh sách chapter',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _addChapter,
                        icon: const Icon(Icons.add),
                        label: const Text('Thêm chapter'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Danh sách chapter
                  ..._chapters.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final chapter = entry.value;
                    return _ChapterCard(
                      chapter: chapter,
                      index: idx,
                      onRemove: () => _removeChapter(idx),
                    );
                  }),

                  const SizedBox(height: 24),

                  // Nút submit
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors.accent,
                      ),
                      child: const Text(
                        'Tạo sách',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTextField(
    TextEditingController ctrl,
    String label, {
    int maxLines = 1,
    bool validator = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: validator
            ? (v) => v == null || v.isEmpty ? 'Vui lòng nhập $label' : null
            : null,
      ),
    );
  }

  Widget _buildNumberField(
    TextEditingController ctrl,
    String label, {
    bool isDouble = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (v) {
          if (v == null || v.isEmpty) return null;
          if (isDouble) {
            if (double.tryParse(v) == null) return 'Nhập số thực';
          } else {
            if (int.tryParse(v) == null) return 'Nhập số nguyên';
          }
          return null;
        },
      ),
    );
  }
}

// Class lưu tạm thông tin chapter
class _ChapterInput {
  int number;
  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController contentCtrl = TextEditingController();

  _ChapterInput({required this.number});

  int get wordCount => contentCtrl.text.split(RegExp(r'\s+')).length;

  void dispose() {
    titleCtrl.dispose();
    contentCtrl.dispose();
  }
}

// Widget hiển thị một chapter trong danh sách
class _ChapterCard extends StatelessWidget {
  final _ChapterInput chapter;
  final int index;
  final VoidCallback onRemove;

  const _ChapterCard({
    required this.chapter,
    required this.index,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Chapter ${chapter.number}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onRemove,
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: chapter.titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Tiêu đề chapter (không bắt buộc)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: chapter.contentCtrl,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Nội dung *',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Vui lòng nhập nội dung' : null,
            ),
            const SizedBox(height: 4),
            Text(
              'Số từ: ${chapter.wordCount}',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
