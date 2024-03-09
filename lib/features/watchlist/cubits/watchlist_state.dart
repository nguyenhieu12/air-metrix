part of 'watchlist_cubit.dart';

sealed class WatchlistState extends Equatable {
  const WatchlistState();

  @override
  List<Object> get props => [];
}

final class WatchlistInitial extends WatchlistState {}
