import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_state.dart';

class WatchlistCubit extends Cubit<WatchlistState> {
  WatchlistCubit() : super(WatchlistInitial());
}
