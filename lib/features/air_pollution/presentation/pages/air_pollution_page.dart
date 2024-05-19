import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:envi_metrix/core/connection/internet_cubit.dart';
import 'package:envi_metrix/core/themes/app_colors.dart';
import 'package:envi_metrix/core/themes/filter_app_colors.dart';
import 'package:envi_metrix/features/air_pollution/presentation/cubits/air_pollution_cubit.dart';
import 'package:envi_metrix/features/air_pollution/presentation/widgets/contaminant_info.dart';
import 'package:envi_metrix/injector/injector.dart';
import 'package:envi_metrix/services/location/user_location.dart';
import 'package:envi_metrix/utils/global_variables.dart';
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

  List<String> chartOptions = [
    'Next 6 hours',
    'Next 12 hours',
    'Next 3 days',
  ];

  String selectedValue = 'Next 6 hours';

  List<int> test = [];

  @override
  void initState() {
    super.initState();

    airPollutionCubit = Injector.instance();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => airPollutionCubit.fetchAirPollutionData(
          airPollutionCubit.currentLat, airPollutionCubit.currentLong, false),
      child: Scaffold(
        body: BlocProvider.value(
          value: Injector.instance<AirPollutionCubit>(),
          child: BlocBuilder<AirPollutionCubit, AirPollutionState>(
              builder: (context, state) {
            if (state is AirPollutionLoading) {
              return _buildLoading();
            } else if (state is AirPollutionSuccess) {
              return _buildAirPollutionContent();
            } else {
              return _buildErrorContent();
            }
          }),
        ),
      ),
    );
  }

  Widget _buildErrorContent() {
    return Center(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Image.asset('./assets/icons/air_error_icon.png',
                width: 85.w, height: 85.w),
            Gap(5.h),
            Text(
              'Cannot load air quality data',
              style: TextStyle(
                  fontSize: 18.w,
                  fontWeight: FontWeight.w400,
                  color: Colors.blue),
            ),
            Text(
              'Check your Internet connection',
              style: TextStyle(
                  fontSize: 15.w,
                  fontWeight: FontWeight.w400,
                  color: Colors.blue),
            ),
            Gap(10.h),
            GestureDetector(
              onTap: () => airPollutionCubit.fetchAirPollutionData(
                  airPollutionCubit.currentLat,
                  airPollutionCubit.currentLong,
                  false),
              child: Container(
                width: 120.w,
                height: 35.w,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.refresh,
                      color: Colors.white,
                      size: 22.w,
                    ),
                    Gap(6.w),
                    DefaultTextStyle(
                        style: TextStyle(color: Colors.white, fontSize: 20.w),
                        child: const Text('Reload'))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAirPollutionContent() {
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
            _buildLocationName(),
            Gap(10.h),
            _buildAirQualityIndex(),
            _buildContaminantInfo(),
            Gap(5.h),
            _buildForecaseSection(),
            Gap(20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildForecaseSection() {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(15.h),
              _buildDropdownChartOption(),
              Gap(25.h),
              selectedValue == 'Next 6 hours'
                  ? _build6HoursForecastChart()
                  : (selectedValue == 'Next 12 hours'
                      ? _build12HoursForecastChart()
                      : _build3DaysForecastChart()),
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
              )
            ],
          ),
        ),
        Gap(15.h)
      ]),
    );
  }

  Widget _build3DaysForecastChart() {
    final List<int> data = airPollutionCubit.list3DaysForecastAQI;

    return Padding(
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
                        .map(
                            (e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
                        .toList(),
                    dotData: const FlDotData(
                      show: true,
                    )),
              ],
              borderData: FlBorderData(
                  border:
                      const Border(bottom: BorderSide(), left: BorderSide())),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                    sideTitles: SideTitles(
                  showTitles: false,
                )),
                rightTitles: const AxisTitles(
                    sideTitles: SideTitles(
                  showTitles: false,
                )),
                bottomTitles:
                    AxisTitles(sideTitles: _bottomTitles3DaysForecast),
              )),
          duration: const Duration(milliseconds: 300),
          curve: Curves.linear,
        ),
      ),
    );
  }

  Widget _build6HoursForecastChart() {
    final List<int> data = airPollutionCubit.list6HoursForecastAQI;

    return Padding(
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
                        .map(
                            (e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
                        .toList(),
                    dotData: const FlDotData(
                      show: true,
                    )),
              ],
              borderData: FlBorderData(
                  border:
                      const Border(bottom: BorderSide(), left: BorderSide())),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                    sideTitles: SideTitles(
                  showTitles: false,
                )),
                rightTitles: const AxisTitles(
                    sideTitles: SideTitles(
                  showTitles: false,
                )),
                bottomTitles:
                    AxisTitles(sideTitles: _bottomTitles6HoursForecast),
              )),
          duration: const Duration(milliseconds: 300),
          curve: Curves.linear,
        ),
      ),
    );
  }

  Widget _build12HoursForecastChart() {
    final List<int> data = airPollutionCubit.list12HoursForecastAQI;

    return Padding(
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
                        .map(
                            (e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
                        .toList(),
                    dotData: const FlDotData(
                      show: true,
                    )),
              ],
              borderData: FlBorderData(
                  border:
                      const Border(bottom: BorderSide(), left: BorderSide())),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                    sideTitles: SideTitles(
                  showTitles: false,
                )),
                rightTitles: const AxisTitles(
                    sideTitles: SideTitles(
                  showTitles: false,
                )),
                bottomTitles:
                    AxisTitles(sideTitles: _bottomTitles12HoursForecast),
              )),
          duration: const Duration(milliseconds: 300),
          curve: Curves.linear,
        ),
      ),
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

  SideTitles get _bottomTitles6HoursForecast => SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          DateTime today = DateTime.now();
          String text = '';
          switch (value) {
            case 0.0:
              text = 'Now';
              break;
            case 1.0:
              text = DateFormat('HH:mm')
                  .format(today.add(const Duration(hours: 1)));
              break;
            case 2.0:
              text = DateFormat('HH:mm')
                  .format(today.add(const Duration(hours: 2)));
              break;
            case 3.0:
              text = DateFormat('HH:mm')
                  .format(today.add(const Duration(hours: 3)));
              break;
            case 4.0:
              text = DateFormat('HH:mm')
                  .format(today.add(const Duration(hours: 4)));
              break;
            case 5.0:
              text = DateFormat('HH:mm')
                  .format(today.add(const Duration(hours: 5)));
              break;
            case 6.0:
              text = DateFormat('HH:mm')
                  .format(today.add(const Duration(hours: 6)));
              break;
          }

          return Text(text);
        },
      );

  SideTitles get _bottomTitles12HoursForecast => SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          DateTime today = DateTime.now();
          String text = '';
          switch (value) {
            case 0.0:
              text = 'Now';
              break;
            case 1.0:
              text = DateFormat('HH:mm')
                  .format(today.add(const Duration(hours: 2)));
              break;
            case 2.0:
              text = DateFormat('HH:mm')
                  .format(today.add(const Duration(hours: 4)));
              break;
            case 3.0:
              text = DateFormat('HH:mm')
                  .format(today.add(const Duration(hours: 6)));
              break;
            case 4.0:
              text = DateFormat('HH:mm')
                  .format(today.add(const Duration(hours: 8)));
              break;
            case 5.0:
              text = DateFormat('HH:mm')
                  .format(today.add(const Duration(hours: 10)));
              break;
            case 6.0:
              text = DateFormat('HH:mm')
                  .format(today.add(const Duration(hours: 12)));
              break;
          }

          return Text(text);
        },
      );

  Widget _buildDropdownChartOption() {
    return Padding(
      padding: EdgeInsets.only(left: 10.w),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: const Row(
            children: [
              Icon(
                Icons.list,
                size: 20,
                color: Colors.white,
              ),
              SizedBox(
                width: 4,
              ),
              Expanded(
                child: Text(
                  'Select Item',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          items: chartOptions
              .map((String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          value: selectedValue,
          onChanged: (value) {
            setState(() {
              selectedValue = value!;
            });
          },
          buttonStyleData: ButtonStyleData(
            height: 40,
            width: 160,
            padding: const EdgeInsets.only(left: 14, right: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.black26,
              ),
              color: Colors.green.withOpacity(0.75),
            ),
            elevation: 2,
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.arrow_forward_ios_outlined,
            ),
            iconSize: 16,
            iconEnabledColor: Colors.white,
            iconDisabledColor: Colors.white,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.green.withOpacity(0.75),
            ),
            offset: const Offset(0, 0),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all(6),
              thumbVisibility: MaterialStateProperty.all(true),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.only(left: 14, right: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Tooltip(
          showDuration: const Duration(milliseconds: 2500),
          textStyle: TextStyle(fontSize: 14.w, color: Colors.white),
          triggerMode: TooltipTriggerMode.tap,
          message:
              '${airPollutionCubit.address.street}, ${airPollutionCubit.address.district}, ${airPollutionCubit.address.pronvice}, ${airPollutionCubit.address.country}',
          height: 40.w,
          child: Icon(
            Icons.location_on_outlined,
            size: 28.w,
          ),
        ),
        Gap(6.w),
        Flexible(
          child: Text(
              '${airPollutionCubit.address.pronvice}, ${airPollutionCubit.address.country}',
              style: TextStyle(fontSize: 26.w, fontWeight: FontWeight.w400),
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  Widget _buildAirQualityIndex() {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overview',
            style: headerTextStyle,
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
                          airPollutionCubit.getQualityImagePath(
                              aqi: airPollutionCubit.airQualityIndex),
                          fit: BoxFit.cover,
                        ),
                      ),
                      _buildMainQualityInfo(),
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

  Widget _buildMainQualityInfo() {
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
                  ),
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

  Widget _buildContaminantInfo() {
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
                        airPollutionCubit.airEntity.so2)),
                ContaminantInfo(
                    contamunantName: PollutantName.no2,
                    concentration: convertConcentrationToDouble(
                        airPollutionCubit.airEntity.no2)),
                ContaminantInfo(
                    contamunantName: PollutantName.pm10,
                    concentration: convertConcentrationToDouble(
                        airPollutionCubit.airEntity.pm10)),
                ContaminantInfo(
                    contamunantName: PollutantName.pm25,
                    concentration: convertConcentrationToDouble(
                        airPollutionCubit.airEntity.pm2_5)),
                ContaminantInfo(
                    contamunantName: PollutantName.o3,
                    concentration: convertConcentrationToDouble(
                        airPollutionCubit.airEntity.o3)),
                ContaminantInfo(
                    contamunantName: PollutantName.co,
                    concentration: convertConcentrationToDouble(
                        airPollutionCubit.airEntity.co)),
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
  String _getMainPollutantName(Color AQIColor) {
    if (AQIColor ==
        Utils.getBackgroundColor(PollutantName.pm10,
            convertConcentrationToDouble(airPollutionCubit.airEntity.pm10))) {
      return PollutantName.pm10;
    } else if (AQIColor ==
        Utils.getBackgroundColor(PollutantName.pm25,
            convertConcentrationToDouble(airPollutionCubit.airEntity.pm2_5))) {
      return PollutantName.pm25;
    } else if (AQIColor ==
        Utils.getBackgroundColor(PollutantName.so2,
            convertConcentrationToDouble(airPollutionCubit.airEntity.so2))) {
      return PollutantName.so2;
    } else if (AQIColor ==
        Utils.getBackgroundColor(PollutantName.no2,
            convertConcentrationToDouble(airPollutionCubit.airEntity.no2))) {
      return PollutantName.no2;
    } else if (AQIColor ==
        Utils.getBackgroundColor(PollutantName.o3,
            convertConcentrationToDouble(airPollutionCubit.airEntity.o3))) {
      return PollutantName.o3;
    } else {
      return PollutantName.co;
    }
  }
}
