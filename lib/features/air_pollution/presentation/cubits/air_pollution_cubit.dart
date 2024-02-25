import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:envi_metrix/core/errors/exceptions.dart';
import 'package:envi_metrix/core/models/address_model.dart';
import 'package:envi_metrix/features/air_pollution/domain/entities/air_pollution_entity.dart';
import 'package:envi_metrix/features/air_pollution/domain/use_cases/get_current_air_pollution.dart';
import 'package:envi_metrix/services/location/default_location.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';

import '../../../../../core/errors/failures.dart';

part 'air_pollution_state.dart';

class AirPollutionCubit extends Cubit<AirPollutionState> {
  final GetAirPollutionInformation getCurrentAirPollution;

  int airQualityIndex = 0;
  List<int> listForecastAQI = [];

  double currentLat = DefaultLocation.lat;
  double currentLong = DefaultLocation.long;

  AirPollutionCubit({required this.getCurrentAirPollution})
      : super(AirPollutionLoading());

  Future<void> fetchAirPollutionData(double lat, double long) async {
    emit(AirPollutionLoading());

    final connect = await Connectivity().checkConnectivity();

    if (connect == ConnectivityResult.none) {
      emit(const AirPollutionFailed(errorMessage: 'Lost Internet connection'));
      return;
    }

    final Either<Failure, AirPollutionEntity> airPollutionData =
        await getCurrentAirPollution.getCurrentAirPollution(lat, long);

    airPollutionData.fold(
      (Failure failure) {
        emit(
            const AirPollutionFailed(errorMessage: 'Lost Internet connection'));
        throw ApiException();
      },
      (AirPollutionEntity airPollutionEntity) async {
        List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

        final first = placemarks.first;

        emit(AirPollutionSuccess(
            airPollutionEntity: airPollutionEntity,
            address: Address(
                country: first.country ?? '',
                pronvice: first.administrativeArea ?? '',
                district: first.subAdministrativeArea ?? '',
                street: first.street ?? '')));
      },
    );
  }

  Future<void> fetchAirPollutionForecase(double lat, double long) async {
    emit(AirPollutionLoading());
    final Either<Failure, List<AirPollutionEntity>> airPollutionForecast =
        await getCurrentAirPollution.getAirPollutionForecast(lat, long);

    airPollutionForecast.fold(
      (Failure failure) {
        throw ApiException();
      },
      (List<AirPollutionEntity> listAirPollutionEntity) {
        // emit(AirPollutionLoaded(airPollutionEntity: listAirPollutionEntity));
      },
    );
  }

  Future<void> fetchAirPollutionHistory(
      double lat, double long, int unixStartDate, int unixEndDate) async {
    emit(AirPollutionLoading());
    final Either<Failure, List<AirPollutionEntity>> airPollutionHistory =
        await getCurrentAirPollution.getAirPollutionHistory(
            lat, long, unixStartDate, unixEndDate);

    airPollutionHistory.fold(
      (Failure failure) {
        throw ApiException();
      },
      (List<AirPollutionEntity> listAirPollutionEntity) {
        // emit(AirPollutionLoaded(airPollutionEntity: listAirPollutionEntity));
      },
    );
  }

  void handleReloadCurrentAirPollution(double lat, double long) {
    fetchAirPollutionData(lat, long);
  }

  void setNewLatLong(double lat, double long) {
    currentLat = lat;
    currentLat = long;
  }
}
