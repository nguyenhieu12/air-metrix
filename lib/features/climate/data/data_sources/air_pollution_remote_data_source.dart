import 'package:dio/dio.dart';
import 'package:envi_metrix/core/errors/exceptions.dart';
import 'package:envi_metrix/features/climate/data/models/air_pollution_model.dart';

abstract class AirPollutionRemoteDataSource {
  Future<AirPollutionModel> getCurrentAirPollution(double lat, double long);
}

class AirPollutionRemoteDataSourceImpl implements AirPollutionRemoteDataSource {
  final Dio dio;

  AirPollutionRemoteDataSourceImpl(this.dio);

  @override
  Future<AirPollutionModel> getCurrentAirPollution(double lat, double long) async {
    final respone = await dio.get('http://api.openweathermap.org/data/2.5/air_pollution?lat=21.421411&lon=105.133109&appid=31de93752a9da177fbdfe330dd9fe13a');

    if (respone.statusCode == 200) {
     return AirPollutionModel.fromJson(respone.data['list'][0]['components']);
    } else {
      throw ApiException();
    }
  }

}