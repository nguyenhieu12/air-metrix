class NewsEntity {
  final String? content;
  final String? description;
  final String? publishedAt;
  final String? title;
  final String? url;
  final String? urlToImage;

  NewsEntity(
      {required this.content,
      required this.description,
      required this.publishedAt,
      required this.title,
      required this.url,
      required this.urlToImage});
}
