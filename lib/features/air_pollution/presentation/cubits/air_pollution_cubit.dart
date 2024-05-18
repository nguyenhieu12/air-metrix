import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:envi_metrix/core/errors/exceptions.dart';
import 'package:envi_metrix/core/models/address_model.dart';
import 'package:envi_metrix/features/air_pollution/domain/entities/air_pollution_entity.dart';
import 'package:envi_metrix/features/air_pollution/domain/entities/weather_entity.dart';
import 'package:envi_metrix/features/air_pollution/domain/use_cases/get_current_air_pollution.dart';
import 'package:envi_metrix/features/air_pollution/domain/use_cases/get_current_weather.dart';
import 'package:envi_metrix/services/location/default_location.dart';
import 'package:envi_metrix/services/location/user_location.dart';
import 'package:envi_metrix/utils/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../../core/errors/failures.dart';

part 'air_pollution_state.dart';

class AirPollutionCubit extends Cubit<AirPollutionState> {
  final GetAirPollutionInformation getCurrentAirPollution;
  final GetCurrentWeather getCurrentWeather;

  int airQualityIndex = 0;
  List<int> list6HoursForecastAQI = [];
  List<int> list12HoursForecastAQI = [];
  List<int> list3DaysForecastAQI = [];

  double currentLat = DefaultLocation.lat;
  double currentLong = DefaultLocation.long;
  UserLocation userLocation = UserLocation();

  String locationName = '';

  late AirPollutionEntity airEntity;
  late Address address;
  late WeatherEntity weatherEntity;

  AirPollutionCubit(
      {required this.getCurrentAirPollution, required this.getCurrentWeather})
      : super(AirPollutionLoading());

  Future<void> fetchAirPollutionData(
      double lat, double long, bool needLocation) async {
    emit(AirPollutionLoading());

    final connect = await Connectivity().checkConnectivity();

    if (connect == ConnectivityResult.none) {
      emit(const AirPollutionFailed(errorMessage: 'Lost Internet connection'));
      return;
    }

    if (needLocation) {
      if (await userLocation.isAccepted()) {
        Position currentPosition = await Utils.getUserLocation();

        currentLat = currentPosition.latitude;
        currentLong = currentPosition.longitude;
      }
    } else {
      currentLat = lat;
      currentLong = long;
    }

    final Either<Failure, AirPollutionEntity> airPollutionData =
        await getCurrentAirPollution.getCurrentAirPollution(currentLat, currentLong);

    final Either<Failure, WeatherEntity> weatherData =
        await getCurrentWeather.getCurrentWeather(currentLat, currentLong);

    airPollutionData.fold(
      (Failure failure) {
        emit(
            const AirPollutionFailed(errorMessage: 'Lost Internet connection'));
        throw ApiException();
      },
      (AirPollutionEntity airPollutionEntity) async {
        weatherData.fold((Failure failure) {
          emit(const AirPollutionFailed(
              errorMessage: 'Lost Internet connection'));
          throw ApiException();
        }, (WeatherEntity weather) async {
          List<Placemark> placemarks =
              await placemarkFromCoordinates(currentLat, currentLong);

          final first = placemarks.first;

          airEntity = airPollutionEntity;
          weatherEntity = weather;

          address = Address(
              country: first.country ?? '',
              pronvice: first.administrativeArea ?? '',
              district: first.subAdministrativeArea ?? '',
              street: first.street ?? '');

          // setNewLatLong(lat, long);

          emit(AirPollutionSuccess());
        });
      },
    );
  }

  void handleReloadCurrentAirPollution(double lat, double long) {
    fetchAirPollutionData(lat, long, false);
  }

  void setNewLatLong(double lat, double long) {
    currentLat = lat;
    currentLat = long;
  }

  String getQualityImagePath({required int aqi}) {
    switch (aqi) {
      case 1:
        return './assets/images/good_aqi.png';
      case 2:
        return './assets/images/moderate_aqi.png';
      case 3:
        return './assets/images/unhealthy_aqi.png';
      case 4:
        return './assets/images/very_unhealthy_aqi.png';
      case 5:
        return './assets/images/hazardous_aqi.png';

      default:
        return './assets/images/good_aqi.png';
    }
  }
}
