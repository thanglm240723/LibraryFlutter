class BookModel {
  final int bookId;
  final String title;
  final String author;
  final String? coverImageUrl;
  final String? genre;
  final double? rating;

  BookModel({
    required this.bookId,
    required this.title,
    required this.author,
    this.coverImageUrl,
    this.genre,
    this.rating,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      bookId: json['bookId'],
      title: json['title'],
      author: json['author'],
      coverImageUrl: json['coverImageUrl'],
      genre: json['genre'],
      rating: json['rating']?.toDouble(),
    );
  }
}
