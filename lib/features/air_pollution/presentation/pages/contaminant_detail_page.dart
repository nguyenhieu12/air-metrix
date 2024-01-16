import 'package:envi_metrix/core/constraints/air_pollution_color.dart';
import 'package:envi_metrix/core/constraints/air_pollution_thresholds.dart';
import 'package:envi_metrix/core/themes/app_colors.dart';
import 'package:envi_metrix/utils/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContaminantDetail extends StatelessWidget {
  final String tagName;
  final String cotaminantName;
  final double pollutantValue;
  final Color mainColor;

  const ContaminantDetail(
      {required this.tagName,
      required this.cotaminantName,
      required this.pollutantValue,
      required this.mainColor});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tagName,
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, 50.h),
            child: AppBar(
              backgroundColor: mainColor,
              leading: Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppColors.whiteIcon,
                      size: 26.w,
                    )),
              ),
              title: Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Text(
                  'Thông tin chi tiết',
                  style: TextStyle(
                      fontSize: 22.w,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textWhite),
                ),
              ),
              centerTitle: true,
            ),
          ),
          body: Center(
            child: _buildColorBarSection(),
          ),
        ),
      ),
    );
  }

  Widget _buildColorBarSection() {
    return Column(
      children: [_buildColorBar(), _buildPointValue()],
    );
  }

  Widget _buildColorBar() {
    List<Color> colorBar = AirPollutionColor.pollutionColor;

    return Padding(
      padding: EdgeInsets.only(left: 15.w, right: 15.w),
      child: Container(
        height: 10.h,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            for (int i = 0; i < colorBar.length; i++)
              Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorBar[i],
                      borderRadius: (i == 0
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20))
                          : i == colorBar.length - 1
                              ? const BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20))
                              : null),
                    ),
                  ))
          ],
        ),
      ),
    );
  }

  Widget _buildPointValue() {
    List<int> pointValue = getCommonMessage(cotaminantName);

    return Padding(
      padding: EdgeInsets.only(left: 8.w, right: 15.w),
      child: Row(
        children: [
          for (int i = 0; i < pointValue.length; i++)
            Expanded(flex: 1, child: Text(pointValue[i].toString(), style: TextStyle(
              fontSize: 15.w
            ),))
        ],
      ),
    );
  }

  List<int> getCommonMessage(String contaminantName) {
    switch (contaminantName) {
      case PollutantName.so2:
        return AirPollutionThresholds.so2Threshold;
      case PollutantName.no2:
        return AirPollutionThresholds.no2Threshold;
      case PollutantName.pm10:
        return AirPollutionThresholds.pm10Threshold;
      case PollutantName.pm25:
        return AirPollutionThresholds.pm25Threshold;
      case PollutantName.o3:
        return AirPollutionThresholds.o3Threshold;
      case PollutantName.co:
        return AirPollutionThresholds.coThreshold;
      default:
        return AirPollutionThresholds.so2Threshold;
    }
  }

  
}
