import 'package:equatable/equatable.dart';

class AirPollutionEntity extends Equatable {
  final dynamic co;
  final dynamic nh3;
  final dynamic no;
  final dynamic no2;
  final dynamic o3;
  final dynamic pm2_5;
  final dynamic pm10;
  final dynamic so2;

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

  Map<String, dynamic> toMap() {
    return {
      'co': co,
      'nh3': nh3,
      'no': no,
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
