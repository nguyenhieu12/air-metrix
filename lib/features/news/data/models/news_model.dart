import 'package:envi_metrix/features/news/domain/entities/news_entity.dart';

class NewsModel extends NewsEntity {
  NewsModel(
      {required super.content,
      required super.description,
      required super.publishedAt,
      required super.title,
      required super.url,
      required super.urlToImage});

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
        content: json['content'] ?? '',
        description: json['description'] ?? '',
        publishedAt: json['publishedAt'] ?? '',
        title: json['title'] ?? '',
        url: json['url'] ?? '',
        urlToImage: json['urlToImage'] ?? '');
  }
}
