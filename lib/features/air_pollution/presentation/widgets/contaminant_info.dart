import 'package:envi_metrix/core/constraints/air_pollution_thresholds.dart';
import 'package:envi_metrix/utils/global_variables.dart';
import 'package:envi_metrix/core/themes/app_colors.dart';
import 'package:envi_metrix/core/themes/filter_app_colors.dart';
import 'package:envi_metrix/features/air_pollution/presentation/pages/contaminant_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ContaminantInfo extends StatelessWidget {
  final String contamunantName;
  final double concentration;

  const ContaminantInfo(
      {super.key, required this.contamunantName, required this.concentration});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: contamunantName,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: getBackgroundColor(contamunantName, concentration),
        ),
        width: 165.w,
        child: GestureDetector(
          onTap: () => Navigator.push(
              context,
              PageRouteBuilder(
                  pageBuilder: (_, __, ___) => ContaminantDetail(
                      tagName: contamunantName,
                      cotaminantName: contamunantName,
                      pollutantValue: concentration,
                      mainColor: getBackgroundColor(contamunantName, concentration)),
                  transitionDuration: const Duration(seconds: 1))),
          child: Padding(
            padding: EdgeInsets.only(left: 10.w, right: 10.w),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Gap(8.h),
                  Text(
                    contamunantName,
                    style: TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 24.w,
                        fontWeight: FontWeight.w700),
                  ),
                  Gap(12.h),
                  Text('$concentration ${AppUnits.contamitantUnit}',
                      style: TextStyle(
                          color: AppColors.textWhite,
                          fontSize: 20.w,
                          fontWeight: FontWeight.w500)),
                  Text(getPollutionMessage(contamunantName, concentration),
                      style: TextStyle(
                          color: AppColors.textWhite,
                          fontSize: 20.w,
                          fontWeight: FontWeight.w500))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color getBackgroundColor(String name, double pollutantValue) {
    switch (name) {
      case PollutantName.so2:
        return FilterAppColors.getAQIColor(
            AirPollutionThresholds.getSO2Threshold(pollutantValue));
      case PollutantName.no2:
        return FilterAppColors.getAQIColor(
            AirPollutionThresholds.getNO2Threshold(pollutantValue));
      case PollutantName.pm10:
        return FilterAppColors.getAQIColor(
            AirPollutionThresholds.getPM10Threshold(pollutantValue));
      case PollutantName.pm25:
        return FilterAppColors.getAQIColor(
            AirPollutionThresholds.getPM25Threshold(pollutantValue));
      case PollutantName.o3:
        return FilterAppColors.getAQIColor(
            AirPollutionThresholds.getO3Threshold(pollutantValue));
      case PollutantName.co:
        return FilterAppColors.getAQIColor(
            AirPollutionThresholds.getCOThreshold(pollutantValue));
      default:
        return AppColors.goodAQI;
    }
  }

  String getPollutionMessage(String name, double pollutantValue) {
    switch (name) {
      case PollutantName.so2:
        return AirPollutionThresholds.getSO2Message(pollutantValue);
      case PollutantName.no2:
        return AirPollutionThresholds.getNO2Message(pollutantValue);
      case PollutantName.pm10:
        return AirPollutionThresholds.getPM10Message(pollutantValue);
      case PollutantName.pm25:
        return AirPollutionThresholds.getPM25Message(pollutantValue);
      case PollutantName.o3:
        return AirPollutionThresholds.getO3Message(pollutantValue);
      case PollutantName.co:
        return AirPollutionThresholds.getCOMessage(pollutantValue);
      default:
        return AirPollutionThresholds.getSO2Message(pollutantValue);
    }
  }
}
