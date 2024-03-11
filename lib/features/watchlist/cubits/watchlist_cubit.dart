import 'package:envi_metrix/features/watchlist/widgets/watchlist_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_state.dart';

class WatchlistCubit extends Cubit<WatchlistState> {
  WatchlistCubit() : super(WatchlistInitial());

  List<WatchlistItem> watchlistItems = [];

  void addNewItem(
      {required String name,
      required String quality,
      required Color color,
      required String path}) {
    emit(WatchlistLoading());

    watchlistItems.add(WatchlistItem(
      locationName: name,
      airQuality: quality,
      backgroundColor: color,
      imagePath: path,
    ));

    emit(WatchlistSuccess());
  }

  void removeItem({required int index}) {}

  void initWatchlist() {
    emit(WatchlistSuccess());
  }
}
