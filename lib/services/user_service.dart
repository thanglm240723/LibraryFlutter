import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:librarybookshelf/services/auther_service.dart';
import 'package:librarybookshelf/models/user_model.dart';

class UserService {
  static String get baseUrl {
    // Sử dụng cùng baseUrl với AuthService
    return AuthService.baseUrl.replaceFirst('/Auth', ''); // loại bỏ /Auth
  }

  // Lấy danh sách users
  static Future<List<User>> fetchUsers() async {
    final headers = await AuthService.authHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  // Tạo user mới
  static Future<User> createUser({
    required String username,
    required String email,
    required String password,
    required String fullName,
    required String role,
  }) async {
    final headers = await AuthService.authHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: headers,
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'fullName': fullName,
        'role': role,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create user');
    }
  }

  // Cập nhật user
  static Future<User> updateUser({
    required int id,
    String? username,
    String? email,
    String? password, // optional
    String? fullName,
    String? role,
  }) async {
    final headers = await AuthService.authHeaders();
    final body = {
      if (username != null) 'username': username,
      if (email != null) 'email': email,
      if (fullName != null) 'fullName': fullName,
      if (role != null) 'role': role,
      if (password != null && password.isNotEmpty) 'password': password,
    };
    final response = await http.put(
      Uri.parse('$baseUrl/users/$id'),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update user');
    }
  }

  // Xóa user
  static Future<void> deleteUser(int id) async {
    final headers = await AuthService.authHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/users/$id'),
      headers: headers,
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete user');
    }
  }
}
