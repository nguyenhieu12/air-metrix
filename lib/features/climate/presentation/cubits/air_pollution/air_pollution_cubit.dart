import 'package:dartz/dartz.dart';
import 'package:envi_metrix/core/errors/exceptions.dart';
import 'package:envi_metrix/features/climate/domain/entities/air_pollution_entity.dart';
import 'package:envi_metrix/features/climate/domain/use_cases/get_current_air_pollution.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';

part 'air_pollution_state.dart';

class AirPollutionCubit extends Cubit<AirPollutionState> {
  final GetCurrentAirPollution getCurrentAirPollution;

  AirPollutionCubit({required this.getCurrentAirPollution})
      : super(AirPollutionInitial());

  Future<void> fetchAirPollutionData(double lat, double long) async {
    emit(AirPollutionLoading());
    final Either<Failure, AirPollutionEntity> airPollutionData =
        await getCurrentAirPollution.call(lat, long);

    airPollutionData.fold(
      (Failure failure) {
        throw ApiException();
      },
      (AirPollutionEntity airPollutionEntity) {
        emit(AirPollutionLoaded(airPollutionEntity: airPollutionEntity));
      },
    );
  }
}
