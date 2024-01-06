import 'package:flutter_bloc/flutter_bloc.dart';

class TabChangeCubit extends Cubit<int> {
  TabChangeCubit() : super(0);

  void changeTab(int index) {
    emit(index);
  }
}