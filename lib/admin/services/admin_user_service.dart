import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:librarybookshelf/services/auther_service.dart';
import '../models/admin_user_model.dart';

class AdminUserService {
  static String get baseUrl {
    if (kIsWeb) {
      return "https://localhost:7094/api/admin/users";
    } else if (Platform.isAndroid) {
      return "https://10.0.2.2:7094/api/admin/users";
    } else {
      return "https://localhost:7094/api/admin/users";
    }
  }

  /// GET /api/admin/users?page=1&pageSize=20&searchTerm=...
  static Future<PagedUsersResponse> getUsers({
    int page = 1,
    int pageSize = 20,
    String? searchTerm,
  }) async {
    try {
      String url = '$baseUrl?page=$page&pageSize=$pageSize';
      if (searchTerm != null && searchTerm.isNotEmpty) {
        url += '&searchTerm=${Uri.encodeComponent(searchTerm)}';
      }

      final headers = await AuthService.authHeaders();
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return PagedUsersResponse.fromJson(data);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - vui lòng đăng nhập lại');
      } else {
        throw Exception(
            'Lỗi khi lấy danh sách user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }

  /// GET /api/admin/users/{userId}
  static Future<AdminUserModel> getUserById(int userId) async {
    try {
      final headers = await AuthService.authHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return AdminUserModel.fromJson(data);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - vui lòng đăng nhập lại');
      } else if (response.statusCode == 404) {
        throw Exception('Không tìm thấy user');
      } else {
        throw Exception(
            'Lỗi khi lấy thông tin user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }
}
