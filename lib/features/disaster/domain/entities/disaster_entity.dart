import 'package:envi_metrix/features/disaster/domain/entities/categories_entity.dart';
import 'package:envi_metrix/features/disaster/domain/entities/geometry_entity.dart';

class DisasterEntity {
  final CategoriesEntity categories;
  final GeometryEntity geometry;
  final String title;

  DisasterEntity(
      {required this.categories,
      required this.geometry,
      required this.title});
}
