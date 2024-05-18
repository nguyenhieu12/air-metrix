import 'package:envi_metrix/core/models/address_model.dart';
import 'package:envi_metrix/features/air_pollution/domain/entities/air_pollution_entity.dart';
import 'package:envi_metrix/features/air_pollution/presentation/cubits/air_pollution_cubit.dart';
import 'package:envi_metrix/features/disaster/domain/entities/disaster_entity.dart';
import 'package:envi_metrix/features/disaster/presentation/cubits/disaster_cubit.dart';
import 'package:envi_metrix/injector/injector.dart';
import 'package:envi_metrix/services/location/default_location.dart';
import 'package:envi_metrix/services/location/user_location.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardInitial()) {
    airPollutionCubit = Injector.instance();
    disasterCubit = Injector.instance();
    userLocation = UserLocation();
  }

  late AirPollutionCubit airPollutionCubit;
  late DisasterCubit disasterCubit;
  late UserLocation userLocation;

  Map<String, int> disasterQuantity = {};
  String maxDisaster = '';

  int totalDisasters = 0;

  void getDashboardInitData() {
    getAirData();
    getDisastersData();
  }

  Future<void> getAirData() async {
    airPollutionCubit.fetchAirPollutionData(
        DefaultLocation.lat, DefaultLocation.long, true);
  }

  void getDisastersData() {
    disasterCubit.getDisaster();
  }
}
