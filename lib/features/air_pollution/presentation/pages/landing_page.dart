import 'package:envi_metrix/features/air_pollution/presentation/pages/air_pollution_page.dart';
import 'package:envi_metrix/features/air_pollution/presentation/pages/dashboard_page.dart';
import 'package:envi_metrix/features/disaster/presentation/pages/disaster_page.dart';
import 'package:envi_metrix/services/tab_change/tab_change_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LandingPage extends StatelessWidget {
  LandingPage({super.key});

  List<Widget> pages = const [
    // DashboardPage(),
    AirPollutionPage(),
    DisasterPage()
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TabChangeCubit>(
        create: (context) => TabChangeCubit(),
        child: Scaffold(
          body: IndexedStack(
            index: context.watch<TabChangeCubit>().state,
            children: [...pages],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: context.watch<TabChangeCubit>().state,
            onTap: (value) => context.read<TabChangeCubit>().changeTab(value),
            items: const [
              // BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.air), label: 'Air Pollution'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.sync_lock), label: 'Disaster'),
            ],
          ),
        ));
  }
}
