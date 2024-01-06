import 'package:envi_metrix/core/connection/internet_cubit.dart';
import 'package:envi_metrix/services/tab_change/tab_change_cubit.dart';
import 'package:envi_metrix/features/air_pollution/presentation/pages/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        builder: (context, child) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              home: MultiBlocProvider(
                providers: [
                  BlocProvider<InternetCubit>(
                      create: (context) => InternetCubit()),
                  BlocProvider<TabChangeCubit>(
                      create: (context) => TabChangeCubit()),
                ],
                child: LandingPage(),
              ),
            ));
  }
}
