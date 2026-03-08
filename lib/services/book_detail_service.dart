import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:librarybookshelf/models/book_detail_model.dart';
import 'package:librarybookshelf/services/auther_service.dart';
import 'package:librarybookshelf/models/chapter_content.dart'; // model chapter

class BookDetailService {
  String get _base {
    if (kIsWeb) return "https://localhost:7094/api/Books";
    if (Platform.isAndroid) return "https://10.0.2.2:7094/api/Books";
    return "https://localhost:7094/api/Books";
  }

  String get _chapterBase {
    if (kIsWeb) return "https://localhost:7094/api/BookContents";
    if (Platform.isAndroid) return "https://10.0.2.2:7094/api/BookContents";
    return "https://localhost:7094/api/BookContents";
  }

  Future<BookDetail> fetchDetail(int bookId) async {
    final response = await http.get(Uri.parse('$_base/$bookId'));
    if (response.statusCode == 200) {
      return BookDetail.fromJson(jsonDecode(response.body));
    }
    throw Exception('Không thể tải thông tin sách');
  }

  Future<ChapterContent> createChapter(Map<String, dynamic> chapterData) async {
    final headers = await AuthService.authHeaders();
    final response = await http.post(
      Uri.parse(_chapterBase),
      headers: headers,
      body: jsonEncode(chapterData),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return ChapterContent.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Không thể tạo chapter (${response.statusCode})');
    }
  }
}
