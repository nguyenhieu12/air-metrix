import 'dart:io';

import 'package:dio/dio.dart';
import 'package:envi_metrix/core/themes/app_colors.dart';
import 'package:envi_metrix/features/disaster/data/data_sources/disaster_remote_datasource.dart';
import 'package:envi_metrix/features/disaster/data/repositories/disaster_repository_impl.dart';
import 'package:envi_metrix/features/disaster/domain/entities/disaster_entity.dart';
import 'package:envi_metrix/features/disaster/domain/use_cases/get_current_disaster.dart';
import 'package:envi_metrix/features/disaster/presentation/cubits/disaster_cubit.dart';
import 'package:envi_metrix/services/location/default_location.dart';
import 'package:envi_metrix/services/location/user_location.dart';
import 'package:envi_metrix/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class DisasterPage extends StatefulWidget {
  const DisasterPage({super.key});

  @override
  State<DisasterPage> createState() => _DisasterPageState();
}

class _DisasterPageState extends State<DisasterPage> {
  late DisasterCubit disasterCubit;

  MapController mapController = MapController();

  UserLocation userLocation = UserLocation();

  late DisasterEntity selectedDisaster;

  bool hasDisasterSelected = false;

  Map<String, String> listSymbol = {
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

    initDisasterData();
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  Future<void> initDisasterData() async {
    disasterCubit = DisasterCubit(
        getCurrentDisaster: GetCurrentDisaster(
            disasterRepository: DisasterRepositoryImpl(
                disasterRemoteDatasource:
                    DisasterRemoteDatasourceImpl(dio: Dio()))));

    disasterCubit.getDisaster();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => disasterCubit,
      child: BlocBuilder<DisasterCubit, DisasterState>(
        builder: (context, state) {
          if (state is DisasterLoading) {
            return _buildLoading();
          } else if (state is DisasterSuccess) {
            return _buildDisasterMap(state);
          } else {
            return Container();
          }
        },
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

  Widget _buildDisasterMap(DisasterSuccess state) {
    return Stack(children: [
      FlutterMap(
        mapController: mapController,
        options: MapOptions(
            initialCenter: LatLng(DefaultLocation.lat, DefaultLocation.long),
            initialZoom: 4,
            minZoom: 3,
            maxZoom: 20),
        children: [
          TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
          MarkerLayer(markers: [..._buildMapMarker(state)]),
        ],
      ),
      Positioned(
        right: 18.w,
        bottom: 18.h,
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 140, 255),
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: IconButton(
                      onPressed: () => _handleUserLocation(),
                      icon: Icon(
                        Icons.my_location_outlined,
                        color: AppColors.whiteIcon,
                        size: 25.5.w,
                      )),
                )),
            Gap(10.h),
            Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 89, 0),
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: IconButton(
                      onPressed: () => _showListDisaster(context: context),
                      icon: Icon(
                        Icons.list,
                        color: AppColors.whiteIcon,
                        size: 28.w,
                      )),
                )),
          ],
        ),
      ),
      hasDisasterSelected ? _buildDisasterCardInfo() : const SizedBox()
    ]);
  }

  Widget _buildDisasterCardInfo() {
    return Positioned(
      left: 20.w,
      right: 80.w,
      bottom: 20.h,
      child: Container(
        width: 320.w,
        height: 85.h,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black54,
                  offset: Offset(0.5, 0),
                  blurRadius: 0.2)
            ]),
        child: Padding(
          padding: EdgeInsets.only(left: 10.w, right: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(4.h),
              Row(
                children: [
                  Tooltip(
                    message: selectedDisaster.title,
                    triggerMode: TooltipTriggerMode.tap,
                    showDuration: const Duration(milliseconds: 2500),
                    child: Icon(
                      Icons.info_outline,
                      color: Colors.black,
                      size: 21.5.w,
                    ),
                  ),
                  Gap(6.w),
                  Flexible(
                    child: Text(
                      selectedDisaster.title,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.w,
                          fontWeight: FontWeight.w400),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        hasDisasterSelected = false;
                      });
                    },
                    child: Icon(
                      Icons.clear_rounded,
                      size: 20.w,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
              const Divider(
                color: Colors.grey,
                thickness: 0.6,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Latitude: ${selectedDisaster.geometry.coordinates[1]}',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.5.w,
                              fontWeight: FontWeight.w400)),
                      Gap(2.h),
                      Text(
                          'Longitude: ${selectedDisaster.geometry.coordinates[0]}',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.5.w,
                              fontWeight: FontWeight.w400))
                    ],
                  ),
                  Image.asset(
                    './assets/icons/${selectedDisaster.categories.id}_icon.png',
                    width: 30.w,
                    height: 30.w,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Marker> _buildMapMarker(DisasterSuccess state) {
    List<Marker> markers = [];

    for (int i = 0; i < state.entities.length; i++) {
      if (state.entities[i].categories.id == 'manmade' ||
          state.entities[i].categories.id == 'waterColor') {
        continue;
      }

      double lat = getMarkerLatLng(state.entities[i].geometry.coordinates[1]);
      double long = getMarkerLatLng(state.entities[i].geometry.coordinates[0]);

      markers.add(Marker(
          width: 40.w,
          height: 40.w,
          point: LatLng(lat, long),
          child: GestureDetector(
            onTap: () {
              setState(() {
                hasDisasterSelected = true;
                selectedDisaster = state.entities[i];
              });
            },
            child: Image.asset(
              './assets/icons/${state.entities[i].categories.id}_icon.png',
            ),
          )));
    }

    return markers;
  }

  double getMarkerLatLng(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else {
      return value;
    }
  }

  Future<void> _handleUserLocation() async {
    if (await userLocation.isAccepted()) {
      Position currentPosition = await Utils.getUserLocation();

      mapController.move(
          LatLng(currentPosition.latitude, currentPosition.longitude), 18);
    }
  }

  void _showListDisaster({required BuildContext context}) {
    Utils.showAnimationDialog(
        context: context,
        begin: const Offset(1.0, 0.0),
        end: const Offset(0.0, 0.0),
        child: _buildDisasterListSymbol());
  }

  Widget _buildDisasterListSymbol() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Gap(10.h),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 50.w),
                child: Text(
                  'Disaster symbols',
                  style: TextStyle(
                      fontSize: 20.w,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textDefault),
                ),
              ),
              Gap(10.w),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.clear_outlined,
                  color: Colors.black,
                  size: 22.w,
                ),
              )
            ],
          ),
          Gap(20.h),
          Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_buildListSymbol(), Gap(15.w), _buildListName()],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildListSymbol() {
    List<Widget> symbols = [];

    for (var symbol in listSymbol.keys) {
      symbols.add(
        Image.asset(
          './assets/icons/${symbol}_icon.png',
          width: 33.w,
          height: 33.w,
        ),
      );

      symbols.add(Gap(16.5.h));
    }

    return Column(
      children: [...symbols],
    );
  }

  Widget _buildListName() {
    List<Widget> names = [];

    for (var name in listSymbol.values) {
      name == 'Drought' ? names.add(Gap(8.h)) : names.add(const SizedBox());
      names.add(Text(
        name,
        style: TextStyle(
            color: AppColors.textDefault,
            fontSize: 16.2.w,
            fontWeight: FontWeight.w400),
      ));
      names.add(
        Gap(25.5.h),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [...names],
    );
  }
}
