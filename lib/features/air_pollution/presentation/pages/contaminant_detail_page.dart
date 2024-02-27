import 'dart:io';

import 'package:envi_metrix/core/constraints/air_pollution_color.dart';
import 'package:envi_metrix/core/constraints/air_pollution_thresholds.dart';
import 'package:envi_metrix/core/themes/app_colors.dart';
import 'package:envi_metrix/features/air_pollution/presentation/cubits/contaminant_detail_cubit.dart';
import 'package:envi_metrix/utils/global_variables.dart';
import 'package:envi_metrix/utils/styles.dart';
import 'package:envi_metrix/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class ContaminantDetail extends StatefulWidget {
  final String tagName;
  final String cotaminantName;
  final double pollutantValue;
  final Color mainColor;

  const ContaminantDetail(
      {super.key,
      required this.tagName,
      required this.cotaminantName,
      required this.pollutantValue,
      required this.mainColor});

  @override
  State<ContaminantDetail> createState() => _ContaminantDetailState();
}

class _ContaminantDetailState extends State<ContaminantDetail> {
  late List<double> pointValue;
  late List<Color> colorBar;
  late String markdownDetailData;
  final ContaminantDetailCubit _cubit = ContaminantDetailCubit();

  @override
  void initState() {
    super.initState();
    pointValue = getContaminantThreshold(widget.cotaminantName);
    colorBar = AirPollutionColor.pollutionColor;

    _cubit.getContaminantDetailInfo(widget.cotaminantName);
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.tagName,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 50.h),
          child: AppBar(
            elevation: 0.5,
            shadowColor: Colors.black,
            backgroundColor: Colors.white,
            leading: Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 26.w,
                  )),
            ),
            title: Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Text(
                widget.cotaminantName,
                style: TextStyle(
                    fontSize: 22.w,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
            ),
            centerTitle: true,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            _buildOverviewSection(),
            Gap(12.h),
            Center(
              child: _buildColorBarSection(),
            ),
            Gap(12.h),
            _buildRadialGaugeSection(),
            Gap(30.h),
            _buildDetailInformation()
          ]),
        ),
      ),
    );
  }

  Widget _buildDetailInformation() {
    return SizedBox(
      width: 400.w,
      child: BlocBuilder<ContaminantDetailCubit, ContaminantDetailState>(
          bloc: _cubit,
          builder: ((context, state) {
            if (state is ContaminantDetailLoading) {
              return _buildDetailInformationLoading();
            } else if (state is ContaminantDetailSuccess) {
              return _buildDetailInformationData(state.outputText);
            } else {
              return _buildDetailInformationError();
            }
          })),
    );
  }

  Widget _buildDetailInformationData(String data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: Text(
            'Harmful effects & prevention',
            style: headerTextStyle,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h),
          child: Card(
            elevation: 1,
            shadowColor: Colors.grey,
            child: Markdown(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                styleSheet: MarkdownStyleSheet(
                    textAlign: WrapAlignment.spaceEvenly,
                    p: TextStyle(
                      fontSize: 16.5.w,
                    )),
                data: data),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailInformationLoading() {
    return Center(
        child: Platform.isAndroid
            ? CircularProgressIndicator(
                color: AppColors.loading, strokeWidth: 2.0)
            : CupertinoActivityIndicator(color: AppColors.loading));
  }

  Widget _buildDetailInformationError() {
    return Container();
  }

  Widget _buildRadialGaugeSection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          Text(
            'Gauge',
            style: headerTextStyle.copyWith(fontSize: 18.w),
          ),
          Gap(10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedRadialGauge(
                duration: const Duration(seconds: 3),
                curve: Curves.elasticOut,
                radius: 130,
                value: widget.pollutantValue,
                axis: GaugeAxis(
                    pointer: const GaugePointer.triangle(
                        width: 5,
                        height: 100,
                        borderRadius: 1,
                        color: Colors.black,
                        position: GaugePointerPosition(
                            anchor: GaugePointerAnchor.center,
                            offset: Offset(1, 1))),
                    min: 0,
                    max: pointValue[pointValue.length - 1] * 1.5,
                    degrees: 180,
                    progressBar:
                        const GaugeProgressBar.basic(color: Colors.transparent),
                    segments: [
                      for (int i = 0; i < pointValue.length - 1; i++)
                        GaugeSegment(
                            from: pointValue[i],
                            to: pointValue[i + 1],
                            color: colorBar[i]),
                      GaugeSegment(
                          from: pointValue[pointValue.length - 1],
                          to: pointValue[pointValue.length - 1] * 1.5,
                          color: colorBar[colorBar.length - 1])
                    ]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewSection() {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(6.h),
          Text(
            'Overview',
            style: headerTextStyle,
          ),
          Gap(6.h),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                      color: widget.mainColor,
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    children: [
                      Gap(6.h),
                      Text(
                        'Concentration',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.5.w,
                            fontWeight: FontWeight.w700),
                      ),
                      Gap(6.h),
                      Text(
                        '${widget.pollutantValue} ${AppUnits.contamitantUnit}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.w,
                            fontWeight: FontWeight.w500),
                      ),
                      Gap(6.h),
                    ],
                  ),
                ),
              ),
              Gap(15.w),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                      color: widget.mainColor,
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    children: [
                      Gap(6.h),
                      Text(
                        'Quality',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.5.w,
                            fontWeight: FontWeight.w700),
                      ),
                      Gap(6.h),
                      Text(
                        Utils.getPollutionMessage(
                            widget.cotaminantName, widget.pollutantValue),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.w,
                            fontWeight: FontWeight.w500),
                      ),
                      Gap(6.h),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildColorBarSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: Text(
            'Pollution level',
            style: headerTextStyle,
          ),
        ),
        Gap(8.h),
        _buildColorBar(),
        _buildPointValue(),
      ],
    );
  }

  Widget _buildColorBar() {
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
    return Padding(
      padding: EdgeInsets.only(left: 8.w, right: 15.w),
      child: Row(
        children: [
          for (int i = 0; i < pointValue.length; i++)
            Expanded(
                flex: 1,
                child: Text(
                  pointValue[i].toString(),
                  style: TextStyle(fontSize: 15.w),
                ))
        ],
      ),
    );
  }

  List<double> getContaminantThreshold(String contaminantName) {
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
