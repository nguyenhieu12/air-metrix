import 'package:envi_metrix/features/climate/domain/entities/sub_entities.dart';
import 'package:equatable/equatable.dart';

class WeatherEntity extends Equatable {
  final double temperature;
  final double humidity;
  final double pressure;
  final WindEntity wind;

  const WeatherEntity({
    required this.temperature,
    required this.humidity,
    required this.pressure,
    required this.wind,
  });

  @override
  List<Object> get props => [temperature, humidity, pressure, wind];
}
