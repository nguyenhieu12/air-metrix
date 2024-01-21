import 'package:envi_metrix/features/disaster/domain/entities/disaster_entity.dart';

class DisasterModel extends DisasterEntity {
  DisasterModel({required super.categories, required super.geometry, required super.title});

  factory DisasterModel.fromJson(Map<String, dynamic> json) => DisasterModel(categories: json['categories'], geometry: json['geometry'], title: json['title']);
}