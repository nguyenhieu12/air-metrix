import 'package:dartz/dartz.dart';
import 'package:envi_metrix/core/errors/failures.dart';
import 'package:envi_metrix/features/air_pollution/domain/entities/air_pollution_entity.dart';
import 'package:envi_metrix/features/air_pollution/domain/repositories/air_pollution_repository.dart';

class GetAirPollutionInformation {
  final AirPollutionRepository airPollutionRepository;

  GetAirPollutionInformation({required this.airPollutionRepository});

  Future<Either<Failure, AirPollutionEntity>> getCurrentAirPollution(
      double lat, double long) async {
    return await airPollutionRepository.getCurrentAirPollution(lat, long);
  }

  Future<Either<Failure, List<AirPollutionEntity>>> getAirPollutionForecast(
      double lat, double long) async {
    return await airPollutionRepository.getAirPollutionForecast(lat, long);
  }

  Future<Either<Failure, List<AirPollutionEntity>>> getAirPollutionHistory(
      double lat, double long, int unixStartDate, int unixEndDate) async {
    return await airPollutionRepository.getAirPollutionHistory(
        lat, long, unixStartDate, unixEndDate);
  }
}
