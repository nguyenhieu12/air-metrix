import 'dart:io';

import 'package:envi_metrix/core/themes/app_colors.dart';
import 'package:envi_metrix/features/disaster/domain/entities/disaster_entity.dart';
import 'package:envi_metrix/features/disaster/presentation/cubits/disaster_cubit.dart';
import 'package:envi_metrix/injector/injector.dart';
import 'package:envi_metrix/services/location/default_location.dart';
import 'package:envi_metrix/services/location/user_location.dart';
import 'package:envi_metrix/utils/utils.dart';
import 'package:envi_metrix/widgets/disaster_symbol_dialog.dart';
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

  bool isDisastersMap = true;
  bool isAirQualityMap = false;

  @override
  void initState() {
    super.initState();

    disasterCubit = Injector.instance();

    disasterCubit.getDisaster();
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
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
            return _buildMap(state);
          } else {
            return _buildMapErrorContent();
          }
        },
      ),
    );
  }

  Widget _buildMapErrorContent() {
    return Center(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            ColorFiltered(
              colorFilter:
                  const ColorFilter.mode(Colors.green, BlendMode.srcIn),
              child: Image.asset('./assets/icons/map_error_icon.png',
                  width: 85.w, height: 85.w),
            ),
            Gap(5.h),
            Text(
              'Cannot load map data',
              style: TextStyle(
                  fontSize: 18.w,
                  fontWeight: FontWeight.w400,
                  color: Colors.green),
            ),
            Text(
              'Check your Internet connection',
              style: TextStyle(
                  fontSize: 15.w,
                  fontWeight: FontWeight.w400,
                  color: Colors.green),
            ),
            Gap(10.h),
            GestureDetector(
              onTap: () => disasterCubit.getDisaster(),
              child: Container(
                width: 120.w,
                height: 35.w,
                decoration: BoxDecoration(
                    color: Colors.green,
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

  Widget _buildLoading() {
    return Center(
        child: Platform.isAndroid
            ? CircularProgressIndicator(
                color: AppColors.loading, strokeWidth: 2.0)
            : CupertinoActivityIndicator(color: AppColors.loading));
  }

  Widget _buildMapOptions() {
    return Positioned(
      bottom: 25.h,
      left: 80.w,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isDisastersMap = true;
                isAirQualityMap = false;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  color: isDisastersMap ? Colors.redAccent : Colors.white,
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: EdgeInsets.only(
                    left: 15.w, right: 15.w, top: 6.w, bottom: 6.w),
                child: Text(
                  'Disasters',
                  style: TextStyle(
                      color: isDisastersMap ? Colors.white : Colors.black,
                      fontSize: 15.w,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          Gap(10.w),
          GestureDetector(
            onTap: () {
              setState(() {
                isDisastersMap = false;
                isAirQualityMap = true;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  color: isAirQualityMap ? Colors.green : Colors.white,
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: EdgeInsets.only(
                    left: 15.w, right: 15.w, top: 6.w, bottom: 6.w),
                child: Text(
                  'Air quality',
                  style: TextStyle(
                      color: isAirQualityMap ? Colors.white : Colors.black,
                      fontSize: 15.w),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMap(DisasterSuccess state) {
    return Stack(children: [
      isDisastersMap ? _buildDisastersMap(state) : _buildAirQualityMap(),
      _buildMapOptions(),
      Positioned(
        right: 18.w,
        bottom: 18.h,
        child: Column(
          children: [
            isDisastersMap
                ? Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 89, 0),
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: IconButton(
                          onPressed: () => _showListDisaster(),
                          icon: Icon(
                            Icons.list,
                            color: AppColors.whiteIcon,
                            size: 28.w,
                          )),
                    ))
                : const SizedBox.shrink(),
            Gap(10.h),
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
          ],
        ),
      ),
      hasDisasterSelected ? _buildDisasterCardInfo() : const SizedBox()
    ]);
  }

  Widget _buildDisastersMap(DisasterSuccess state) {
    return FlutterMap(
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
    );
  }

  Widget _buildAirQualityMap() {
    return FlutterMap(
      options: MapOptions(
          initialCenter: LatLng(DefaultLocation.lat, DefaultLocation.long),
          initialZoom: 3.0),
      children: [
        TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
        TileLayer(
          urlTemplate:
              'https://tiles.aqicn.org/tiles/usepa-aqi/{z}/{x}/{y}.png',
        ),
      ],
    );
  }

  Widget _buildDisasterCardInfo() {
    return Positioned(
      left: 20.w,
      right: 80.w,
      bottom: 20.h,
      child: Container(
        width: 330.w,
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

  void _showListDisaster() {
    showDialog(
        barrierColor: Colors.grey.withOpacity(0.5),
        barrierDismissible: true,
        context: context,
        builder: (context) => const DisasterSymbolDialog());
  }
}
