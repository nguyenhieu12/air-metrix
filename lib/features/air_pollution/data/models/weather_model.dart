import 'package:envi_metrix/features/air_pollution/domain/entities/weather_entity.dart';

class WeatherModel extends WeatherEntity {
  const WeatherModel(
      {required super.temp,
      required super.humidity,
      required super.pressure,
      required super.windSpeed});

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
        temp: json['main']['temp'],
        humidity: json['main']['humidity'],
        pressure: json['main']['pressure'],
        windSpeed: json['wind']['speed']);
  }
}
