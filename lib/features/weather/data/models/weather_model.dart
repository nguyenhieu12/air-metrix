import 'package:envi_metrix/features/weather/domain/entities/weather_entity.dart';

class WeatherModel extends WeatherEntity {
  const WeatherModel(
      {required super.temperature,
      required super.humidity,
      required super.pressure,
      required super.wind});

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: json['temperature'],
      humidity: json['humidity'],
      pressure: json['pressure'],
      wind: json['wind']
    );
  }
}
