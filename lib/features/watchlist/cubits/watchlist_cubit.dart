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
      required String path,
      required double lat,
      required double long}) {
    emit(WatchlistLoading());

    watchlistItems.add(WatchlistItem(
      locationName: name,
      airQuality: quality,
      backgroundColor: color,
      imagePath: path,
      lat: lat,
      long: long,
    ));

    emit(WatchlistSuccess());
  }

  void removeItem({required double lat, required double long}) {
    for (int i = 0; i < watchlistItems.length; i++) {
      if (watchlistItems[i].lat == lat && watchlistItems[i].long == long) {
        watchlistItems.removeAt(i);
      }
    }
  }
}
