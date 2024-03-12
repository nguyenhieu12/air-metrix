import 'package:dartz/dartz.dart';
import 'package:envi_metrix/core/errors/failures.dart';
import 'package:envi_metrix/features/air_pollution/domain/entities/weather_entity.dart';
import 'package:envi_metrix/features/air_pollution/domain/repositories/weather_repository.dart';

class GetCurrentWeather {
  final WeatherRepository weatherRepository;

  GetCurrentWeather({required this.weatherRepository});

  Future<Either<Failure, WeatherEntity>> getCurrentWeather(
      double lat, double long) async {
    return await weatherRepository.getCurrentWeather(lat, long);
  }
}