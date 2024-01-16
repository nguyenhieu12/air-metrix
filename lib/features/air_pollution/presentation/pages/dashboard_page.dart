import 'package:envi_metrix/core/connection/internet_cubit.dart';
import 'package:envi_metrix/core/themes/app_colors.dart';
import 'package:envi_metrix/widgets/internet_snackbar.dart';
import 'package:envi_metrix/widgets/location_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<InternetCubit, InternetState>(
        listener: (context, state) {
          _handleShowSnackbar(context, state);
        },
        builder: (context, state) {
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: Text(
                    state is InternetConnected ? 'Connected' : 'Disconnected',
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Center(
                  child: IconButton(
                    onPressed: () => _handleShowSnackbar(context, state),
                    icon: Icon(Icons.smart_display),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleShowSnackbar(BuildContext context, InternetState internetState) {
    if (internetState is InternetDisconnected) {
      InternetSnackbar.showInternetNotifiSnackbar(
          context: context,
          message: 'Lost Internet connection',
          icon: Icon(Icons.wifi_off, size: 24.w, color: AppColors.snackbarIcon),
          backgroundColor: Colors.red,
          duration: const Duration(days: 365),
          displayCloseIcon: true);
    } else if (internetState is InternetConnected) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      InternetSnackbar.showInternetNotifiSnackbar(
          context: context,
          message: 'Internet connection restored',
          icon: Icon(Icons.wifi, size: 24.w, color: AppColors.snackbarIcon),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
          displayCloseIcon: false);
    } else {
      return;
    }
  }
}
