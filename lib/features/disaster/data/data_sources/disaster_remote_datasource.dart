import 'package:dio/dio.dart';
import 'package:envi_metrix/core/errors/exceptions.dart';
import 'package:envi_metrix/features/disaster/data/models/categories_model.dart';
import 'package:envi_metrix/features/disaster/data/models/disaster_model.dart';
import 'package:envi_metrix/features/disaster/data/models/geometry_model.dart';

abstract class DisasterRemoteDatasource {
  Future<List<DisasterModel>> getCurrentDisaster();
}

class DisasterRemoteDatasourceImpl implements DisasterRemoteDatasource {
  final Dio dio;

  DisasterRemoteDatasourceImpl({required this.dio});

  @override
  Future<List<DisasterModel>> getCurrentDisaster() async {
    final response = await dio.get('https://eonet.gsfc.nasa.gov/api/v3/events');

    if (response.statusCode == 200) {
      List<dynamic> listResult = response.data['events'];

      // print(listResult);

      return listResult
          .map((disaster) => DisasterModel(
              categories: (disaster['categories'] as List).map((category) => CategoriesModel.fromJson(category)).toList(),
              geometry: (disaster['geometry'] as List).map((geometry) => GeometryModel.fromJson(geometry)).toList(),
              title: disaster['title']))
          .toList();
    } else {
      throw ApiException();
    }
  }
}
