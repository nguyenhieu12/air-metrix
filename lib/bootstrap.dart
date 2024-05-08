import 'dart:async';

import 'package:envi_metrix/core/connection/internet_cubit.dart';
import 'package:envi_metrix/core/keys/app_keys.dart';
import 'package:envi_metrix/features/app/cubits/app_cubit.dart';
import 'package:envi_metrix/features/app/pages/landing_page.dart';
import 'package:envi_metrix/injector/injector.dart';
import 'package:envi_metrix/services/notification/notification_service.dart';
import 'package:envi_metrix/services/tab_change/tab_change_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> bootstrap() async {
  await runZonedGuarded(() async {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    await Injector.init();

    await Injector.instance.allReady();

    await ScreenUtil.ensureScreenSize();

    Gemini.init(apiKey: AppKeys.geminiApiKey);

    await Injector.instance<AppCubit>().initCityData();

    await NotificationService().initNotification();

    await NotificationService()
        .scheduleNotification(title: 'Test', body: 'Here is notifi');

    FlutterNativeSplash.remove();

    runApp(const MyApp());
  }, (error, stack) {
    if (kDebugMode) {
      print(error);
      print(stack);
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        builder: (context, child) => MaterialApp(
              debugShowCheckedModeBanner: false,
              home: MultiBlocProvider(
                providers: [
                  BlocProvider<InternetCubit>(
                      create: (context) => InternetCubit()),
                  BlocProvider<TabChangeCubit>(
                      create: (context) => TabChangeCubit()),
                ],
                child: const LandingPage(),
              ),
            ));
  }
}
