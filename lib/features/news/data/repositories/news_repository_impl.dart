import 'package:dartz/dartz.dart';
import 'package:envi_metrix/core/errors/exceptions.dart';
import 'package:envi_metrix/core/errors/failures.dart';
import 'package:envi_metrix/features/news/data/data_sources/news_remote_data_source.dart';
import 'package:envi_metrix/features/news/domain/entities/news_entity.dart';
import 'package:envi_metrix/features/news/domain/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource newsRemoteDataSource;

  NewsRepositoryImpl({required this.newsRemoteDataSource});

  @override
  Future<Either<Failure, List<NewsEntity>>> getNews() async {
    try {
      final remoteNews = await newsRemoteDataSource.getNewsData();

      return Right(remoteNews);
    } on ApiException {
      return Left(ApiFailure(errorMessage: 'Cannot call news API'));
    }
  }
}
