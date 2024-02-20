import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:envi_metrix/core/errors/exceptions.dart';
import 'package:envi_metrix/core/errors/failures.dart';
import 'package:envi_metrix/core/models/address_model.dart';
import 'package:envi_metrix/features/air_pollution/domain/entities/air_pollution_entity.dart';
import 'package:envi_metrix/features/air_pollution/presentation/cubits/air_pollution_cubit.dart';
import 'package:envi_metrix/features/disaster/domain/entities/disaster_entity.dart';
import 'package:envi_metrix/features/disaster/presentation/cubits/disaster_cubit.dart';
import 'package:envi_metrix/injector/injector.dart';
import 'package:envi_metrix/services/location/default_location.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardInitial()) {
    airPollutionCubit = Injector.instance();
    disasterCubit = Injector.instance();
  }

  late AirPollutionCubit airPollutionCubit;
  late DisasterCubit disasterCubit;

  String mostFrequentDisaster = '';

  // final GetDashboardData getDashboardData;

  Future<void> getData() async {
    emit(DashboardLoading());

    final connect = await Connectivity().checkConnectivity();

    if (connect == ConnectivityResult.none) {
      emit(const DashboardFailed(errorMessage: 'Lost Internet connection'));
      return;
    }

    final Either<Failure, AirPollutionEntity> airPollutionData =
        await airPollutionCubit.getCurrentAirPollution
            .getCurrentAirPollution(DefaultLocation.lat, DefaultLocation.long);

    final Either<Failure, List<DisasterEntity>> disasterData =
        await disasterCubit.getCurrentDisaster.getDisaster();

    airPollutionData.fold(
      (Failure failure) {
        emit(const DashboardFailed(errorMessage: 'Lost Internet connection'));
        throw ApiException();
      },
      (AirPollutionEntity airPollutionEntity) async {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            DefaultLocation.lat, DefaultLocation.long);

        final first = placemarks.first;

        disasterData.fold((Failure failure) {
          emit(const DashboardFailed(errorMessage: 'Lost Internet connection'));
          throw ApiException();
        }, (List<DisasterEntity> listDisasterEntity) {
          emit(DashboardSuccess(
              airPollutionEntity: airPollutionEntity,
              listDisasterEntity: listDisasterEntity,
              address: Address(
                  country: first.country ?? '',
                  pronvice: first.administrativeArea ?? '',
                  district: first.subAdministrativeArea ?? '',
                  street: first.street ?? '')));
        });
      },
    );
  }
}
