import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionChecker {
  final StreamController<bool> _connectionController = StreamController<bool>();

  Stream<bool> get connectionStream => _connectionController.stream;

  void checkConnection() async {
    bool isConnected = await Connectivity().checkConnectivity() != ConnectivityResult.none;

    _connectionController.add(isConnected);
  }

  void dispose() {
    _connectionController.close();
  }
}
