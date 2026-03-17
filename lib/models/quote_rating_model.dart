class QuoteModel {
  final int quoteId;
  final int bookId;
  final String? bookTitle;
  final String? bookCover;
  final int? contentId;
  final String? chapterTitle;
  final String quoteText;
  final String? personalNote;
  final bool isPublic;
  final DateTime createdAt;

  QuoteModel({
    required this.quoteId,
    required this.bookId,
    this.bookTitle,
    this.bookCover,
    this.contentId,
    this.chapterTitle,
    required this.quoteText,
    this.personalNote,
    required this.isPublic,
    required this.createdAt,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) => QuoteModel(
    quoteId: json['quoteId'] ?? 0,
    bookId: json['bookId'] ?? 0,
    bookTitle: json['bookTitle'],
    bookCover: json['bookCover'],
    contentId: json['contentId'],
    chapterTitle: json['chapterTitle'],
    quoteText: json['quoteText'] ?? '',
    personalNote: json['personalNote'],
    isPublic: json['isPublic'] ?? false,
    createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
  );
}

class BookRatingSummary {
  final int bookId;
  final double averageRating;
  final int totalRatings;
  final int? myRating;
  final String? myReview;
  final bool canRate;
  final List<BookRatingItem> recentReviews;

  BookRatingSummary({
    required this.bookId,
    required this.averageRating,
    required this.totalRatings,
    this.myRating,
    this.myReview,
    required this.canRate,
    required this.recentReviews,
  });

  bool get hasRated => myRating != null;

  factory BookRatingSummary.fromJson(Map<String, dynamic> json) =>
      BookRatingSummary(
        bookId: json['bookId'] ?? 0,
        averageRating: (json['averageRating'] ?? 0).toDouble(),
        totalRatings: json['totalRatings'] ?? 0,
        myRating: json['myRating'],
        myReview: json['myReview'],
        canRate: json['canRate'] ?? false,
        recentReviews: (json['recentReviews'] as List<dynamic>? ?? [])
            .map((r) => BookRatingItem.fromJson(r))
            .toList(),
      );
}

class BookRatingItem {
  final int ratingId;
  final int userId;
  final String? username;
  final int stars;
  final String? review;
  final bool isVerifiedReader;
  final DateTime createdAt;

  BookRatingItem({
    required this.ratingId,
    required this.userId,
    this.username,
    required this.stars,
    this.review,
    required this.isVerifiedReader,
    required this.createdAt,
  });

  factory BookRatingItem.fromJson(Map<String, dynamic> json) => BookRatingItem(
    ratingId: json['ratingId'] ?? 0,
    userId: json['userId'] ?? 0,
    username: json['username'],
    stars: json['stars'] ?? 0,
    review: json['review'],
    isVerifiedReader: json['isVerifiedReader'] ?? false,
    createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
  );
}
