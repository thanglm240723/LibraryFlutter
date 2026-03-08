import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:librarybookshelf/services/auther_service.dart';
import '../models/admin_book_model.dart';

class AdminBookService {
  static String get baseUrl {
    if (kIsWeb) {
      return "https://localhost:7094/api/admin/books";
    } else if (Platform.isAndroid) {
      return "https://10.0.2.2:7094/api/admin/books";
    } else {
      return "https://localhost:7094/api/admin/books";
    }
  }

  // ── Lấy danh sách tất cả sách (với phân trang) ─────────────────────
  static Future<List<AdminBookModel>> getBooks({
    int page = 1,
    int pageSize = 20,
    String? searchTerm,
  }) async {
    try {
      String url = '$baseUrl?page=$page&pageSize=$pageSize';
      if (searchTerm != null && searchTerm.isNotEmpty) {
        url += '&searchTerm=$searchTerm';
      }

      final headers = await AuthService.authHeaders();
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> items = data['items'] ?? [];
        return items
            .map(
              (item) => AdminBookModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - vui lòng đăng nhập lại');
      } else {
        throw Exception('Lỗi khi lấy danh sách sách: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }

  // ── Lấy chi tiết sách theo ID ──────────────────────────────────────
  static Future<AdminBookModel> getBookById(int bookId) async {
    try {
      final headers = await AuthService.authHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/$bookId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return AdminBookModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      } else if (response.statusCode == 404) {
        throw Exception('Không tìm thấy sách');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - vui lòng đăng nhập lại');
      } else {
        throw Exception('Lỗi khi lấy sách: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }

  // ── Tạo sách mới ───────────────────────────────────────────────────
  static Future<AdminBookModel> createBook({
    required String title,
    required String author,
    String? description,
    String? coverImageUrl,
    String? genre,
    int? pageCount,
    int? publishedYear,
    double? rating,
    String? language,
    String? fileUrl,
  }) async {
    try {
      final headers = await AuthService.authHeaders();

      final body = {
        'title': title,
        'author': author,
        'description': description,
        'coverImageUrl': coverImageUrl,
        'genre': genre,
        'pageCount': pageCount,
        'publishedYear': publishedYear,
        'rating': rating,
        'language': language,
        'fileUrl': fileUrl,
      };

      // Xóa các giá trị null
      body.removeWhere((key, value) => value == null);

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        return AdminBookModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      } else if (response.statusCode == 409) {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Sách đã tồn tại');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - vui lòng đăng nhập lại');
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Dữ liệu không hợp lệ');
      } else {
        throw Exception('Lỗi tạo sách: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }

  // ── Cập nhật sách ──────────────────────────────────────────────────
  static Future<AdminBookModel> updateBook(
    int bookId, {
    String? title,
    String? author,
    String? description,
    String? coverImageUrl,
    String? genre,
    int? pageCount,
    int? publishedYear,
    double? rating,
    String? language,
    String? fileUrl,
  }) async {
    try {
      final headers = await AuthService.authHeaders();

      final body = {
        'title': title,
        'author': author,
        'description': description,
        'coverImageUrl': coverImageUrl,
        'genre': genre,
        'pageCount': pageCount,
        'publishedYear': publishedYear,
        'rating': rating,
        'language': language,
        'fileUrl': fileUrl,
      };

      // Xóa các giá trị null
      body.removeWhere((key, value) => value == null);

      final response = await http.put(
        Uri.parse('$baseUrl/$bookId'),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return AdminBookModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      } else if (response.statusCode == 404) {
        throw Exception('Không tìm thấy sách');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - vui lòng đăng nhập lại');
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Dữ liệu không hợp lệ');
      } else {
        throw Exception('Lỗi cập nhật sách: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }

  // ── Xoá sách ───────────────────────────────────────────────────────
  static Future<void> deleteBook(int bookId) async {
    try {
      final headers = await AuthService.authHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/$bookId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 404) {
        throw Exception('Không tìm thấy sách');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - vui lòng đăng nhập lại');
      } else {
        throw Exception('Lỗi xoá sách: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }
}
