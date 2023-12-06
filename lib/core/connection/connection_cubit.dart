import 'package:flutter_bloc/flutter_bloc.dart';

enum ConnectionStatus { connected, disconnected }

class ConnectionCubit extends Cubit<ConnectionStatus> {
  ConnectionCubit() : super(ConnectionStatus.connected);

  void setConnectionStatus(bool isConnected) {
    emit(isConnected ? ConnectionStatus.connected : ConnectionStatus.disconnected);
  }
}
