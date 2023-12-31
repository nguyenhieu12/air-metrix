import 'package:dio/dio.dart';
import 'package:envi_metrix/core/location/default_location.dart';
import 'package:envi_metrix/core/location/user_location.dart';
import 'package:envi_metrix/features/climate/data/data_sources/air_pollution_remote_data_source.dart';
import 'package:envi_metrix/features/climate/data/repositories/air_pollution_repository_impl.dart';
import 'package:envi_metrix/features/climate/domain/use_cases/get_current_air_pollution.dart';
import 'package:envi_metrix/features/climate/presentation/cubits/air_pollution/air_pollution_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class AirPollutionPage extends StatefulWidget {
  const AirPollutionPage({super.key});

  @override
  State<AirPollutionPage> createState() => _AirPollutionPageState();
}

class _AirPollutionPageState extends State<AirPollutionPage> with AutomaticKeepAliveClientMixin {
  late AirPollutionCubit airPollutionCubit;
  late double currentLat;
  late double currentLong;
  UserLocation userLocation = UserLocation();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    initializeAirPollution();
  }

  Future<void> initializeAirPollution() async {
    airPollutionCubit = AirPollutionCubit(
      getCurrentAirPollution: GetAirPollutionInformation(
        airPollutionRepository: AirPollutionRepositoryImpl(
          remoteDataSource: AirPollutionRemoteDataSourceImpl(Dio()),
        ),
      ),
    );

    if (await userLocation.isAccepted()) {
      Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      
      currentLat = currentPosition.latitude;
      currentLong = currentPosition.longitude;

      print(
          'Latitude: ${currentPosition.latitude} and Longitude: ${currentPosition.longitude}');

      airPollutionCubit.fetchAirPollutionData(currentPosition.latitude, currentPosition.longitude);
    } else {
      airPollutionCubit.fetchAirPollutionData(DefaultLocation.lat, DefaultLocation.long);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => airPollutionCubit,
      child: Scaffold(
        body: BlocBuilder<AirPollutionCubit, AirPollutionState>(
          builder: (context, state) {
            if (state is AirPollutionLoading) {
              return Container(
                color: Colors.red,
              );
            } else if (state is AirPollutionLoaded) {
              return Container(
                color: Colors.white,
                child: Center(
                  child: Wrap(
                    children: [
                      Text('Latitude: $currentLat and Longitude $currentLong',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 30
                        ),
                      ),
                      Text(
                        state.airPollutionEntity.toMap().toString(),
                        style: const TextStyle(color: Colors.black, fontSize: 30),
                      )
                    ],
                  ),
                ),
              );
            } else {
              return Container(color: Colors.orange);
            }
          },
        ),
      ),
    );
  }
}
