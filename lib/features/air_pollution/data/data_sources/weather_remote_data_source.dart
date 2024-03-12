import 'package:dio/dio.dart';
import 'package:envi_metrix/core/errors/exceptions.dart';
import 'package:envi_metrix/core/keys/app_keys.dart';
import 'package:envi_metrix/features/air_pollution/data/models/weather_model.dart';
import 'package:envi_metrix/features/air_pollution/domain/entities/weather_entity.dart';

abstract class WeatherRemoteDataSource { 
  Future<WeatherEntity> getCurrentWeather(double lat, double long);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final Dio dio;

  WeatherRemoteDataSourceImpl(this.dio);

  @override
  Future<WeatherEntity> getCurrentWeather(double lat, double long) async {
    final respone = await dio.get(
        'http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=${AppKeys.openWeatherMapKey}');

    if (respone.statusCode == 200) {
      return WeatherModel.fromJson(respone.data);
    } else {
      throw ApiException();
    }
  }

}