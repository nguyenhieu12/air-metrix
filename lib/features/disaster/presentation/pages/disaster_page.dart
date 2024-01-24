import 'dart:io';

import 'package:dio/dio.dart';
import 'package:envi_metrix/core/themes/app_colors.dart';
import 'package:envi_metrix/features/disaster/data/data_sources/disaster_remote_datasource.dart';
import 'package:envi_metrix/features/disaster/data/repositories/disaster_repository_impl.dart';
import 'package:envi_metrix/features/disaster/domain/entities/disaster_entity.dart';
import 'package:envi_metrix/features/disaster/domain/use_cases/get_current_disaster.dart';
import 'package:envi_metrix/features/disaster/presentation/cubits/disaster_cubit.dart';
import 'package:envi_metrix/services/location/default_location.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';

class DisasterPage extends StatefulWidget {
  const DisasterPage({super.key});

  @override
  State<DisasterPage> createState() => _DisasterPageState();
}

class _DisasterPageState extends State<DisasterPage> {
  late DisasterCubit disasterCubit;

  MapController mapController = MapController();

  late List<DisasterEntity> entities;

  @override
  void initState() {
    super.initState();

    initDisasterData();

    entities = disasterCubit.disasterEnitites;
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
            return _buildDisasterMap();
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

  Widget _buildDisasterMap() {
    return Stack(children: [
      FlutterMap(
        mapController: mapController,
        options: MapOptions(
            initialCenter: LatLng(DefaultLocation.lat, DefaultLocation.long),
            initialZoom: 4,
            minZoom: 3,
            maxZoom: 15),
        children: [
          TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
          MarkerLayer(markers: [..._buildMapMarker()])
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
                      onPressed: () => _showListDisaster(),
                      icon: Icon(
                        Icons.list,
                        color: AppColors.whiteIcon,
                        size: 28.w,
                      )),
                )),
          ],
        ),
      )
    ]);
  }

  List<Marker> _buildMapMarker() {
    List<Marker> markers = [];

    for (int i = 0; i < entities.length; i++) {
      if (entities[i].categories.id == 'manmade' ||
          entities[i].categories.id == 'waterColor') {
        continue;
      }
      markers.add(Marker(
          point: LatLng(entities[i].geometry.coordinates[1],
              entities[i].geometry.coordinates[0]),
          child: Image.asset(
            './assets/icons/${entities[i].categories.id}_icon.png',
            width: 25.w,
            height: 25.w,
          )));
    }

    return markers;
  }

  Future<void> _handleUserLocation() async {}

  void _showListDisaster() {
    print('Disaster length: ${entities.length}');

    showGeneralDialog(
      context: context,
      barrierColor: Colors.grey.withOpacity(0.25),
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        const beginOffset = Offset(1.0, 0.0);
        const endOffset = Offset(0.0, 0.0);
        const curve = Curves.easeInOut;

        return SlideTransition(
            position: Tween<Offset>(begin: beginOffset, end: endOffset)
                .animate(CurvedAnimation(
              parent: animation,
              curve: curve,
            )),
            child: child);
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          content: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Disaster symbols',
                  style: TextStyle(
                      fontSize: 18.w,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDefault),
                ),

                for (int i = 0; i < entities.length; i++)
                  Row(
                    children: [
                      Text(entities[i].categories.id),
                      Text(entities[i].categories.title)
                    ],
                  )
                // SizedBox(
                //   width: 100.w,
                //   child: ListView.builder(
                //     itemCount: entities.length,
                //     itemBuilder: (context, index) {
                //       return Row(
                //         children: [
                //           Text(entities[index].categories.id),
                //           Text(entities[index].categories.title)
                //         ],
                //       );
                //     }

                //   ),
                // )
              ],
            ),
          ),
        );
      },
    );
  }
}
