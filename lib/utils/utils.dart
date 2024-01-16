import 'package:envi_metrix/core/constraints/air_pollution_thresholds.dart';
import 'package:envi_metrix/core/themes/app_colors.dart';
import 'package:envi_metrix/core/themes/filter_app_colors.dart';
import 'package:envi_metrix/utils/global_variables.dart';
import 'package:flutter/material.dart';

class Utils {
  static Color getBackgroundColor(String name, double pollutantValue) {
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

  static String getPollutionMessage(String name, double pollutantValue) {
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