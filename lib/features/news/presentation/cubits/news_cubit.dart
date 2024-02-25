import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:envi_metrix/core/errors/exceptions.dart';
import 'package:envi_metrix/core/errors/failures.dart';
import 'package:envi_metrix/features/news/domain/use_cases/get_news.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:envi_metrix/features/news/domain/entities/news_entity.dart';
import 'package:equatable/equatable.dart';

part 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  final GetNews getNews;

  NewsCubit({required this.getNews}) : super(NewsLoading());

  Future<void> getNewsData() async {
    emit(NewsLoading());

    final connect = await Connectivity().checkConnectivity();

    if (connect == ConnectivityResult.none) {
      emit(const NewsFailed(errorMessage: 'Lost Internet connection'));
      return;
    }

    final Either<Failure, List<NewsEntity>> newsData = await getNews.getNewsData();

    newsData.fold(
      (Failure failure) {
        emit(const NewsFailed(errorMessage: 'Lost Internet connection'));
        throw ApiException();
      },
      (List<NewsEntity> listNewsEntity) async {
        emit(NewsSuccess(listNewsEntity: listNewsEntity));
      },
    );
  }
}
