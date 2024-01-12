import 'package:envi_metrix/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class InternetSnackbar {
  static void showInternetNotifiSnackbar(
      {required BuildContext context,
      required String message,
      required Icon icon,
      required Color backgroundColor,
      required Duration duration,
      required bool displayCloseIcon}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      showCloseIcon: displayCloseIcon,
      closeIconColor: AppColors.snackbarIcon,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: Row(
        children: [
          icon,
          Gap(16.w),
          Text(
            message,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18.w,
                color: Colors.white),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: duration,
    ));
  }
}
