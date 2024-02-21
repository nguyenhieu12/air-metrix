import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  List<Map<String, dynamic>> cityData = [];

  Future<void> initCityData() async {
    String data = await rootBundle.loadString('./assets/data/cities500.json');

    List<dynamic> cities = json.decode(data);

    for (int i = 0; i < cities.length; i++) {
      cityData.add({
        cities[i]['name']: {'lat': cities[i]['lat'], 'long': cities[i]['lon']}
      });
    }
  }
}
