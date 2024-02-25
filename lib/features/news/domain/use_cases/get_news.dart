import 'package:dartz/dartz.dart';
import 'package:envi_metrix/core/errors/failures.dart';
import 'package:envi_metrix/features/news/domain/entities/news_entity.dart';
import 'package:envi_metrix/features/news/domain/repositories/news_repository.dart';

class GetNews {
  final NewsRepository newsRepository;

  GetNews({required this.newsRepository});

  Future<Either<Failure, List<NewsEntity>>> getNewsData() async {
    return await newsRepository.getNews();
  }
}
