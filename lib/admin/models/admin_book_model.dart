class AdminBookModel {
  final int bookId;
  final String title;
  final String author;
  final String? description;
  final String? coverImageUrl;
  final String? genre;
  final int? pageCount;
  final int? publishedYear;
  final double? rating;
  final String? language;
  final String? fileUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AdminBookModel({
    required this.bookId,
    required this.title,
    required this.author,
    this.description,
    this.coverImageUrl,
    this.genre,
    this.pageCount,
    this.publishedYear,
    this.rating,
    this.language,
    this.fileUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory AdminBookModel.fromJson(Map<String, dynamic> json) {
    return AdminBookModel(
      bookId: json['bookId'] ?? 0,
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      description: json['description'],
      coverImageUrl: json['coverImageUrl'],
      genre: json['genre'],
      pageCount: json['pageCount'],
      publishedYear: json['publishedYear'],
      rating: json['rating']?.toDouble(),
      language: json['language'],
      fileUrl: json['fileUrl'],
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
      'bookId': bookId,
      'title': title,
      'author': author,
      'description': description,
      'coverImageUrl': coverImageUrl,
      'genre': genre,
      'pageCount': pageCount,
      'publishedYear': publishedYear,
      'rating': rating,
      'language': language,
      'fileUrl': fileUrl,
    };
  }

  AdminBookModel copyWith({
    int? bookId,
    String? title,
    String? author,
    String? description,
    String? coverImageUrl,
    String? genre,
    int? pageCount,
    int? publishedYear,
    double? rating,
    String? language,
    String? fileUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AdminBookModel(
      bookId: bookId ?? this.bookId,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      genre: genre ?? this.genre,
      pageCount: pageCount ?? this.pageCount,
      publishedYear: publishedYear ?? this.publishedYear,
      rating: rating ?? this.rating,
      language: language ?? this.language,
      fileUrl: fileUrl ?? this.fileUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
