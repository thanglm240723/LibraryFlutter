class ChapterContent {
  final int contentId;
  final int chapterNumber;
  final String? chapterTitle;
  final String content;
  final int? wordCount;

  ChapterContent({
    required this.contentId,
    required this.chapterNumber,
    this.chapterTitle,
    required this.content,
    this.wordCount,
  });

  factory ChapterContent.fromJson(Map<String, dynamic> json) => ChapterContent(
    contentId: json['contentId'],
    chapterNumber: json['chapterNumber'],
    chapterTitle: json['chapterTitle'],
    content: json['content'],
    wordCount: json['wordCount'],
  );
}
