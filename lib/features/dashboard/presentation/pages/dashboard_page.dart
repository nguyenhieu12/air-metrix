import 'dart:io';

import 'package:envi_metrix/core/connection/internet_cubit.dart';
import 'package:envi_metrix/core/themes/app_colors.dart';
import 'package:envi_metrix/features/air_pollution/presentation/cubits/air_pollution_cubit.dart';
import 'package:envi_metrix/features/dashboard/presentation/cubits/dashboard_cubit.dart';
import 'package:envi_metrix/features/disaster/presentation/cubits/disaster_cubit.dart';
import 'package:envi_metrix/injector/injector.dart';
import 'package:envi_metrix/utils/styles.dart';
import 'package:envi_metrix/utils/utils.dart';
import 'package:envi_metrix/widgets/location_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late AirPollutionCubit airPollutionCubit;
  late DisasterCubit disasterCubit;

  final DashboardCubit dashboardCubit = DashboardCubit();

  @override
  void initState() {
    super.initState();

    airPollutionCubit = Injector.instance();
    disasterCubit = Injector.instance();

    dashboardCubit.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<InternetCubit, InternetState>(
        listener: (context, state) {
          Utils.showInternetNotifySnackbar(context, state);
        },
        builder: (context, state) {
          return BlocBuilder(
              bloc: dashboardCubit,
              builder: (context, state) {
                if (state is DashboardLoading) {
                  return _buildDashboardLoading();
                } else if (state is DashboardSuccess) {
                  return _buildDashboardContent();
                } else {
                  return Container();
                }
              });
        },
      ),
    );
  }

  Widget _buildDashboardLoading() {
    return Center(
        child: Platform.isAndroid
            ? CircularProgressIndicator(
                color: AppColors.loading, strokeWidth: 2.0)
            : CupertinoActivityIndicator(color: AppColors.loading));
  }

  Widget _buildDashboardContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(40.h),
          LocationSearchBar(airPollutionCubit: airPollutionCubit),
          Gap(15.h),
          _buildLocalInformation(),
          _buildGlobalInformation()
        ],
      ),
    );
  }

  Widget _buildLocalInformation() {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
      child: Column(
        children: [Text('Information by local', style: headerTextStyle)],
      ),
    );
  }

  Widget _buildGlobalInformation() {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
      child: Column(
        children: [Text('Information by global', style: headerTextStyle)],
      ),
    );
  }
}
