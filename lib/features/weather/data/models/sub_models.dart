import 'package:envi_metrix/features/weather/domain/entities/sub_entities.dart';

class WindModel extends WindEntity {
  WindModel({required super.deg, required super.guts, required super.speed});

  factory WindModel.fromJson(Map<String, dynamic> json) {
    return WindModel(
      deg: json['deg'],
      guts: json['guts'],
      speed: json['speed']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deg': deg,
      'guts': guts,
      'speed': speed
    };
  }
}
