import 'package:envi_metrix/core/tab_change/tab_change_cubit.dart';
import 'package:envi_metrix/features/climate/presentation/pages/air_pollution_page.dart';
import 'package:envi_metrix/features/climate/presentation/pages/dashboard_page.dart';
import 'package:envi_metrix/features/climate/presentation/pages/weather_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LandingPage extends StatelessWidget {
  LandingPage({super.key});

  List<Widget> pages = const [
    DashboardPage(),
    AirPollutionPage(),
    WeatherPage()
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TabChangeCubit>(
      create: (context) => TabChangeCubit(), 
      child: Scaffold(
        body: pages[context.watch<TabChangeCubit>().state],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: context.watch<TabChangeCubit>().state,
          onTap: (value) => context.read<TabChangeCubit>().changeTab(value),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
            BottomNavigationBarItem(icon: Icon(Icons.air), label: 'Air Pollution'),
            BottomNavigationBarItem(icon: Icon(Icons.sync_lock), label: 'Weather'),
          ],
        ),
      )
    );
  }
}