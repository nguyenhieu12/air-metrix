import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:envi_metrix/core/errors/exceptions.dart';
import 'package:envi_metrix/core/errors/failures.dart';
import 'package:envi_metrix/core/models/address_model.dart';
import 'package:envi_metrix/features/air_pollution/domain/entities/air_pollution_entity.dart';
import 'package:envi_metrix/features/air_pollution/domain/use_cases/get_current_air_pollution.dart';
import 'package:envi_metrix/features/app/cubits/app_cubit.dart';
import 'package:envi_metrix/injector/injector.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';

part 'air_compare_state.dart';

class AirCompareCubit extends Cubit<AirCompareState> {
  AirCompareCubit({required this.getCurrentAirPollution})
      : super(AirCompareInitial()) {
    _appCubit = Injector.instance();
  }

  int airQualityIndex = 0;

  late AirPollutionEntity airEntity;
  late Address address;
  late AppCubit _appCubit;

  final GetAirPollutionInformation getCurrentAirPollution;

  Future<void> fetchAirPollutionData(double lat, double long) async {
    emit(AirCompareLoading());

    final connect = await Connectivity().checkConnectivity();

    if (connect == ConnectivityResult.none) {
      emit(AirCompareFailed());
      return;
    }

    final Either<Failure, AirPollutionEntity> airPollutionData =
        await getCurrentAirPollution.getCompareAirPollution(lat, long);

    airPollutionData.fold(
      (Failure failure) {
        emit(AirCompareFailed());
        throw ApiException();
      },
      (AirPollutionEntity airPollutionEntity) async {
        List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

        final first = placemarks.first;

        airEntity = airPollutionEntity;
        address = Address(
            country: first.country ?? '',
            pronvice: first.administrativeArea ?? '',
            district: first.subAdministrativeArea ?? '',
            street: first.street ?? '');

        emit(AirCompareSuccess());
      },
    );
  }

  void searchByName(String selectedText) {
    Map<String, dynamic> coordinatesData = _appCubit.cityData[selectedText];

    fetchAirPollutionData(double.parse(coordinatesData['lat']),
        double.parse(coordinatesData['lon']));
  }
}
