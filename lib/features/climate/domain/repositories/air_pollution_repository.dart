import 'package:dartz/dartz.dart';
import 'package:envi_metrix/core/errors/failures.dart';
import 'package:envi_metrix/features/climate/domain/entities/air_pollution_entity.dart';

abstract class AirPollutionRepository {
  Future<Either<Failure, AirPollutionEntity>> getCurrentAirPollution(double lat, double long);
}