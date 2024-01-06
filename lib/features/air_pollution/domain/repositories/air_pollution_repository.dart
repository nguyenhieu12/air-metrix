import 'package:dartz/dartz.dart';
import 'package:envi_metrix/core/errors/failures.dart';
import 'package:envi_metrix/features/air_pollution/domain/entities/air_pollution_entity.dart';

abstract class AirPollutionRepository {
  Future<Either<Failure, AirPollutionEntity>> getCurrentAirPollution(
      double lat, double long);

  Future<Either<Failure, List<AirPollutionEntity>>> getAirPollutionForecast(
      double lat, double long);

  Future<Either<Failure, List<AirPollutionEntity>>> getAirPollutionHistory(
      double lat, double long, int unixStartDate, int unixEndDate);
}
