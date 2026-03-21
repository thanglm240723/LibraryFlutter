// lib/services/user_stats_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:librarybookshelf/models/user_stats_model.dart';
import 'package:librarybookshelf/services/auther_service.dart';

class UserStatsService {
  static String get baseUrl {
    if (kIsWeb) return 'https://localhost:7094/api/UserStats';
    if (defaultTargetPlatform == TargetPlatform.android) return 'https://10.0.2.2:7094/api/UserStats';
    return 'https://localhost:7094/api/UserStats';
  }

  // ── Lấy stats đầy đủ của user hiện tại ──────────────────────────
  static Future<UserStatsModel?> getMyStats() async {
    try {
      final headers = await AuthService.authHeaders();
      final res = await http.get(Uri.parse('$baseUrl/me'), headers: headers);

      if (res.statusCode == 200) {
        return UserStatsModel.fromJson(jsonDecode(res.body));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ── Lấy badges của user ──────────────────────────────────────────
  static Future<List<BadgeModel>> getMyBadges() async {
    try {
      final headers = await AuthService.authHeaders();
      final res = await http.get(
        Uri.parse('$baseUrl/me/badges'),
        headers: headers,
      );

      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return data.map((b) => BadgeModel.fromJson(b)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // ── Lấy leaderboard ──────────────────────────────────────────────
  // type: "books" | "streak" | "pages" | "hours"
  static Future<List<LeaderboardEntryModel>> getLeaderboard({
    String type = 'books',
    int top = 20,
  }) async {
    try {
      final headers = await AuthService.authHeaders();
      final res = await http.get(
        Uri.parse('$baseUrl/leaderboard?type=$type&top=$top'),
        headers: headers,
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final List entries = data['entries'] ?? [];
        return entries.map((e) => LeaderboardEntryModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
