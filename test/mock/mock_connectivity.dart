import 'package:connectivity_plus/connectivity_plus.dart';

enum ConnectivityCase { CASE_ERROR, CASE_SUCCESS }

class MockConnectivity implements Connectivity {
  var connectivityCase = ConnectivityCase.CASE_SUCCESS;

  late Stream<ConnectivityResult> _onConnectivityChanged;

  @override
  Future<ConnectivityResult> checkConnectivity() {
    if (connectivityCase == ConnectivityCase.CASE_SUCCESS) {
      return Future.value(ConnectivityResult.wifi);
    } else {
      throw Error();
    }
  }

  @override
  Stream<ConnectivityResult> get onConnectivityChanged {
    return _onConnectivityChanged;
  }
}
