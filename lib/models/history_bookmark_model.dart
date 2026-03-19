class ReadingHistory {
  final int bookId;
  final String title;
  final String? coverImage;
  final DateTime readAt;

  ReadingHistory({required this.bookId, required this.title, this.coverImage, required this.readAt});

  factory ReadingHistory.fromJson(Map<String, dynamic> json) {
    return ReadingHistory(
      bookId: json['bookId'],
      title: json['title'],
      coverImage: json['coverImage'],
      readAt: DateTime.parse(json['readAt']),
    );
  }
}

class Bookmark {
  final int id;
  final int bookId;
  final String title;
  final String? coverImage;
  final int? pageNumber;
  final DateTime createdAt;

  Bookmark({required this.id, required this.bookId, required this.title, this.coverImage, this.pageNumber, required this.createdAt});

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      id: json['id'],
      bookId: json['bookId'],
      title: json['title'],
      coverImage: json['coverImage'],
      pageNumber: json['pageNumber'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}