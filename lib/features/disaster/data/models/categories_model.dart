import 'package:envi_metrix/features/disaster/domain/entities/categories_entity.dart';

class CategoriesModel extends CategoriesEntity {
  CategoriesModel({required super.id, required super.title});

  factory CategoriesModel.fromJson(Map<String, dynamic> json) =>
      CategoriesModel(id: json['id'], title: json['title']);

  Map<String, dynamic> toJson() => {'id': id, 'title': title};
}
