class AdminBookContentModel {
  final int contentId;
  final int bookId;
  final int chapterNumber;
  final String chapterTitle;
  final String content;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AdminBookContentModel({
    required this.contentId,
    required this.bookId,
    required this.chapterNumber,
    required this.chapterTitle,
    required this.content,
    this.createdAt,
    this.updatedAt,
  });

  factory AdminBookContentModel.fromJson(Map<String, dynamic> json) {
    return AdminBookContentModel(
      contentId: json['contentId'] ?? 0,
      bookId: json['bookId'] ?? 0,
      chapterNumber: json['chapterNumber'] ?? 0,
      chapterTitle: json['chapterTitle'] ?? '',
      content: json['content'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contentId': contentId,
      'bookId': bookId,
      'chapterNumber': chapterNumber,
      'chapterTitle': chapterTitle,
      'content': content,
    };
  }

  AdminBookContentModel copyWith({
    int? contentId,
    int? bookId,
    int? chapterNumber,
    String? chapterTitle,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AdminBookContentModel(
      contentId: contentId ?? this.contentId,
      bookId: bookId ?? this.bookId,
      chapterNumber: chapterNumber ?? this.chapterNumber,
      chapterTitle: chapterTitle ?? this.chapterTitle,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
