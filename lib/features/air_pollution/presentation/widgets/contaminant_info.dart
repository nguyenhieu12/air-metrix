import 'package:envi_metrix/core/constraints/air_pollution_thresholds.dart';
import 'package:envi_metrix/core/themes/app_colors.dart';
import 'package:envi_metrix/core/themes/filter_app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContaminantInfo extends StatelessWidget {
  final String contamunantName;
  final double concentration;

  const ContaminantInfo(
      {super.key, required this.contamunantName, required this.concentration});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130.w,
      color: getBackgroundColor(contamunantName, concentration),
      child: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              contamunantName,
              style: TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 24.w,
                  fontWeight: FontWeight.w900),
            ),
            Text(concentration.toString(),
                style: TextStyle(color: AppColors.textWhite, fontSize: 16.w, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Color getBackgroundColor(String name, double pollutantValue) {
    switch (name) {
      case 'SO2':
        return FilterAppColors.getAQIColor(
            AirPollutionThresholds.getSO2Threshold(pollutantValue));
      case 'NO2':
        return FilterAppColors.getAQIColor(
            AirPollutionThresholds.getNO2Threshold(pollutantValue));
      case 'PM10':
        return FilterAppColors.getAQIColor(
            AirPollutionThresholds.getPM10Threshold(pollutantValue));
      case 'PM2.5':
        return FilterAppColors.getAQIColor(
            AirPollutionThresholds.getPM25Threshold(pollutantValue));
      case 'O3':
        return FilterAppColors.getAQIColor(
            AirPollutionThresholds.getO3Threshold(pollutantValue));
      case 'CO':
        return FilterAppColors.getAQIColor(
            AirPollutionThresholds.getCOThreshold(pollutantValue));
      default:
        return AppColors.goodAQI;
    }
  }
}
