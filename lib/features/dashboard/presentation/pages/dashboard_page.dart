import 'package:envi_metrix/core/themes/filter_app_colors.dart';
import 'package:envi_metrix/features/air_pollution/presentation/cubits/air_pollution_cubit.dart';
import 'package:envi_metrix/features/dashboard/presentation/cubits/dashboard_cubit.dart';
import 'package:envi_metrix/features/disaster/presentation/cubits/disaster_cubit.dart';
import 'package:envi_metrix/injector/injector.dart';
import 'package:envi_metrix/services/location/user_location.dart';
import 'package:envi_metrix/utils/global_variables.dart';
import 'package:envi_metrix/utils/pollutant_message.dart';
import 'package:envi_metrix/utils/styles.dart';
import 'package:envi_metrix/widgets/location_search_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:screenshot/screenshot.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late AirPollutionCubit airPollutionCubit;
  late DisasterCubit disasterCubit;

  final DashboardCubit dashboardCubit = DashboardCubit();

  final UserLocation userLocation = UserLocation();

  Map<String, String> disasterName = {
    'drought': 'Drought',
    'dustHaze': 'Dust and haze',
    'earthquakes': 'Earthquake',
    'floods': 'Flood',
    'landslides': 'Landslide',
    'seaLakeIce': 'Sea and Lake Ice',
    'severeStorms': 'Severe Storm',
    'snow': 'Snow',
    'tempExtremes': 'High Temperature',
    'volcanoes': 'Volcano',
    'wildfires': 'Wildfire'
  };

  @override
  void initState() {
    super.initState();

    airPollutionCubit = Injector.instance();
    disasterCubit = Injector.instance();

    dashboardCubit.getDashboardInitData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _buildDashboardContent(),
      ),
    );
  }

  Widget _buildAirLoading() {
    return Center(
      child: SizedBox(
        height: 350.h,
        child: Column(
          children: [
            Gap(50.h),
            Text(
              'Loading air data',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 22.w,
                  fontWeight: FontWeight.w400),
            ),
            Gap(10.h),
            LoadingAnimationWidget.fourRotatingDots(
                color: Colors.blue, size: 60.w)
          ],
        ),
      ),
    );
  }

  Widget _buildDisasterLoading() {
    return Center(
      child: SizedBox(
        height: 350.h,
        child: Column(
          children: [
            Text(
              'Loading disasters data',
              style: TextStyle(
                  color: Colors.orange,
                  fontSize: 22.w,
                  fontWeight: FontWeight.w400),
            ),
            Gap(10.h),
            LoadingAnimationWidget.threeArchedCircle(
                color: Colors.orange, size: 60.w)
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardContent() {
    return RefreshIndicator(
      onRefresh: () => dashboardCubit.getDashboardInitData(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(20.h),
            LocationSearchBar(airPollutionCubit: airPollutionCubit),
            Gap(10.h),
            _buildLocalInformation(),
            Gap(10.h),
            _buildGlobalInformation()
          ],
        ),
      ),
    );
  }

  Widget _buildLocalInformation() {
    return BlocBuilder<AirPollutionCubit, AirPollutionState>(
        bloc: dashboardCubit.airPollutionCubit,
        builder: (context, state) {
          if (state is AirPollutionLoading) {
            return _buildAirLoading();
          } else if (state is AirPollutionSuccess) {
            return _buildAirInfo(state);
          } else {
            return _buildAirErrorContent();
          }
        });
  }

  Widget _buildAirInfo(AirPollutionSuccess state) {
    double temp = airPollutionCubit.weatherEntity.temp - 273.0;

    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Air quality', style: headerTextStyle),
          Gap(6.h),
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: FilterAppColors.getAQIColor(
                        dashboardCubit.airPollutionCubit.airQualityIndex),
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  children: [
                    Gap(4.h),
                    _buildLocationName(state),
                    Text(
                      PollutantMessage.getPollutantMessage(
                          airPollutionCubit.airQualityIndex),
                      style: TextStyle(color: Colors.white, fontSize: 24.w),
                    )
                  ],
                ),
              ),
              Gap(8.h),
              ColoredBox(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildWeatherComponent(
                        name: 'Temperature',
                        value: temp.toPrecision(2),
                        unit: AppUnits.tempUnit,
                        iconPath: './assets/icons/temp_icon.png',
                        iconSize: 40.w,
                        distance: 6.w),
                    Gap(4.w),
                    _buildWeatherComponent(
                        name: 'Humidity',
                        value: airPollutionCubit.weatherEntity.humidity,
                        unit: AppUnits.humidityUnit,
                        iconPath: './assets/icons/humidity_icon.png',
                        iconSize: 35.w,
                        distance: 12.w),
                  ],
                ),
              ),
              Gap(10.h),
              ColoredBox(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildWeatherComponent(
                        name: 'Pressure',
                        value: airPollutionCubit.weatherEntity.pressure,
                        unit: AppUnits.pressureUnit,
                        iconPath: './assets/icons/pressure_icon.png',
                        iconSize: 45.w,
                        distance: 10.w),
                    Gap(4.w),
                    _buildWeatherComponent(
                        name: 'Wind',
                        value: airPollutionCubit.weatherEntity.windSpeed,
                        unit: AppUnits.windUnit,
                        iconPath: './assets/icons/wind_icon.png',
                        iconSize: 55.w,
                        distance: 2.w),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildWeatherComponent(
      {required String name,
      required dynamic value,
      required String unit,
      required String iconPath,
      required double iconSize,
      required double distance}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(color: Colors.grey, offset: Offset(0, 0), spreadRadius: 2)
          ]),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Row(
            children: [
              SizedBox(
                  width: iconSize,
                  height: iconSize,
                  child: Image.asset(iconPath)),
              Gap(distance),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.w,
                        fontWeight: FontWeight.w500),
                  ),
                  Gap(6.h),
                  Text(
                    '${value.toString()} $unit',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.w,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAirErrorContent() {
    return Center(
      child: Column(
        children: [
          Gap(50.h),
          Image.asset('./assets/icons/air_error_icon.png',
              width: 75.w, height: 75.w),
          Gap(5.h),
          Text(
            'Cannot load air quality data',
            style: TextStyle(
                fontSize: 19.w,
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
            onTap: () => dashboardCubit.getAirData(),
            child: Container(
              width: 120.w,
              height: 35.w,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(30)),
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
    );
  }

  Widget _buildDisasterErrorContent() {
    return Center(
      child: Column(
        children: [
          Gap(100.h),
          Image.asset('./assets/icons/disaster_error_icon.png',
              width: 85.w, height: 85.w),
          Gap(5.h),
          Text(
            'Cannot load disaster data',
            style: TextStyle(
                fontSize: 19.w,
                fontWeight: FontWeight.w400,
                color: Colors.orange),
          ),
          Text(
            'Check your Internet connection',
            style: TextStyle(
                fontSize: 15.w,
                fontWeight: FontWeight.w400,
                color: Colors.orange),
          ),
          Gap(10.h),
          GestureDetector(
            onTap: () => dashboardCubit.getDisastersData(),
            child: Container(
              width: 120.w,
              height: 35.w,
              decoration: BoxDecoration(
                  color: Colors.orange,
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
    );
  }

  Widget _buildLocationName(AirPollutionSuccess state) {
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
            size: 22.w,
            color: Colors.white,
          ),
        ),
        Gap(6.w),
        Flexible(
          child: Text(
              '${airPollutionCubit.address.pronvice}, ${airPollutionCubit.address.country}',
              style: TextStyle(
                  fontSize: 20.w,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  Widget _buildGlobalInformation() {
    return BlocBuilder<DisasterCubit, DisasterState>(
        bloc: dashboardCubit.disasterCubit,
        buildWhen: (previous, current) => previous != current,
        builder: ((context, state) {
          if (state is DisasterLoading) {
            return _buildDisasterLoading();
          } else if (state is DisasterSuccess) {
            return _buildGlobalDisasterContent();
          } else {
            return _buildDisasterErrorContent();
          }
        }));
  }

  Widget _buildGlobalDisasterContent() {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Disasters', style: headerTextStyle),
          Gap(6.h),
          _buildDisasterQuantity(),
          Gap(12.h),
          _buildDisastersList(),
        ],
      ),
    );
  }

  Widget _buildDisasterQuantity() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.45,
          decoration: BoxDecoration(
              color: Colors.blueAccent, borderRadius: BorderRadius.circular(5)),
          child: Column(
            children: [
              Gap(4.h),
              Text(
                'Quantity',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.w,
                    fontWeight: FontWeight.w500),
              ),
              Gap(4.h),
              Text(
                dashboardCubit.disasterCubit.totalDisasters.toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.w,
                    fontWeight: FontWeight.w500),
              ),
              Gap(4.h)
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.46,
          decoration: BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(5)),
          child: Column(
            children: [
              Gap(4.h),
              Text(
                'Main disaster',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.w,
                    fontWeight: FontWeight.w500),
              ),
              Gap(4.h),
              Text(
                disasterName[dashboardCubit.disasterCubit.maxDisaster] ?? '',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.w,
                    fontWeight: FontWeight.w500),
              ),
              Gap(4.h)
            ],
          ),
        )
      ],
    );
  }

  Widget _buildDisastersList() {
    return Container(
      width: 400.w,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.75),
                offset: const Offset(0, 0),
                blurRadius: 0.5),
          ]),
      child: Padding(
        padding: EdgeInsets.only(left: 10.w, right: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Gap(4.h),
            Text('List disasters',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.w,
                    fontWeight: FontWeight.w400)),
            Gap(6.h),
            _buildRowDisasterInfo(),
            Gap(20.h),
            _buildDisastersChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildRowDisasterInfo() {
    List<TableRow> rowDisasters = [];

    dashboardCubit.disasterCubit.disasterQuantity
        .forEach((key, value) => rowDisasters.add(TableRow(children: [
              TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 6.h, bottom: 6.h),
                      child: Image.asset(
                        './assets/icons/${key}_icon.png',
                        width: 24.w,
                        height: 24.w,
                      ),
                    ),
                  )),
              TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Center(
                    child: Text('${disasterName[key]}',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.w,
                            fontWeight: FontWeight.w400)),
                  )),
              TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Center(
                    child: Text(value.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.w,
                            fontWeight: FontWeight.w400)),
                  )),
            ])));

    return Table(
      border: TableBorder.all(color: Colors.grey),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(children: [
          TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Center(
                child: Text('Icon',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.w,
                        fontWeight: FontWeight.w400)),
              )),
          TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Center(
                child: Text('Name',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.w,
                        fontWeight: FontWeight.w400)),
              )),
          TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Center(
                child: Text('Quantity',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.w,
                        fontWeight: FontWeight.w400)),
              )),
        ]),
        ...rowDisasters
      ],
    );
  }

  Widget _buildDisastersChart() {
    List<UnitDisaster> listUnitDisasters = dashboardCubit
        .disasterCubit.disasterQuantity.entries
        .map((entry) =>
            UnitDisaster(disasterId: entry.key, quantity: entry.value))
        .toList();

    List<PieChartSectionData> sectionData = [];

    List<Color> chartColors = dashboardCubit.disasterCubit.disastersChartColor;

    for (int i = 0; i < listUnitDisasters.length; i++) {
      sectionData.add(PieChartSectionData(
          value: listUnitDisasters[i].quantity.toDouble(),
          color: chartColors[i],
          title: listUnitDisasters[i].quantity.toString(),
          titleStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14.5.w)));
    }

    return Center(
      child: Column(
        children: [
          SizedBox(
              width: 230.w,
              height: 230.w,
              child: PieChart(PieChartData(
                  centerSpaceColor: Colors.transparent,
                  sections: sectionData))),
          Gap(20.h),
          _buildChartNote()
        ],
      ),
    );
  }

  Widget _buildChartNote() {
    List<UnitDisaster> listUnitDisasters = dashboardCubit
        .disasterCubit.disasterQuantity.entries
        .map((entry) =>
            UnitDisaster(disasterId: entry.key, quantity: entry.value))
        .toList();

    List<Color> chartColors = dashboardCubit.disasterCubit.disastersChartColor;

    return Padding(
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.25),
      child: Column(
        children: [
          for (int i = 0; i < chartColors.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Row(
                children: [
                  Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                        color: chartColors[i],
                        borderRadius: BorderRadius.circular(50)),
                  ),
                  Gap(10.w),
                  Text(
                    disasterName[listUnitDisasters[i].disasterId] ?? '',
                    style: TextStyle(color: Colors.black, fontSize: 14.w),
                  )
                ],
              ),
            ),
          Gap(25.h),
        ],
      ),
    );
  }
}

class UnitDisaster {
  final String disasterId;
  final int quantity;

  UnitDisaster({required this.disasterId, required this.quantity});
}
