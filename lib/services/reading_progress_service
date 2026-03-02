import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:librarybookshelf/services/auther_service.dart';

class ReadingProgressService {
  static String get baseUrl {
    if (kIsWeb) return "https://localhost:7094/api/ReadingProgress";
    if (!kIsWeb && Platform.isAndroid)
      return "https://10.0.2.2:7094/api/ReadingProgress";
    return "https://localhost:7094/api/ReadingProgress";
  }

  // Lấy tiến trình đọc của 1 cuốn sách
  // Trả về: {currentChapter: int, hasProgress: bool, progressPercentage: double}
  static Future<Map<String, dynamic>?> getProgress(int bookId) async {
    try {
      final headers = await AuthService.authHeaders();
      final res = await http.get(
        Uri.parse('$baseUrl/$bookId'),
        headers: headers,
      );
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Lưu tiến trình đọc
  static Future<bool> saveProgress({
    required int bookId,
    required int currentChapter,
    int currentPosition = 0,
  }) async {
    try {
      final headers = await AuthService.authHeaders();
      final res = await http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: jsonEncode({
          'bookId': bookId,
          'currentChapter': currentChapter,
          'currentPosition': currentPosition,
        }),
      );
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}