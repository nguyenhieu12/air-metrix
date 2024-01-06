import 'dart:io';

import 'package:dio/dio.dart';
import 'package:envi_metrix/core/location/default_location.dart';
import 'package:envi_metrix/core/location/user_location.dart';
import 'package:envi_metrix/core/themes/app_colors.dart';
import 'package:envi_metrix/features/air_pollution/data/data_sources/air_pollution_remote_data_source.dart';
import 'package:envi_metrix/features/air_pollution/data/repositories/air_pollution_repository_impl.dart';
import 'package:envi_metrix/features/air_pollution/domain/use_cases/get_current_air_pollution.dart';
import 'package:envi_metrix/features/air_pollution/presentation/cubits/air_pollution/air_pollution_cubit.dart';
import 'package:envi_metrix/features/air_pollution/presentation/widgets/contaminant_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gap/gap.dart';

class AirPollutionPage extends StatefulWidget {
  const AirPollutionPage({super.key});

  @override
  State<AirPollutionPage> createState() => _AirPollutionPageState();
}

class _AirPollutionPageState extends State<AirPollutionPage> {
  late AirPollutionCubit airPollutionCubit;
  late double currentLat;
  late double currentLong;
  UserLocation userLocation = UserLocation();

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
                child: Center(
                  child: Platform.isAndroid ? CircularProgressIndicator(color: AppColors.loading) : CupertinoActivityIndicator(color: AppColors.loading),
                ),
              );
            } else if (state is AirPollutionSuccess) {
              return Container(
                color: Colors.amber.shade100,
                child: Center(
                  child: Wrap(
                    spacing: 20.w,
                    runSpacing: 20.w,
                    children: [
                      ContaminantInfo(contamunantName: 'SO2', concentration: state.airPollutionEntity.so2),
                      ContaminantInfo(contamunantName: 'NO2', concentration: state.airPollutionEntity.no2),
                      ContaminantInfo(contamunantName: 'PM10', concentration: state.airPollutionEntity.pm10),
                      ContaminantInfo(contamunantName: 'PM2.5', concentration: state.airPollutionEntity.pm2_5),
                      ContaminantInfo(contamunantName: 'O3', concentration: state.airPollutionEntity.o3),
                      ContaminantInfo(contamunantName: 'CO', concentration: state.airPollutionEntity.co),
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: GestureDetector(
                  child: Row(children: [
                    Icon(Icons.refresh, color: AppColors.reload, size: 30.w,),
                    Gap(10.w),
                    Text('Reload',
                      style: TextStyle(
                        fontSize: 20.w,
                        fontWeight: FontWeight.w500,
                        color: AppColors.reload
                      ),
                    )
                  ]),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
