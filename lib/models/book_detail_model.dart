class BookDetail {
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
  final int totalChapters;

  BookDetail({
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
    required this.totalChapters,
  });

  factory BookDetail.fromJson(Map<String, dynamic> json) {
    return BookDetail(
      bookId: json['bookId'],
      title: json['title'],
      author: json['author'],
      description: json['description'],
      coverImageUrl: json['coverImageUrl'],
      genre: json['genre'],
      pageCount: json['pageCount'],
      publishedYear: json['publishedYear'],
      rating: json['rating']?.toDouble(),
      language: json['language'],
      fileUrl: json['fileUrl'],
      totalChapters: json['totalChapters'] ?? 0,
    );
  }
}
