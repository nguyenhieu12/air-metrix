part of 'news_cubit.dart';

sealed class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object> get props => [];
}

final class NewsInitial extends NewsState {}

final class NewsLoading extends NewsState {}

final class NewsSuccess extends NewsState {
  final List<NewsEntity> listNewsEntity;

  const NewsSuccess({required this.listNewsEntity});
}

final class NewsFailed extends NewsState {
  final String errorMessage;

  const NewsFailed({required this.errorMessage});
}
