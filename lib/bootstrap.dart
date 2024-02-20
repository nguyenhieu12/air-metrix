import 'dart:async';

import 'package:envi_metrix/core/connection/internet_cubit.dart';
import 'package:envi_metrix/core/keys/app_keys.dart';
import 'package:envi_metrix/features/landing/views/landing_page.dart';
import 'package:envi_metrix/injector/injector.dart';
import 'package:envi_metrix/services/tab_change/tab_change_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

Future<void> bootstrap() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    Injector.init();

    await Injector.instance.allReady();

    await ScreenUtil.ensureScreenSize();

    Gemini.init(apiKey: AppKeys.geminiApiKey);

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
