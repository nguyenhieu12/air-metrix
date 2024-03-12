import 'package:dartz/dartz.dart';
import 'package:envi_metrix/core/errors/failures.dart';
import 'package:envi_metrix/core/errors/exceptions.dart';
import 'package:envi_metrix/features/air_pollution/data/data_sources/weather_remote_data_source.dart';
import 'package:envi_metrix/features/air_pollution/domain/entities/weather_entity.dart';
import 'package:envi_metrix/features/air_pollution/domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;
  WeatherRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, WeatherEntity>> getCurrentWeather(
      double lat, double long) async {
    try {
      final remoteAirPollution =
          await remoteDataSource.getCurrentWeather(lat, long);

      return Right(remoteAirPollution);
    } on ApiException {
      return Left(ApiFailure(errorMessage: 'Cannot call air pollution API'));
    }
  }
}
