import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  final Connectivity _connectivity = Connectivity();

  InternetCubit() : super(InternetConnected()) {
    _initInternetState();
  }

  void _initInternetState() async {
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        emit(InternetDisconnected());
      } else {
        emit(InternetConnected());
      }
    });
  }
}
