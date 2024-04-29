import 'package:envi_metrix/features/air_pollution/presentation/cubits/air_compare_cubit.dart';
import 'package:envi_metrix/features/air_pollution/presentation/cubits/air_pollution_cubit.dart';
import 'package:envi_metrix/features/app/cubits/app_cubit.dart';
import 'package:envi_metrix/injector/injector.dart';
import 'package:envi_metrix/utils/global_variables.dart';
import 'package:envi_metrix/utils/pollutant_message.dart';
import 'package:envi_metrix/utils/utils.dart';
import 'package:envi_metrix/widgets/air_compare_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AirCompareDialog extends StatefulWidget {
  const AirCompareDialog({super.key});

  @override
  State<AirCompareDialog> createState() => _AirCompareDialogState();
}

class _AirCompareDialogState extends State<AirCompareDialog> {
  late AirCompareCubit _cubit;
  late AppCubit _appCubit;
  late AirPollutionCubit _airPollutionCubit;

  @override
  void initState() {
    super.initState();

    _cubit = Injector.instance();

    _appCubit = Injector.instance();

    _airPollutionCubit = Injector.instance();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.only(top: 30.h, bottom: 30.h),
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        constraints: BoxConstraints(maxHeight: 400.h),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: BlocBuilder<AirCompareCubit, AirCompareState>(
            bloc: _cubit,
            builder: (context, state) {
              return _getCompareDialogContent(state);
            }),
      ),
    );
  }

  Widget _getCompareDialogContent(AirCompareState state) {
    switch (state) {
      case AirCompareInitial():
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocProvider.value(
              value: _appCubit,
              child: AirCompareSearchBar(
                onSelected: (name) => _cubit.searchByName(name),
              ),
            ),
            _buildInitContent()
          ],
        );

      case AirCompareLoading():
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocProvider.value(
                value: _appCubit,
                child: AirCompareSearchBar(
                    onSelected: (name) => _cubit.searchByName(name))),
            Gap(12.h),
            _buildLoading()
          ],
        );

      case AirCompareSuccess():
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocProvider.value(
                value: _appCubit,
                child: AirCompareSearchBar(
                    onSelected: (name) => _cubit.searchByName(name))),
            Gap(12.h),
            _buildCompareContent()
          ],
        );

      case AirCompareFailed():
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocProvider.value(
                value: _appCubit,
                child: AirCompareSearchBar(
                    onSelected: (name) => _cubit.searchByName(name))),
            Gap(12.h),
            _buildError()
          ],
        );
    }
  }

  Widget _buildInitContent() {
    return SizedBox(
      height: 250.h,
      child: Center(
        child: Text(
          'Search something',
          style: TextStyle(
              color: Colors.grey, fontSize: 20.w, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
        child: SizedBox(
      width: 100.w,
      height: 300.w,
      child:
          LoadingAnimationWidget.dotsTriangle(color: Colors.orange, size: 50.w),
    ));
  }

  Widget _buildError() {
    return const Expanded(
        child: Center(
      child: Text('Cannot load data'),
    ));
  }

  Widget _buildCompareContent() {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildCurrentAirData(),
            Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: const VerticalDivider(
                width: 15,
              ),
            ),
            _buildComparedAirData(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentAirData() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.42,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
                '${_airPollutionCubit.address.pronvice}, ${_airPollutionCubit.address.country}',
                style: TextStyle(fontSize: 17.5.w, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis),
          ),
          Gap(10.h),
          Text(
            'Quality: ${PollutantMessage.getPollutantMessage(_airPollutionCubit.airQualityIndex)}',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 16.w),
          ),
          Gap(6.h),
          Text(
            'SO2: ${_airPollutionCubit.airEntity.so2} ${AppUnits.contamitantUnit}',
            style: TextStyle(
                color: Utils.getBackgroundColor(
                    'SO2',
                    convertConcentrationToDouble(
                        _airPollutionCubit.airEntity.so2)),
                fontWeight: FontWeight.w400,
                fontSize: 16.w),
          ),
          Gap(6.h),
          Text(
            'NO2: ${_airPollutionCubit.airEntity.no2} ${AppUnits.contamitantUnit}',
            style: TextStyle(
                color: Utils.getBackgroundColor(
                    'NO2',
                    convertConcentrationToDouble(
                        _airPollutionCubit.airEntity.no2)),
                fontWeight: FontWeight.w400,
                fontSize: 16.w),
          ),
          Gap(6.h),
          Text(
            'PM10: ${_airPollutionCubit.airEntity.pm10} ${AppUnits.contamitantUnit}',
            style: TextStyle(
                color: Utils.getBackgroundColor(
                    'PM10',
                    convertConcentrationToDouble(
                        _airPollutionCubit.airEntity.pm10)),
                fontWeight: FontWeight.w400,
                fontSize: 16.w),
          ),
          Gap(6.h),
          Text(
            'PM2.5: ${_airPollutionCubit.airEntity.pm2_5} ${AppUnits.contamitantUnit}',
            style: TextStyle(
                color: Utils.getBackgroundColor(
                    'PM2.5',
                    convertConcentrationToDouble(
                        _airPollutionCubit.airEntity.pm2_5)),
                fontWeight: FontWeight.w400,
                fontSize: 16.w),
          ),
          Gap(6.h),
          Text(
            'O3: ${_airPollutionCubit.airEntity.o3} ${AppUnits.contamitantUnit}',
            style: TextStyle(
                color: Utils.getBackgroundColor(
                    'O3',
                    convertConcentrationToDouble(
                        _airPollutionCubit.airEntity.o3)),
                fontWeight: FontWeight.w400,
                fontSize: 16.w),
          ),
          Gap(6.h),
          Text(
            'CO: ${_airPollutionCubit.airEntity.co} ${AppUnits.contamitantUnit}',
            style: TextStyle(
                color: Utils.getBackgroundColor(
                    'CO',
                    convertConcentrationToDouble(
                        _airPollutionCubit.airEntity.co)),
                fontWeight: FontWeight.w400,
                fontSize: 16.w),
          ),
          Gap(10.h),
        ],
      ),
    );
  }

  Widget _buildComparedAirData() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.42,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Text('${_cubit.address.pronvice}, ${_cubit.address.country}',
                style: TextStyle(fontSize: 17.5.w, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis),
          ),
          Gap(10.h),
          Text(
            'Quality: ${PollutantMessage.getPollutantMessage(_cubit.airQualityIndex)}',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 16.w),
          ),
          Gap(6.h),
          Text(
            'SO2: ${_cubit.airEntity.so2} ${AppUnits.contamitantUnit}',
            style: TextStyle(
                color: Utils.getBackgroundColor(
                    'SO2', convertConcentrationToDouble(_cubit.airEntity.so2)),
                fontWeight: FontWeight.w400,
                fontSize: 16.w),
          ),
          Gap(6.h),
          Text(
            'NO2: ${_cubit.airEntity.no2} ${AppUnits.contamitantUnit}',
            style: TextStyle(
                color: Utils.getBackgroundColor(
                    'NO2', convertConcentrationToDouble(_cubit.airEntity.no2)),
                fontWeight: FontWeight.w400,
                fontSize: 16.w),
          ),
          Gap(6.h),
          Text(
            'PM10: ${_cubit.airEntity.pm10} ${AppUnits.contamitantUnit}',
            style: TextStyle(
                color: Utils.getBackgroundColor('PM10',
                    convertConcentrationToDouble(_cubit.airEntity.pm10)),
                fontWeight: FontWeight.w400,
                fontSize: 16.w),
          ),
          Gap(6.h),
          Text(
            'PM2.5: ${_cubit.airEntity.pm2_5} ${AppUnits.contamitantUnit}',
            style: TextStyle(
                color: Utils.getBackgroundColor('PM2.5',
                    convertConcentrationToDouble(_cubit.airEntity.pm2_5)),
                fontWeight: FontWeight.w400,
                fontSize: 16.w),
          ),
          Gap(6.h),
          Text(
            'O3: ${_cubit.airEntity.o3} ${AppUnits.contamitantUnit}',
            style: TextStyle(
                color: Utils.getBackgroundColor(
                    'O3', convertConcentrationToDouble(_cubit.airEntity.o3)),
                fontWeight: FontWeight.w400,
                fontSize: 16.w),
          ),
          Gap(6.h),
          Text(
            'CO: ${_cubit.airEntity.co} ${AppUnits.contamitantUnit}',
            style: TextStyle(
                color: Utils.getBackgroundColor(
                    'CO', convertConcentrationToDouble(_cubit.airEntity.co)),
                fontWeight: FontWeight.w400,
                fontSize: 16.w),
          ),
          Gap(10.h),
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
}
