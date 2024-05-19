import 'package:envi_metrix/features/air_pollution/presentation/cubits/air_pollution_cubit.dart';
import 'package:envi_metrix/features/disaster/presentation/cubits/disaster_cubit.dart';
import 'package:envi_metrix/injector/injector.dart';
import 'package:envi_metrix/services/location/user_location.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardLoading()) {
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

  Future<void> getDashboardInitData() async {
    getAirData();
    getDisastersData();
  }

  Future<void> getAirData() async {
    airPollutionCubit.fetchAirPollutionData(
        airPollutionCubit.currentLat, airPollutionCubit.currentLong, false);
  }

  void getDisastersData() {
    disasterCubit.getDisaster();
  }
}
