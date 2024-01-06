import 'package:envi_metrix/features/air_pollution/domain/entities/air_pollution_entity.dart';

class AirPollutionModel extends AirPollutionEntity {
  const AirPollutionModel(
      {required super.co,
      required super.no2,
      required super.o3,
      required super.pm2_5,
      required super.pm10,
      required super.so2});

  factory AirPollutionModel.fromJson(Map<String, dynamic> json) {
    return AirPollutionModel(
        co: json['co'],
        no2: json['no2'],
        o3: json['o3'],
        pm2_5: json['pm2_5'],
        pm10: json['pm10'],
        so2: json['so2']);
  }

  Map<String, dynamic> toJson() {
    return {
      'co': co,
      'no2': no2,
      'o3': o3,
      'pm2_5': pm2_5,
      'pm10': pm10,
      'so2': so2
    };
  }
}
