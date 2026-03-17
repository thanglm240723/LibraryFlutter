import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:librarybookshelf/services/auther_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static String get baseUrl {
    if (kIsWeb) return 'https://localhost:7094/api/Profile';
    if (Platform.isAndroid) return 'https://10.0.2.2:7094/api/Profile';
    return 'https://localhost:7094/api/Profile';
  }

  // ── Cập nhật thông tin cá nhân ───────────────────────────────────
  static Future<Map<String, dynamic>?> updateProfile({
    String? fullName,
    String? email,
    String? avatarUrl,
  }) async {
    try {
      final headers = await AuthService.authHeaders();
      final body = <String, dynamic>{};
      if (fullName != null) body['fullName'] = fullName;
      if (email != null) body['email'] = email;
      if (avatarUrl != null) body['avatarUrl'] = avatarUrl;

      final res = await http.put(
        Uri.parse(baseUrl),
        headers: headers,
        body: jsonEncode(body),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        // Cập nhật lại SharedPreferences local
        final prefs = await SharedPreferences.getInstance();
        if (data['fullName'] != null)
          await prefs.setString('fullName', data['fullName']);
        if (data['email'] != null)
          await prefs.setString('email', data['email']);
        return data;
      }
      if (res.statusCode == 409) {
        final data = jsonDecode(res.body);
        throw Exception(data['message'] ?? 'Email đã tồn tại');
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // ── Đổi mật khẩu ─────────────────────────────────────────────────
  static Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final headers = await AuthService.authHeaders();
      final res = await http.put(
        Uri.parse('$baseUrl/change-password'),
        headers: headers,
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // ── Ghi thời gian đọc khi rời ReadingScreen ──────────────────────
  static Future<void> trackReadingTime({
    required int bookId,
    required int minutesRead,
  }) async {
    if (minutesRead <= 0) return;
    try {
      final headers = await AuthService.authHeaders();
      await http.post(
        Uri.parse('$baseUrl/track-time'),
        headers: headers,
        body: jsonEncode({'bookId': bookId, 'minutesRead': minutesRead}),
      );
    } catch (_) {
      // Silent fail — không quan trọng nếu lỗi
    }
  }

  // ── Lấy lịch sử đọc ─────────────────────────────────────────────
  static Future<List<Map<String, dynamic>>> getReadingHistory({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final headers = await AuthService.authHeaders();
      final res = await http.get(
        Uri.parse('$baseUrl/reading-history?page=$page&pageSize=$pageSize'),
        headers: headers,
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final items = data['items'] as List<dynamic>? ?? [];
        return items.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
