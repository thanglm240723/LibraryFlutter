import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:librarybookshelf/models/book_model.dart';
import 'package:librarybookshelf/services/auther_service.dart';

class UserLibraryService {
  String get baseUrl {
    if (kIsWeb) {
      return "https://localhost:7094/api/UserLibrary";
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return "https://10.0.2.2:7094/api/UserLibrary"; 
    } else {
      return "https://localhost:7094/api/UserLibrary";
    }
  }

  Future<List<BookModel>> fetchSavedBooks() async {
    final token = await AuthService.getToken();
    if (token == null) return [];

    final response = await http.get(
      Uri.parse('$baseUrl/saved'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List list = json.decode(response.body);
      return list.map((json) => BookModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load saved books');
    }
  }

  Future<bool> toggleSaveBook(int bookId) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception('Vui lòng đăng nhập');

    final response = await http.post(
      Uri.parse('$baseUrl/$bookId/toggle-save'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['isSaved'] ?? false;
    } else {
      throw Exception('Failed to save book');
    }
  }

  Future<bool> checkIsSaved(int bookId) async {
    final token = await AuthService.getToken();
    if (token == null) return false;

    final response = await http.get(
      Uri.parse('$baseUrl/$bookId/check-saved'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['isSaved'] ?? false;
    }
    return false;
  }
}