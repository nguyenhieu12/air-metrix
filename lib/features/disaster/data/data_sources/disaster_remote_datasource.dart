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

      List<DisasterModel> returnedListModel = [];

      for (int i = 0; i < listResult.length; i++) {
        List<dynamic> geometries = listResult[i]['geometry'];

        returnedListModel.add(DisasterModel(
            categories:
                CategoriesModel.fromJson(listResult[i]['categories'][0]),
            geometry: GeometryModel.fromJson(geometries[geometries.length - 1]),
            title: listResult[i]['title']));
      }

      return returnedListModel;
    } else {
      throw ApiException();
    }
  }
}
