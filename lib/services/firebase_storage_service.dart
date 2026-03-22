import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'firebase_config.dart';

class FirebaseStorageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Initialize Firebase Storage with configuration
  static void initialize() {
    // Firebase Storage is already initialized through FirebaseConfig.initialize()
    // stored in firebase_config.dart
  }

  /// Upload ảnh bìa sách lên Firebase Storage
  /// [file] - File ảnh cần upload
  /// [bookId] - ID của sách (để tổ chức thư mục)
  /// Returns: URL của ảnh sau khi upload
  static Future<String> uploadCoverImage(Uint8List fileBytes, String originalName, int bookId) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = originalName.split('.').last.toLowerCase();
      final contentType = extension == 'jpg' ? 'jpeg' : extension;
      final fileName = 'book_${bookId}_cover_$timestamp.$extension';
      final ref = _storage.ref().child('books/$bookId/$fileName');

      final metadata = SettableMetadata(
        contentType: 'image/$contentType',
      );

      await ref.putData(fileBytes, metadata);
      final downloadUrl = await ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Lỗi upload hình ảnh: ${e.toString()}');
    }
  }

  /// Upload ảnh bìa sách khi chưa có bookId (cho tạo sách mới)
  /// [file] - File ảnh cần upload
  /// Returns: URL của ảnh sau khi upload
  static Future<String> uploadCoverImageTemp(Uint8List fileBytes, String originalName) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = originalName.split('.').last.toLowerCase();
      final contentType = extension == 'jpg' ? 'jpeg' : extension;
      final fileName = 'temp_cover_$timestamp.$extension';
      final ref = _storage.ref().child('books/temp/$fileName');

      final metadata = SettableMetadata(
        contentType: 'image/$contentType',
      );

      await ref.putData(fileBytes, metadata);
      final downloadUrl = await ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Lỗi upload hình ảnh: ${e.toString()}');
    }
  }

  /// Xóa ảnh cũ khi cập nhật
  /// [imageUrl] - URL của ảnh cần xóa
  static Future<void> deleteImage(String imageUrl) async {
    try {
      if (imageUrl.isEmpty) return;

      // Decode URL để lấy path
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      // Bỏ qua lỗi nếu ảnh không tồn tại
      print('Lỗi xóa hình ảnh: ${e.toString()}');
    }
  }
}
