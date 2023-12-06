import 'package:dartz/dartz.dart';
import 'package:envi_metrix/core/errors/failures.dart';
import 'package:envi_metrix/features/climate/domain/entities/air_pollution_entity.dart';
import 'package:envi_metrix/features/climate/domain/repositories/air_pollution_repository.dart';

class GetCurrentAirPollution {
  final AirPollutionRepository airPollutionRepository;

  GetCurrentAirPollution({required this.airPollutionRepository});

  Future<Either<Failure, AirPollutionEntity>> call(double lat, double long) async {
    return await airPollutionRepository.getCurrentAirPollution(lat, long);
  }
}