import 'dart:io';

import 'package:dio/dio.dart';
import 'package:envi_metrix/core/themes/app_colors.dart';
import 'package:envi_metrix/core/themes/filter_app_colors.dart';
import 'package:envi_metrix/features/air_pollution/data/data_sources/air_pollution_remote_data_source.dart';
import 'package:envi_metrix/features/air_pollution/data/repositories/air_pollution_repository_impl.dart';
import 'package:envi_metrix/features/air_pollution/domain/use_cases/get_current_air_pollution.dart';
import 'package:envi_metrix/features/air_pollution/presentation/cubits/air_pollution_cubit.dart';
import 'package:envi_metrix/features/air_pollution/presentation/widgets/contaminant_info.dart';
import 'package:envi_metrix/services/location/default_location.dart';
import 'package:envi_metrix/services/location/user_location.dart';
import 'package:envi_metrix/utils/global_variables.dart';
import 'package:envi_metrix/utils/pollutant_message.dart';
import 'package:envi_metrix/utils/utils.dart';
import 'package:envi_metrix/widgets/location_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';

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

      airPollutionCubit.fetchAirPollutionData(
          DefaultLocation.lat, DefaultLocation.long);
    } else {
      airPollutionCubit.fetchAirPollutionData(
          DefaultLocation.lat, DefaultLocation.long);
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
              return _buildLoading();
            } else if (state is AirPollutionSuccess) {
              return _buildAirPollutionContent(state);
            } else {
              return _buildErrorContent();
            }
          },
        ),
      ),
    );
  }

  Widget _buildErrorContent() {
    return Center(
      child: GestureDetector(
        onTap: () => context
            .read<AirPollutionCubit>()
            .handleReloadCurrentAirPollution(currentLat, currentLong),
        child: Row(children: [
          Icon(
            Icons.refresh,
            color: AppColors.reload,
            size: 30.w,
          ),
          Gap(10.w),
          Text(
            'Reload',
            style: TextStyle(
                fontSize: 20.w,
                fontWeight: FontWeight.w500,
                color: AppColors.reload),
          )
        ]),
      ),
    );
  }

  Widget _buildAirPollutionContent(AirPollutionSuccess state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Gap(40.h),
          LocationSearchBar(airPollutionCubit: airPollutionCubit),
          Gap(15.h),
          _buildAirQualityIndex(state),
          Gap(10.h),
          _buildContaminantInfo(state)
        ],
      ),
    );
  }

  Widget _buildLocationName(AirPollutionSuccess state) {
    return Row(
      children: [
        Icon(
          Icons.location_on_outlined,
          size: 25.w,
        ),
        Gap(6.w),
        Flexible(
          child: Text(
            '${state.address.pronvice}, ${state.address.country}',
            style: TextStyle(fontSize: 22.w, fontWeight: FontWeight.w400),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Spacer(),
        Padding(
          padding: EdgeInsets.only(right: 10.w),
          child: Tooltip(
            triggerMode: TooltipTriggerMode.tap,
            message: 'Detail address...',
            child: Icon(Icons.info_outline, size: 24.w),
          ),
        )
      ],
    );
  }

  Widget _buildAirQualityIndex(AirPollutionSuccess state) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overview',
            style: TextStyle(
              fontSize: 19.w,
              fontWeight: FontWeight.w500,
            ),
          ),
          Gap(8.h),
          Center(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColors.whiteIcon,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 0.5,
                            blurRadius: 0.5,
                            offset: Offset(0.2, 0.2)),
                        BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 0.5,
                            blurRadius: 0.5,
                            offset: Offset(-0.2, -0.2))
                      ]),
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(6.h),
                        _buildLocationName(state),
                        Padding(
                          padding: EdgeInsets.only(right: 10.w),
                          child: const Divider(
                            color: Colors.grey,
                            height: 15,
                            thickness: 0.75,
                          ),
                        ),
                        Gap(12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: FilterAppColors.getAQIColor(
                                      GlobalVariables.airQualityIndex)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Air quality',
                                        style: TextStyle(
                                          color: AppColors.textWhite,
                                          fontSize: 21.w,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Gap(8.h),
                                      Text(
                                        PollutantMessage.getPollutantMessage(
                                            GlobalVariables.airQualityIndex),
                                        style: TextStyle(
                                            fontSize: 20.w,
                                            color: AppColors.textWhite,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ]),
                              ),
                            ),
                            Gap(10.w),
                            Padding(
                              padding: EdgeInsets.only(right: 6.w),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: FilterAppColors.getAQIColor(
                                        GlobalVariables.airQualityIndex)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Main pollutant',
                                          style: TextStyle(
                                            color: AppColors.textWhite,
                                            fontSize: 21.w,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Gap(8.h),
                                        Text(
                                          _getMainPollutantName(
                                              FilterAppColors.getAQIColor(
                                                  GlobalVariables
                                                      .airQualityIndex),
                                              state),
                                          style: TextStyle(
                                            color: AppColors.textWhite,
                                            fontSize: 20.w,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ]),
                                ),
                              ),
                            )
                          ],
                        ),
                        Gap(8.h)
                      ],
                    ),
                  ),
                ),
                Gap(10.w),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContaminantInfo(AirPollutionSuccess state) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(6.h),
          Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: Text(
              'Pollutant concentration',
              style: TextStyle(
                fontSize: 19.w,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Gap(8.h),
          Center(
            child: Wrap(
              spacing: 10.w,
              runSpacing: 15.w,
              children: [
                ContaminantInfo(
                    contamunantName: PollutantName.so2,
                    concentration: state.airPollutionEntity.so2),
                ContaminantInfo(
                    contamunantName: PollutantName.no2,
                    concentration: state.airPollutionEntity.no2),
                ContaminantInfo(
                    contamunantName: PollutantName.pm10,
                    concentration: state.airPollutionEntity.pm10),
                ContaminantInfo(
                    contamunantName: PollutantName.pm25,
                    concentration: state.airPollutionEntity.pm2_5),
                ContaminantInfo(
                    contamunantName: PollutantName.o3,
                    concentration: state.airPollutionEntity.o3),
                ContaminantInfo(
                    contamunantName: PollutantName.co,
                    concentration: state.airPollutionEntity.co),
              ],
            ),
          ),
          Gap(8.h)
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
        child: Platform.isAndroid
            ? CircularProgressIndicator(
                color: AppColors.loading, strokeWidth: 2.0)
            : CupertinoActivityIndicator(color: AppColors.loading));
  }

  Widget _getCompareIcon() {
    return (GlobalVariables.airQualityIndex > GlobalVariables.yesterdayAQI)
        ? Icon(
            Icons.arrow_upward_rounded,
            color: AppColors.whiteIcon,
            size: 24.w,
          )
        : Icon(
            Icons.arrow_downward_rounded,
            color: AppColors.whiteIcon,
            size: 24.w,
          );
  }

  String _getMainPollutantName(Color AQIColor, AirPollutionSuccess state) {
    if (AQIColor ==
        Utils.getBackgroundColor(
            PollutantName.so2, state.airPollutionEntity.so2)) {
      return PollutantName.so2;
    } else if (AQIColor ==
        Utils.getBackgroundColor(
            PollutantName.no2, state.airPollutionEntity.no2)) {
      return PollutantName.no2;
    } else if (AQIColor ==
        Utils.getBackgroundColor(
            PollutantName.pm10, state.airPollutionEntity.pm10)) {
      return PollutantName.pm10;
    } else if (AQIColor ==
        Utils.getBackgroundColor(
            PollutantName.pm25, state.airPollutionEntity.pm2_5)) {
      return PollutantName.pm25;
    } else if (AQIColor ==
        Utils.getBackgroundColor(
            PollutantName.o3, state.airPollutionEntity.o3)) {
      return PollutantName.o3;
    } else {
      return PollutantName.co;
    }
  }
}
