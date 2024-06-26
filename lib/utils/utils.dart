import 'package:envi_metrix/core/connection/internet_cubit.dart';
import 'package:envi_metrix/core/constraints/air_pollution_thresholds.dart';
import 'package:envi_metrix/core/themes/app_colors.dart';
import 'package:envi_metrix/core/themes/filter_app_colors.dart';
import 'package:envi_metrix/features/watchlist/pages/watchlist_page.dart';
import 'package:envi_metrix/utils/global_variables.dart';
import 'package:envi_metrix/utils/page_transition.dart';
import 'package:envi_metrix/widgets/air_compare_dialog.dart';
import 'package:envi_metrix/widgets/ar_dialog.dart';
import 'package:envi_metrix/widgets/internet_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';

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

  static Future<Position> getUserLocation() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  static void showAnimationDialog(
      {required BuildContext context,
      required Offset begin,
      required Offset end,
      required Widget child}) {
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
          content: child,
        );
      },
    );
  }

  static void showInternetNotifySnackbar(
      BuildContext context, InternetState internetState) {
    if (internetState is InternetDisconnected) {
      InternetSnackbar.showInternetNotifiSnackbar(
          context: context,
          message: 'Lost Internet connection',
          icon: Icon(Icons.wifi_off, size: 24.w, color: AppColors.snackbarIcon),
          backgroundColor: Colors.red,
          duration: const Duration(days: 365),
          displayCloseIcon: true);
    } else if (internetState is InternetConnected) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      InternetSnackbar.showInternetNotifiSnackbar(
          context: context,
          message: 'Internet connection restored',
          icon: Icon(Icons.wifi, size: 24.w, color: AppColors.snackbarIcon),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
          displayCloseIcon: false);
    } else {
      return;
    }
  }

  static void showShareErrorSnackbar(
      BuildContext context, InternetState internetState) {
    InternetSnackbar.showInternetNotifiSnackbar(
        context: context,
        message: 'Lost Internet connection',
        icon: Icon(Icons.wifi_off, size: 24.w, color: AppColors.snackbarIcon),
        backgroundColor: Colors.red,
        duration: const Duration(milliseconds: 1500),
        displayCloseIcon: true);
  }

  static void showArSelectionDialog(
      {required BuildContext context, required ArSelectionDialog child}) {
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  static void showAirCompareDialog(
      {required BuildContext context, required AirCompareDialog child}) {
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  static void showWatchlist({required BuildContext context}) {
    Navigator.of(context)
        .push(PageTransition.slideTransition(const WatchlistPage()));
  }
}
