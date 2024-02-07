import 'package:envi_metrix/core/connection/internet_cubit.dart';
import 'package:envi_metrix/features/air_pollution/presentation/cubits/air_pollution_cubit.dart';
import 'package:envi_metrix/features/disaster/presentation/cubits/disaster_cubit.dart';
import 'package:envi_metrix/injector/injector.dart';
import 'package:envi_metrix/utils/utils.dart';
import 'package:envi_metrix/widgets/location_search_bar.dart';
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

  @override
  void initState() {
    super.initState();

    airPollutionCubit = Injector.instance();
    disasterCubit = Injector.instance();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<InternetCubit, InternetState>(
        listener: (context, state) {
          Utils.showInternetNotifySnackbar(context, state);
        },
        builder: (context, state) {
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
                  // Gap(15.h),
                  // _buildLocationName(state),
                  // Gap(10.h),
                  // _buildAirQualityIndex(state),
                  // _buildContaminantInfo(state),
                  // Gap(5.h),
                  // _buildForecaseSection(),
                  // Gap(20.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
