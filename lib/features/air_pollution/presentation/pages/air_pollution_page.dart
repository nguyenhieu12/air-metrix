import 'dart:io';

import 'package:envi_metrix/core/connection/internet_cubit.dart';
import 'package:envi_metrix/core/themes/app_colors.dart';
import 'package:envi_metrix/core/themes/filter_app_colors.dart';
import 'package:envi_metrix/features/air_pollution/presentation/cubits/air_pollution_cubit.dart';
import 'package:envi_metrix/features/air_pollution/presentation/pages/map_pollution_page.dart';
import 'package:envi_metrix/features/air_pollution/presentation/widgets/contaminant_info.dart';
import 'package:envi_metrix/injector/injector.dart';
import 'package:envi_metrix/services/location/user_location.dart';
import 'package:envi_metrix/utils/global_variables.dart';
import 'package:envi_metrix/utils/page_transition.dart';
import 'package:envi_metrix/utils/pollutant_message.dart';
import 'package:envi_metrix/utils/styles.dart';
import 'package:envi_metrix/utils/utils.dart';
import 'package:envi_metrix/widgets/location_search_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

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

  Map<int, String> chartNote = {
    1: 'Good',
    2: 'Moderate',
    3: 'Unhealthy',
    4: 'Very unhealthy',
    5: 'Hazardous'
  };

  List<int> test = [];

  @override
  void initState() {
    super.initState();

    initializeAirPollution();
  }

  Future<void> initializeAirPollution() async {
    airPollutionCubit = Injector.instance();

    airPollutionCubit.fetchAirPollutionData(
        airPollutionCubit.currentLat, airPollutionCubit.currentLong);

    // if (await userLocation.isAccepted()) {
    //   Position currentPosition = await Utils.getUserLocation();

    //   currentLat = currentPosition.latitude;
    //   currentLong = currentPosition.longitude;

    //   airPollutionCubit.fetchAirPollutionData(
    //       DefaultLocation.lat, DefaultLocation.long);
    // } else {
    //   airPollutionCubit.fetchAirPollutionData(
    //       DefaultLocation.lat, DefaultLocation.long);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InternetCubit, InternetState>(
        builder: ((context, state) {
      return BlocProvider(
        create: (context) => airPollutionCubit,
        child: Scaffold(
          body: BlocProvider.value(
            value: Injector.instance<AirPollutionCubit>(),
            child: BlocBuilder<AirPollutionCubit, AirPollutionState>(
                builder: (context, state) {
              if (state is AirPollutionLoading) {
                return _buildLoading();
              } else if (state is AirPollutionSuccess) {
                return _buildAirPollutionContent(state);
              } else {
                return _buildErrorContent();
              }
            }),
          ),
        ),
      );
    }), listener: ((context, state) {
      Utils.showInternetNotifySnackbar(context, state);
    }));
  }

  Widget _buildErrorContent() {
    return Expanded(
      child: Center(
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
      ),
    );
  }

  Widget _buildAirPollutionContent(AirPollutionSuccess state) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                './assets/images/air_pollution_background.png',
              ),
              fit: BoxFit.fitHeight,
              opacity: 0.5)),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Gap(40.h),
            LocationSearchBar(airPollutionCubit: airPollutionCubit),
            Gap(15.h),
            _buildLocationName(state),
            Gap(10.h),
            _buildAirQualityIndex(state),
            _buildContaminantInfo(state),
            Gap(5.h),
            _buildForecaseSection(),
            Gap(20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildForecaseSection() {
    final List<int> data = airPollutionCubit.listForecastAQI;

    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Forecast chart',
          style: headerTextStyle,
        ),
        Gap(12.h),
        Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Gap(20.h),
              Padding(
                padding: EdgeInsets.only(right: 20.w),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 185.h,
                  child: LineChart(
                    LineChartData(
                        minY: 1,
                        maxY: 5,
                        lineBarsData: [
                          LineChartBarData(
                              spots: data
                                  .asMap()
                                  .entries
                                  .map((e) => FlSpot(
                                      e.key.toDouble(), e.value.toDouble()))
                                  .toList(),
                              dotData: const FlDotData(
                                show: true,
                              )),
                        ],
                        borderData: FlBorderData(
                            border: const Border(
                                bottom: BorderSide(), left: BorderSide())),
                        titlesData: FlTitlesData(
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(
                            showTitles: false,
                          )),
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(
                            showTitles: false,
                          )),
                          bottomTitles: AxisTitles(
                              sideTitles: _bottomTitles3DaysForecast),
                        )),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.linear,
                  ),
                ),
              ),
              Gap(10.h),
              Padding(
                padding: EdgeInsets.only(left: 25.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Y-axis index:',
                      style: TextStyle(
                          fontSize: 17.w, fontWeight: FontWeight.w500),
                    ),
                    Gap(10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...chartNote.entries
                            .map((e) => _buildChartNoteUnit(e.key, e.value))
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Gap(15.h)
      ]),
    );
  }

  Widget _buildChartNoteUnit(int index, String message) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
                color: FilterAppColors.getAQIColor(index),
                borderRadius: BorderRadius.circular(50)),
          ),
          Gap(6.w),
          Text(
            '$index - $message',
            style: TextStyle(color: Colors.black, fontSize: 16.w),
          )
        ],
      ),
    );
  }

  SideTitles get _bottomTitles3DaysForecast => SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          DateTime today = DateTime.now();
          String text = '';
          switch (value) {
            case 0.0:
              text = 'Today';
              break;
            case 1.0:
              text = DateFormat('dd/MM')
                  .format(today.add(const Duration(days: 1)));
              break;
            case 2.0:
              text = DateFormat('dd/MM')
                  .format(today.add(const Duration(days: 2)));
              break;
            case 3.0:
              text = DateFormat('dd/MM')
                  .format(today.add(const Duration(days: 3)));
              break;
          }

          return Text(text);
        },
      );

  Widget _buildLocationName(AirPollutionSuccess state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Tooltip(
          showDuration: const Duration(milliseconds: 2500),
          textStyle: TextStyle(fontSize: 14.w, color: Colors.white),
          triggerMode: TooltipTriggerMode.tap,
          message:
              '${state.address.street}, ${state.address.district}, ${state.address.pronvice}, ${state.address.country}',
          height: 40.w,
          child: Icon(
            Icons.location_on_outlined,
            size: 28.w,
          ),
        ),
        Gap(6.w),
        Flexible(
          child: Text('${state.address.pronvice}, ${state.address.country}',
              style: TextStyle(fontSize: 26.w, fontWeight: FontWeight.w400),
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  Widget _buildAirQualityIndex(AirPollutionSuccess state) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Overview',
                style: headerTextStyle,
              ),
              Gap(10.w),
              GestureDetector(
                onTap: () => Navigator.of(context, rootNavigator: true).push(
                    PageTransition.slideTransition(const MapPollutionPage())),
                child: Icon(
                  Icons.map_outlined,
                  size: 24.w,
                ),
              )
            ],
          ),
          Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(6.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 155.w,
                        height: 150.w,
                        child: Image.asset(
                          getQualityImagePath(),
                          fit: BoxFit.cover,
                        ),
                      ),
                      _buildMainQualityInfo(state),
                    ],
                  ),
                ],
              ),
              Gap(10.w),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainQualityInfo(AirPollutionSuccess state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 160.w,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: FilterAppColors.getAQIColor(
                  airPollutionCubit.airQualityIndex)),
          child: Padding(
            padding: EdgeInsets.only(top: 4.h, bottom: 4.h),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(
                'Air quality',
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 20.w,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Gap(2.h),
              Text(
                PollutantMessage.getPollutantMessage(
                    airPollutionCubit.airQualityIndex),
                style: TextStyle(
                    fontSize: 18.w,
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
            width: 160.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: FilterAppColors.getAQIColor(
                    airPollutionCubit.airQualityIndex)),
            child: Padding(
              padding: EdgeInsets.only(top: 4.h, bottom: 4.h),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(
                  'Main pollutant',
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 20.w,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Gap(2.h),
                Text(
                  _getMainPollutantName(
                      FilterAppColors.getAQIColor(
                          airPollutionCubit.airQualityIndex),
                      state),
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 18.w,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ]),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildContaminantInfo(AirPollutionSuccess state) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pollutant concentration',
            style: headerTextStyle,
          ),
          Gap(12.h),
          Center(
            child: Wrap(
              spacing: 10.w,
              runSpacing: 15.w,
              children: [
                ContaminantInfo(
                    contamunantName: PollutantName.so2,
                    concentration: convertConcentrationToDouble(
                        state.airPollutionEntity.so2)),
                ContaminantInfo(
                    contamunantName: PollutantName.no2,
                    concentration: convertConcentrationToDouble(
                        state.airPollutionEntity.no2)),
                ContaminantInfo(
                    contamunantName: PollutantName.pm10,
                    concentration: convertConcentrationToDouble(
                        state.airPollutionEntity.pm10)),
                ContaminantInfo(
                    contamunantName: PollutantName.pm25,
                    concentration: convertConcentrationToDouble(
                        state.airPollutionEntity.pm2_5)),
                ContaminantInfo(
                    contamunantName: PollutantName.o3,
                    concentration: convertConcentrationToDouble(
                        state.airPollutionEntity.o3)),
                ContaminantInfo(
                    contamunantName: PollutantName.co,
                    concentration: convertConcentrationToDouble(
                        state.airPollutionEntity.co)),
              ],
            ),
          ),
          Gap(10.h)
        ],
      ),
    );
  }

  double convertConcentrationToDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is String) {
      return double.parse(value);
    } else {
      return value;
    }
  }

  Widget _buildLoading() {
    return Center(
        child: Platform.isAndroid
            ? CircularProgressIndicator(
                color: AppColors.loading, strokeWidth: 2.0)
            : CupertinoActivityIndicator(color: AppColors.loading));
  }

  // ignore: non_constant_identifier_names
  String _getMainPollutantName(Color AQIColor, AirPollutionSuccess state) {
    if (AQIColor ==
        Utils.getBackgroundColor(
            PollutantName.pm10, state.airPollutionEntity.pm10)) {
      return PollutantName.pm10;
    } else if (AQIColor ==
        Utils.getBackgroundColor(
            PollutantName.pm25, state.airPollutionEntity.pm2_5)) {
      return PollutantName.pm25;
    } else if (AQIColor ==
        Utils.getBackgroundColor(
            PollutantName.so2, state.airPollutionEntity.so2)) {
      return PollutantName.so2;
    } else if (AQIColor ==
        Utils.getBackgroundColor(
            PollutantName.no2, state.airPollutionEntity.no2)) {
      return PollutantName.no2;
    } else if (AQIColor ==
        Utils.getBackgroundColor(
            PollutantName.o3, state.airPollutionEntity.o3)) {
      return PollutantName.o3;
    } else {
      return PollutantName.co;
    }
  }

  String getQualityImagePath() {
    switch (airPollutionCubit.airQualityIndex) {
      case 1:
        return './assets/images/good_aqi.png';
      case 2:
        return './assets/images/moderate_aqi.png';
      case 3:
        return './assets/images/unhealthy_aqi.png';
      case 4:
        return './assets/images/very_unhealthy_aqi.png';
      case 5:
        return './assets/images/hazardous_aqi.png';

      default:
        return './assets/images/good_aqi.png';
    }
  }
}
