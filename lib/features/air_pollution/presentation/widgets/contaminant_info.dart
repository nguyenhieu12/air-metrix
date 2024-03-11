import 'package:envi_metrix/core/themes/app_colors.dart';
import 'package:envi_metrix/features/air_pollution/presentation/pages/contaminant_detail_page.dart';
import 'package:envi_metrix/utils/global_variables.dart';
import 'package:envi_metrix/utils/page_transition.dart';
import 'package:envi_metrix/utils/utils.dart';
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
          color: Utils.getBackgroundColor(contamunantName, concentration),
        ),
        width: 160.w,
        child: GestureDetector(
          onTap: () => Navigator.of(context, rootNavigator: true).push(
              PageTransition.slideTransition(ContaminantDetail(
                  tagName: contamunantName,
                  cotaminantName: contamunantName,
                  pollutantValue: concentration,
                  mainColor: Utils.getBackgroundColor(
                      contamunantName, concentration)))),
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
                        fontSize: 20.w,
                        fontWeight: FontWeight.w700),
                  ),
                  Gap(6.h),
                  Text('$concentration ${AppUnits.contamitantUnit}',
                      style: TextStyle(
                          color: AppColors.textWhite,
                          fontSize: 17.w,
                          fontWeight: FontWeight.w500)),
                  Text(
                      Utils.getPollutionMessage(contamunantName, concentration),
                      style: TextStyle(
                          color: AppColors.textWhite,
                          fontSize: 17.w,
                          fontWeight: FontWeight.w500)),
                  Gap(8.h)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
