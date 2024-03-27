import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  Map<String, dynamic> cityData = {};

  List<String> cityNames = [];

  Future<void> initCityData() async {
    String data = await rootBundle.loadString('./assets/data/cities500.json');

    List<dynamic> cities = json.decode(data);

    for (int i = 0; i < cities.length; i++) {
      cityNames.add(cities[i]['name']);
      cityData[cities[i]['name']] = {
        'lat': cities[i]['lat'],
        'lon': cities[i]['lon']
      };
    }
  }
}
