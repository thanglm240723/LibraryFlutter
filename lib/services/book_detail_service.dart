import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:librarybookshelf/models/book_detail_model.dart';

class BookDetailService {
  String get _base {
    if (kIsWeb) return "https://localhost:7094/api/Books";
    if (Platform.isAndroid) return "https://10.0.2.2:7094/api/Books";
    return "https://localhost:7094/api/Books";
  }

  Future<BookDetail> fetchDetail(int bookId) async {
    final response = await http.get(Uri.parse('$_base/$bookId'));
    if (response.statusCode == 200) {
      return BookDetail.fromJson(jsonDecode(response.body));
    }
    throw Exception('Không thể tải thông tin sách');
  }
}
