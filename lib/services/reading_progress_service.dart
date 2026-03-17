import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:librarybookshelf/models/user_stats_model.dart';
import 'package:librarybookshelf/services/auther_service.dart';

class ReadingProgressService {
  static String get baseUrl {
    if (kIsWeb) return 'https://localhost:7094/api/ReadingProgress';
    if (!kIsWeb && Platform.isAndroid)
      return 'https://10.0.2.2:7094/api/ReadingProgress';
    return 'https://localhost:7094/api/ReadingProgress';
  }

  static Future<Map<String, dynamic>?> getProgress(int bookId) async {
    try {
      final headers = await AuthService.authHeaders();
      final res = await http.get(
        Uri.parse('$baseUrl/$bookId'),
        headers: headers,
      );
      if (res.statusCode == 200) return jsonDecode(res.body);
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<SaveProgressResult> saveProgress({
    required int bookId,
    required int currentChapter,
    int currentPosition = 0,
  }) async {
    try {
      final headers = await AuthService.authHeaders();
      final res = await http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: jsonEncode({
          'bookId': bookId,
          'currentChapter': currentChapter,
          'currentPosition': currentPosition,
        }),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        GamificationResultModel? gamResult;
        if (data['gamification'] != null) {
          gamResult = GamificationResultModel.fromJson(data['gamification']);
        }

        return SaveProgressResult(success: true, gamification: gamResult);
      }
      return SaveProgressResult(success: false);
    } catch (e) {
      return SaveProgressResult(success: false);
    }
  }
}

class SaveProgressResult {
  final bool success;
  final GamificationResultModel? gamification;

  SaveProgressResult({required this.success, this.gamification});

  bool get hasReward => gamification?.hasAnyReward == true;
}
