/// Thống kê đọc sách của user (trong user detail).
class UserStatsSummary {
  final int totalBooksRead;
  final int totalBooksStarted;
  final int totalPagesRead;
  final int totalMinutesRead;
  final int totalWordsRead;
  final int currentStreak;
  final int longestStreak;
  final String? lastReadDate;
  final String? favoriteGenre;
  final String? rank;
  final String? statsUpdatedAt;

  UserStatsSummary({
    required this.totalBooksRead,
    required this.totalBooksStarted,
    required this.totalPagesRead,
    required this.totalMinutesRead,
    required this.totalWordsRead,
    required this.currentStreak,
    required this.longestStreak,
    this.lastReadDate,
    this.favoriteGenre,
    this.rank,
    this.statsUpdatedAt,
  });

  factory UserStatsSummary.fromJson(Map<String, dynamic> json) {
    return UserStatsSummary(
      totalBooksRead: json['totalBooksRead'] as int? ?? 0,
      totalBooksStarted: json['totalBooksStarted'] as int? ?? 0,
      totalPagesRead: json['totalPagesRead'] as int? ?? 0,
      totalMinutesRead: json['totalMinutesRead'] as int? ?? 0,
      totalWordsRead: json['totalWordsRead'] as int? ?? 0,
      currentStreak: json['currentStreak'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
      lastReadDate: json['lastReadDate'] as String?,
      favoriteGenre: json['favoriteGenre'] as String?,
      rank: json['rank'] as String?,
      statsUpdatedAt: json['statsUpdatedAt'] as String?,
    );
  }
}

/// Model một user trong danh sách admin / detail.
class AdminUserModel {
  final int userId;
  final String username;
  final String email;
  final String? fullName;
  final String? avatarUrl;
  final String role;
  final String? createdAt;
  final String? updatedAt;
  final UserStatsSummary? userStatsSummary;

  AdminUserModel({
    required this.userId,
    required this.username,
    required this.email,
    this.fullName,
    this.avatarUrl,
    required this.role,
    this.createdAt,
    this.updatedAt,
    this.userStatsSummary,
  });

  factory AdminUserModel.fromJson(Map<String, dynamic> json) {
    final raw = json['userStatsSummary'];
    UserStatsSummary? stats;
    if (raw is Map<String, dynamic>) {
      stats = UserStatsSummary.fromJson(raw);
    }
    return AdminUserModel(
      userId: json['userId'] as int,
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      fullName: json['fullName'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      role: json['role'] as String? ?? 'user',
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      userStatsSummary: stats,
    );
  }
}

/// Response phân trang danh sách user.
class PagedUsersResponse {
  final List<AdminUserModel> items;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  PagedUsersResponse({
    required this.items,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PagedUsersResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawItems = json['items'] ?? [];
    return PagedUsersResponse(
      items: rawItems
          .map((e) => AdminUserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: json['totalCount'] as int? ?? 0,
      pageNumber: json['pageNumber'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 20,
      totalPages: json['totalPages'] as int? ?? 0,
      hasNextPage: json['hasNextPage'] as bool? ?? false,
      hasPreviousPage: json['hasPreviousPage'] as bool? ?? false,
    );
  }
}
