import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:librarybookshelf/models/reading_screen_model.dart';

class ReadingService {
  String get _base {
    if (kIsWeb) return "https://localhost:7094/api/Books";
    if (!kIsWeb && Platform.isAndroid) return "https://10.0.2.2:7094/api/Books";
    return "https://localhost:7094/api/Books";
  }

  Future<List<ChapterListItem>> fetchChapterList(int bookId) async {
    final res = await http.get(Uri.parse('$_base/$bookId/chapters'));
    if (res.statusCode == 200) {
      final List list = jsonDecode(res.body);
      return list.map((e) => ChapterListItem.fromJson(e)).toList();
    }
    throw Exception('Không thể tải danh sách chương');
  }

  Future<ChapterContent> fetchChapter(int bookId, int chapterNumber) async {
    final res = await http.get(
      Uri.parse('$_base/$bookId/chapters/$chapterNumber'),
    );
    if (res.statusCode == 200) {
      return ChapterContent.fromJson(jsonDecode(res.body));
    }
    throw Exception('Không thể tải nội dung chương');
  }
}
