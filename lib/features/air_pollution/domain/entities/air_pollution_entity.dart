import 'package:equatable/equatable.dart';

class AirPollutionEntity extends Equatable {
  final dynamic co;
  final dynamic no2;
  final dynamic o3;
  final dynamic pm2_5;
  final dynamic pm10;
  final dynamic so2;

  const AirPollutionEntity({
    required this.co,
    required this.no2,
    required this.o3,
    required this.pm2_5,
    required this.pm10,
    required this.so2,
  });

  Map<String, dynamic> toMap() {
    return {
      'co': co,
      'no2': no2,
      'o3': o3,
      'pm2_5': pm2_5,
      'pm10': pm10,
      'so2': so2,
    };
  }

  @override
  List<Object> get props {
    return [
      co,
      no2,
      o3,
      pm2_5,
      pm10,
      so2,
    ];
  }
}
