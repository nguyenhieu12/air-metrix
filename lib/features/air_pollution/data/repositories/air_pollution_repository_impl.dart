// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:envi_metrix/core/errors/exceptions.dart';

import 'package:envi_metrix/core/errors/failures.dart';
import 'package:envi_metrix/features/air_pollution/data/data_sources/air_pollution_remote_data_source.dart';
import 'package:envi_metrix/features/air_pollution/domain/entities/air_pollution_entity.dart';

import '../../domain/repositories/air_pollution_repository.dart';

class AirPollutionRepositoryImpl implements AirPollutionRepository {
  final AirPollutionRemoteDataSource remoteDataSource;
  AirPollutionRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, AirPollutionEntity>> getCurrentAirPollution(double lat, double long) async {
    try {
      final remoteAirPollution = await remoteDataSource.getCurrentAirPollution(lat, long);

      return Right(remoteAirPollution);
    } on ApiException {
      return Left(ApiFailure(errorMessage: 'Cannot call air pollution API'));
    }
  }
  
  @override
  Future<Either<Failure, List<AirPollutionEntity>>> getAirPollutionForecast(double lat, double long) async {
    try {
      final remoteAirPollutionForecast = await remoteDataSource.getAirPollutionForecast(lat, long);

      return Right(remoteAirPollutionForecast);
    } on ApiException {
      return Left(ApiFailure(errorMessage: 'Cannot get air pollution forecast'));
    }
  }
  
  @override
  Future<Either<Failure, List<AirPollutionEntity>>> getAirPollutionHistory(double lat, double long, int unixStartDate, int unixEndDate) async {
   try {
      final remoteAirPollutionForecast = await remoteDataSource.getAirPollutionHistory(lat, long, unixStartDate, unixEndDate);

      return Right(remoteAirPollutionForecast);
    } on ApiException {
      return Left(ApiFailure(errorMessage: 'Cannot get air pollution history'));
    }
  }
}
