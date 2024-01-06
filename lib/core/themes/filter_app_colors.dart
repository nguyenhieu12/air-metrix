import 'package:flutter/material.dart';

import 'package:envi_metrix/core/themes/app_colors.dart';

class FilterAppColors {
  static Color getAQIColor(int pollutionValue) {
    switch (pollutionValue) {
      case 1:
        return AppColors.goodAQI;
      case 2:
        return AppColors.fairAQI;
      case 3:
        return AppColors.moderateAQI;
      case 4:
        return AppColors.poorAQI;
      case 5:
        return AppColors.veryPoorAQI;
      default:
        return AppColors.goodAQI;
    }
  }
}
