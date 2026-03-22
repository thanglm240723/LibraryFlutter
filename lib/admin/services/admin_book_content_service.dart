import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:librarybookshelf/services/auther_service.dart';
import '../models/admin_book_content_model.dart';

class AdminBookContentService {
  static String get baseUrl {
    if (kIsWeb) {
      return "https://localhost:7094/api/admin/books";
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return "https://10.0.2.2:7094/api/admin/books";
    } else {
      return "https://localhost:7094/api/admin/books";
    }
  }

  // ── Lấy danh sách nội dung theo bookId ──────────────────────────────
  static Future<List<AdminBookContentModel>> getBookContents({
    required int bookId,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      String url = '$baseUrl/$bookId/contents';

      final headers = await AuthService.authHeaders();
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Backend trả về array trực tiếp, không có 'items' key
        List<dynamic> items = data is List ? data : data['items'] ?? [];
        return items
            .map(
              (item) =>
                  AdminBookContentModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      } else if (response.statusCode == 404) {
        throw Exception('Không tìm thấy sách');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - vui lòng đăng nhập lại');
      } else {
        throw Exception('Lỗi khi lấy nội dung: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }

  // ── Lấy chi tiết nội dung theo chapterNumber ──────────────────────────────
  static Future<AdminBookContentModel> getContentByChapterNumber(
    int bookId,
    int chapterNumber,
  ) async {
    try {
      final headers = await AuthService.authHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/$bookId/contents/$chapterNumber'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return AdminBookContentModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      } else if (response.statusCode == 404) {
        throw Exception('Không tìm thấy chương');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - vui lòng đăng nhập lại');
      } else {
        throw Exception('Lỗi khi lấy nội dung: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }

  // ── Tạo nội dung chương mới ────────────────────────────────────────
  static Future<AdminBookContentModel> createContent({
    required int bookId,
    required int chapterNumber,
    required String chapterTitle,
    required String content,
  }) async {
    try {
      final headers = await AuthService.authHeaders();

      final body = {
        'chapterNumber': chapterNumber,
        'chapterTitle': chapterTitle,
        'content': content,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/$bookId/contents'),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return AdminBookContentModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Dữ liệu không hợp lệ');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - vui lòng đăng nhập lại');
      } else if (response.statusCode == 404) {
        throw Exception('Không tìm thấy sách');
      } else if (response.statusCode == 409) {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Chương đã tồn tại');
      } else {
        throw Exception('Lỗi tạo nội dung: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }

  // ── Cập nhật nội dung chương ───────────────────────────────────────
  static Future<AdminBookContentModel> updateContent(
    int bookId,
    int chapterNumber, {
    int? newChapterNumber,
    String? chapterTitle,
    String? content,
  }) async {
    try {
      final headers = await AuthService.authHeaders();

      final body = <String, dynamic>{};
      if (newChapterNumber != null) body['chapterNumber'] = newChapterNumber;
      if (chapterTitle != null) body['chapterTitle'] = chapterTitle;
      if (content != null) body['content'] = content;

      final response = await http.put(
        Uri.parse('$baseUrl/$bookId/contents/$chapterNumber'),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return AdminBookContentModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      } else if (response.statusCode == 404) {
        throw Exception('Không tìm thấy chương');
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Dữ liệu không hợp lệ');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - vui lòng đăng nhập lại');
      } else if (response.statusCode == 409) {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Chương đã tồn tại');
      } else {
        throw Exception('Lỗi cập nhật nội dung: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }

  // ── Xóa nội dung chương ────────────────────────────────────────────
  static Future<void> deleteContent(int bookId, int chapterNumber) async {
    try {
      final headers = await AuthService.authHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/$bookId/contents/$chapterNumber'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 404) {
        throw Exception('Không tìm thấy chương');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - vui lòng đăng nhập lại');
      } else {
        throw Exception('Lỗi xóa nội dung: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }

  // ── Upload file PDF/DOCS và lấy nội dung ────────────────────────────
  static Future<String> uploadAndExtractContent(File file) async {
    try {
      final headers = await AuthService.authHeaders();

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${baseUrl}_upload'),
      );

      request.headers.addAll(headers);
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        return data['content'] ?? '';
      } else if (response.statusCode == 400) {
        final data = jsonDecode(responseBody);
        throw Exception(data['message'] ?? 'File không hợp lệ');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - vui lòng đăng nhập lại');
      } else {
        throw Exception('Lỗi upload file: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }
}
