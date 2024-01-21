import 'package:envi_metrix/features/disaster/domain/entities/geometry_entity.dart';

class GeometryModel extends GeometryEntity {
  GeometryModel({required super.coordinates});

  factory GeometryModel.fromJson(Map<String, dynamic> json) {
    return GeometryModel(
      coordinates: json['coordinates'],
    );
  }
}
