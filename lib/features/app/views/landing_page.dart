import 'package:envi_metrix/features/air_pollution/presentation/pages/air_pollution_page.dart';
import 'package:envi_metrix/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:envi_metrix/features/disaster/presentation/pages/disaster_page.dart';
import 'package:envi_metrix/features/app/views/chatbot_page.dart';
import 'package:envi_metrix/features/news/presentation/pages/news_page.dart';
import 'package:envi_metrix/services/tab_change/tab_change_cubit.dart';
import 'package:envi_metrix/utils/page_transition.dart';
import 'package:floating_draggable_widget/floating_draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  List<Widget> pages = const [
    DashboardPage(),
    AirPollutionPage(),
    NewsPage(),
    DisasterPage()
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TabChangeCubit>(
      create: (context) => TabChangeCubit(),
      child: FloatingDraggableWidget(
        autoAlign: true,
        mainScreenWidget: Scaffold(
          body: IndexedStack(
            index: context.watch<TabChangeCubit>().state,
            children: [...pages],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: const Offset(0, 0),
                  spreadRadius: 0.75,
                  blurRadius: 0)
            ]),
            child: GNav(
              backgroundColor: Colors.white,
              tabBorderRadius: 30,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              gap: 10,
              padding: EdgeInsets.only(top: 15.w, bottom: 15.w),
              tabs: [
                GButton(
                  icon: Icons.dashboard,
                  text: 'Dashboard',
                  textStyle: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.w),
                ),
                GButton(
                  icon: Icons.air,
                  text: 'Air quality',
                  textStyle: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.w),
                ),
                GButton(
                  icon: Icons.article_outlined,
                  text: 'News',
                  textStyle: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.w),
                ),
                GButton(
                  icon: Icons.map,
                  text: 'Map',
                  textStyle: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.w),
                ),
              ],
              onTabChange: (index) =>
                  context.read<TabChangeCubit>().changeTab(index),
            ),
          ),
        ),
        floatingWidget: _buildChatbotButton(),
        floatingWidgetWidth: 54.w,
        floatingWidgetHeight: 54.w,
        dx: 10.w,
        dy: 580.h,
      ),
    );
  }

  Widget _buildChatbotButton() {
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .push(PageTransition.slideTransition(const ChatbotPage())),
      child: Container(
        decoration: BoxDecoration(
            image: const DecorationImage(
                image: AssetImage(
                  './assets/images/gemini_ai.png',
                ),
                fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}
