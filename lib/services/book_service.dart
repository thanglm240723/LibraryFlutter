// lib/services/book_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:librarybookshelf/models/book_model.dart';

class BookService {
  String get baseUrl {
    if (kIsWeb) return 'https://localhost:7094/api/Books';
    if (defaultTargetPlatform == TargetPlatform.android) return 'https://10.0.2.2:7094/api/Books';
    return 'https://localhost:7094/api/Books';
  }

  // ── Lấy sách (mặc định / search text) ───────────────────────────
  Future<List<BookModel>> fetchBooks({String searchTerm = ''}) async {
    final String url = searchTerm.isEmpty
        ? '$baseUrl?page=1&pageSize=20'
        : '$baseUrl/search?SearchTerm=${Uri.encodeComponent(searchTerm)}&PageNumber=1&PageSize=20';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List list = data['items'] ?? [];
      return list.map((j) => BookModel.fromJson(j)).toList();
    }
    throw Exception('Failed to load books');
  }

  // ── Lọc theo thể loại ────────────────────────────────────────────
  // Dùng endpoint /search với param Genre riêng
  Future<List<BookModel>> fetchBooksByGenre(String genre) async {
    final url =
        '$baseUrl/search?Genre=${Uri.encodeComponent(genre)}&PageNumber=1&PageSize=20';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List list = data['items'] ?? [];
      return list.map((j) => BookModel.fromJson(j)).toList();
    }
    throw Exception('Failed to load books by genre');
  }
}
