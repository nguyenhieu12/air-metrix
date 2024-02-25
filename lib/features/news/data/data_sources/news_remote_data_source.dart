import 'package:dio/dio.dart';
import 'package:envi_metrix/core/errors/exceptions.dart';
import 'package:envi_metrix/core/keys/app_keys.dart';
import 'package:envi_metrix/features/news/data/models/news_model.dart';

abstract class NewsRemoteDataSource {
  Future<List<NewsModel>> getNewsData();
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final Dio dio;

  NewsRemoteDataSourceImpl(this.dio);

  @override
  Future<List<NewsModel>> getNewsData() async {
    final response = await dio.get(
        'https://newsapi.org/v2/everything?q=%22air%20quality%22&searchIn=title,description&apiKey=${AppKeys.newsKey}');

    if (response.statusCode == 200) {
      List<dynamic> listResult = response.data['articles'];

      return listResult
          .map((currentNew) => NewsModel.fromJson(currentNew))
          .toList();
    } else {
      throw ApiException();
    }
  }
}
