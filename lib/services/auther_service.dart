import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static String get baseUrl {
    if (kIsWeb) return "https://localhost:7094/api/Auth";
    if (Platform.isAndroid) return "http://10.0.2.2:7094/api/Auth";
    return "https://localhost:7094/api/Auth";
  }

  // ── Lấy token đã lưu ─────────────────────────────────────────────
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('userId');
    return id == 0 ? null : id;
  }

  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<bool> isAdmin() async {
    final role = await getRole();
    return role == 'admin';
  }

  // ── Header có Bearer token ────────────────────────────────────────
  static Future<Map<String, String>> authHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ── Login ─────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>?> login(
    String username,
    String password,
  ) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token'] ?? '');
        await prefs.setString('fullName', data['fullName'] ?? '');
        await prefs.setString('username', data['username'] ?? '');
        await prefs.setString('email', data['email'] ?? '');
        await prefs.setString('role', data['role'] ?? 'user');
        await prefs.setInt('userId', data['id'] ?? 0);
        return data;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ── Register ──────────────────────────────────────────────────────
  static Future<bool> register({
    required String username,
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'fullName': fullName ?? '',
        }),
      );
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // ── Logout ────────────────────────────────────────────────────────
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('fullName');
    await prefs.remove('username');
    await prefs.remove('email');
    await prefs.remove('role');
    await prefs.remove('userId');
  }

  static Future<Map<String, dynamic>?> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null || token.isEmpty) return null;

    return {
      'username': prefs.getString('username') ?? '',
      'fullName': prefs.getString('fullName') ?? '',
      'email': prefs.getString('email') ?? '',
      'role': prefs.getString('role') ?? 'user',
      'userId': prefs.getInt('userId') ?? 0,
    };
  }
}
