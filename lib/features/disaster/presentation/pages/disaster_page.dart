import 'dart:io';

import 'package:dio/dio.dart';
import 'package:envi_metrix/core/keys/app_keys.dart';
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
import 'package:mapbox_gl/mapbox_gl.dart';

class DisasterPage extends StatefulWidget {
  const DisasterPage({super.key});

  @override
  State<DisasterPage> createState() => _DisasterPageState();
}

class _DisasterPageState extends State<DisasterPage> {
  late DisasterCubit disasterCubit;
  late MapboxMapController mapController;

  @override
  void initState() {
    super.initState();

    initDisasterData();
  }

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;

    print('Model: ${disasterCubit.disasterEnitites}');
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
    print('Model: ${disasterCubit.disasterEnitites}');

    return MapboxMap(
        accessToken: AppKeys.mapboxMapKey,
        styleString: MapboxStyles.MAPBOX_STREETS,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
            target: LatLng(DefaultLocation.lat, DefaultLocation.long),
            zoom: 8.0));
  }
}
