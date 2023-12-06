import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'connection_cubit.dart';

class ConnectionObserver extends StatefulWidget {
  final Widget child;

  const ConnectionObserver({Key? key, required this.child}) : super(key: key);

  @override
  State<ConnectionObserver> createState() => _ConnectionObserverState();
}

class _ConnectionObserverState extends State<ConnectionObserver> {
  late ConnectionCubit connectionCubit;

  @override
  void initState() {
    super.initState();
    connectionCubit = BlocProvider.of<ConnectionCubit>(context);
    connectionCubit.stream.listen((connectionStatus) {
      if (connectionStatus == ConnectionStatus.disconnected) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lost connection. Please check your internet connection.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
