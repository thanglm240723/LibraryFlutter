import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:librarybookshelf/models/book_model.dart';

class BookService {
  String get baseUrl {
    if (kIsWeb) {
      return "https://localhost:7094/api/Books"; // Flutter Web
    } else if (Platform.isAndroid) {
      return "https://10.0.2.2:7094/api/Books"; // Android Emulator
    } else {
      return "https://localhost:7094/api/Books"; // iOS / Desktop
    }
  }

  Future<List<BookModel>> fetchBooks({String searchTerm = ""}) async {
    // Nếu có searchTerm, gọi endpoint search, nếu không gọi lấy danh sách mặc định
    final String url = searchTerm.isEmpty
        ? '$baseUrl?page=1&pageSize=20'
        : '$baseUrl/search?SearchTerm=$searchTerm&PageNumber=1&PageSize=20';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List list = data['items'];
      return list.map((json) => BookModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }
}
