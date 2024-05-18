import 'package:envi_metrix/core/connection/internet_cubit.dart';
import 'package:envi_metrix/features/app/pages/landing_page.dart';
import 'package:envi_metrix/features/app/widgets/circle_colored_contaminant.dart';
import 'package:envi_metrix/injector/injector.dart';
import 'package:envi_metrix/utils/global_variables.dart';
import 'package:envi_metrix/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({super.key});

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  late InternetCubit internetCubit;

  @override
  void initState() {
    super.initState();

    internetCubit = Injector.instance();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InternetCubit, InternetState>(
      listenWhen: (previous, current) =>
          current is InternetConnected || current is InternetDisconnected,
      listener: (context, state) {
        Utils.showInternetNotifySnackbar(context, state);
      },
      builder: (context, state) {
        return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    './assets/images/air_pollution_background.png',
                  ),
                  fit: BoxFit.fitHeight,
                  opacity: 0.60),
            ),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Positioned(
                    top: 60,
                    left: 280,
                    child: CircleColoredContaminant(
                        contaminantName: PollutantName.so2,
                        backgroundColor: Colors.orange,
                        circleSize: 38.w,
                        textSize: 12.5.w)),
                Positioned(
                    top: 150,
                    left: 100,
                    child: CircleColoredContaminant(
                        contaminantName: PollutantName.pm10,
                        backgroundColor: Colors.purple,
                        circleSize: 65.w,
                        textSize: 16.w)),
                Positioned(
                    top: 250,
                    left: 300,
                    child: CircleColoredContaminant(
                        contaminantName: PollutantName.co,
                        backgroundColor: const Color.fromARGB(255, 7, 220, 14),
                        circleSize: 45.w,
                        textSize: 16.w)),
                Positioned(
                    top: 550,
                    left: 300,
                    child: CircleColoredContaminant(
                        contaminantName: PollutantName.pm25,
                        backgroundColor: Colors.red,
                        circleSize: 60.w,
                        textSize: 15.w)),
                Positioned(
                    top: 650,
                    left: 150,
                    child: CircleColoredContaminant(
                        contaminantName: PollutantName.o3,
                        backgroundColor: Colors.blue,
                        circleSize: 55.w,
                        textSize: 20.w)),
                Positioned(
                    top: 520,
                    left: 60,
                    child: CircleColoredContaminant(
                        contaminantName: PollutantName.no2,
                        backgroundColor: Colors.yellow.shade700,
                        circleSize: 45.w,
                        textSize: 15.w)),
                Positioned(
                  bottom: 50,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DefaultTextStyle(
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 28.w),
                        child: const Text('Welcome to AirMetrix!'),
                      ),
                      Gap(10.h),
                      DefaultTextStyle(
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.80),
                            fontWeight: FontWeight.w400,
                            fontSize: 15.w),
                        child: const Text(
                            'Monitor air quality information around you now'),
                      ),
                      Gap(250.h),
                      GestureDetector(
                        onTap: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                    value: internetCubit,
                                    child: const LandingPage(),
                                  )));

                          SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();

                          bool? isFirstTimeShowIntro =
                              sharedPreferences.getBool('introShowed');

                          if (isFirstTimeShowIntro == null) {
                            sharedPreferences.setBool('introShowed', true);
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 50,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 0, 189, 6),
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: DefaultTextStyle(
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20.w),
                              child: const Text('Let\'s start'),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ));
      },
    );
  }
}
