import 'package:equatable/equatable.dart';

class AirPollutionEntity extends Equatable {
  final double co;
  final double nh3;
  final double no;
  final double no2;
  final double o3;
  final double pm2_5;
  final double pm10;
  final double so2;

  const AirPollutionEntity({
    required this.co,
    required this.nh3,
    required this.no,
    required this.no2,
    required this.o3,
    required this.pm2_5,
    required this.pm10,
    required this.so2,
  });

  @override
  List<Object> get props {
    return [
      co,
      nh3,
      no,
      no2,
      o3,
      pm2_5,
      pm10,
      so2,
    ];
  }
}
