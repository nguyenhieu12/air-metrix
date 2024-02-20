import 'package:dartz/dartz.dart';
import 'package:envi_metrix/core/errors/failures.dart';
import 'package:envi_metrix/features/air_pollution/domain/entities/air_pollution_entity.dart';
import 'package:envi_metrix/features/air_pollution/domain/repositories/air_pollution_repository.dart';
import 'package:envi_metrix/features/disaster/domain/entities/disaster_entity.dart';
import 'package:envi_metrix/features/disaster/domain/repositories/disaster_repository.dart';

class GetDashboardData {
  final DisasterRepository disasterRepository;
  final AirPollutionRepository airPollutionRepository;

  GetDashboardData(
      {required this.airPollutionRepository, required this.disasterRepository});

  Future<Either<Failure, AirPollutionEntity>> getCurrentAirPollution(
      double lat, double long) async {
    return await airPollutionRepository.getCurrentAirPollution(lat, long);
  }

  Future<Either<Failure, List<DisasterEntity>>> getDisaster() async {
    return await disasterRepository.getCurrentDisaster();
  }
}
