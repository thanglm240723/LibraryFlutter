// lib/models/user_stats_model.dart

class UserStatsModel {
  final int userId;
  final int totalBooksRead;
  final int totalBooksStarted;
  final int totalPagesRead;
  final int totalMinutesRead;
  final int totalWordsRead;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastReadDate;
  final String rank;
  final String? favoriteGenre;
  final int booksToNextRank;
  final String? nextRank;
  final double totalHoursRead;
  final String totalWordsReadLabel;
  final List<BadgeModel> badges;

  UserStatsModel({
    required this.userId,
    required this.totalBooksRead,
    required this.totalBooksStarted,
    required this.totalPagesRead,
    required this.totalMinutesRead,
    required this.totalWordsRead,
    required this.currentStreak,
    required this.longestStreak,
    this.lastReadDate,
    required this.rank,
    this.favoriteGenre,
    required this.booksToNextRank,
    this.nextRank,
    required this.totalHoursRead,
    required this.totalWordsReadLabel,
    required this.badges,
  });

  factory UserStatsModel.fromJson(Map<String, dynamic> json) {
    return UserStatsModel(
      userId: json['userId'] ?? 0,
      totalBooksRead: json['totalBooksRead'] ?? 0,
      totalBooksStarted: json['totalBooksStarted'] ?? 0,
      totalPagesRead: json['totalPagesRead'] ?? 0,
      totalMinutesRead: json['totalMinutesRead'] ?? 0,
      totalWordsRead: json['totalWordsRead'] ?? 0,
      currentStreak: json['currentStreak'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
      lastReadDate: json['lastReadDate'] != null
          ? DateTime.tryParse(json['lastReadDate'])
          : null,
      rank: json['rank'] ?? 'Mầm Đọc',
      favoriteGenre: json['favoriteGenre'],
      booksToNextRank: json['booksToNextRank'] ?? 0,
      nextRank: json['nextRank'],
      totalHoursRead: (json['totalHoursRead'] ?? 0).toDouble(),
      totalWordsReadLabel: json['totalWordsReadLabel'] ?? '0 từ',
      badges: (json['badges'] as List<dynamic>? ?? [])
          .map((b) => BadgeModel.fromJson(b))
          .toList(),
    );
  }

  // Số sách đang đọc dở (đã bắt đầu nhưng chưa hoàn thành)
  int get booksInProgress => totalBooksStarted - totalBooksRead;
}

class BadgeModel {
  final int badgeId;
  final String name;
  final String? description;
  final String icon;
  final String conditionType;
  final int threshold;
  final DateTime? earnedAt;

  bool get isEarned => earnedAt != null;

  BadgeModel({
    required this.badgeId,
    required this.name,
    this.description,
    required this.icon,
    required this.conditionType,
    required this.threshold,
    this.earnedAt,
  });

  factory BadgeModel.fromJson(Map<String, dynamic> json) {
    return BadgeModel(
      badgeId: json['badgeId'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
      icon: json['icon'] ?? '🏅',
      conditionType: json['conditionType'] ?? '',
      threshold: json['threshold'] ?? 0,
      earnedAt: json['earnedAt'] != null
          ? DateTime.tryParse(json['earnedAt'])
          : null,
    );
  }
}

class LeaderboardEntryModel {
  final int rank;
  final int userId;
  final String username;
  final String? fullName;
  final String? avatarUrl;
  final String rankTitle;
  final int value;
  final String valueLabel;
  final bool isCurrentUser;

  LeaderboardEntryModel({
    required this.rank,
    required this.userId,
    required this.username,
    this.fullName,
    this.avatarUrl,
    required this.rankTitle,
    required this.value,
    required this.valueLabel,
    required this.isCurrentUser,
  });

  factory LeaderboardEntryModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntryModel(
      rank: json['rank'] ?? 0,
      userId: json['userId'] ?? 0,
      username: json['username'] ?? '',
      fullName: json['fullName'],
      avatarUrl: json['avatarUrl'],
      rankTitle: json['rankTitle'] ?? '',
      value: json['value'] ?? 0,
      valueLabel: json['valueLabel'] ?? '',
      isCurrentUser: json['isCurrentUser'] ?? false,
    );
  }

  String get displayName => fullName?.isNotEmpty == true ? fullName! : username;
}

class GamificationResultModel {
  final List<BadgeModel> newBadges;
  final String? newRank;
  final int currentStreak;
  final bool bookJustCompleted;
  final int totalBooksRead;
  final bool hasAnyReward;

  GamificationResultModel({
    required this.newBadges,
    this.newRank,
    required this.currentStreak,
    required this.bookJustCompleted,
    required this.totalBooksRead,
    required this.hasAnyReward,
  });

  factory GamificationResultModel.fromJson(Map<String, dynamic> json) {
    return GamificationResultModel(
      newBadges: (json['newBadges'] as List<dynamic>? ?? [])
          .map((b) => BadgeModel.fromJson(b))
          .toList(),
      newRank: json['newRank'],
      currentStreak: json['currentStreak'] ?? 0,
      bookJustCompleted: json['bookJustCompleted'] ?? false,
      totalBooksRead: json['totalBooksRead'] ?? 0,
      hasAnyReward: json['hasAnyReward'] ?? false,
    );
  }
}
