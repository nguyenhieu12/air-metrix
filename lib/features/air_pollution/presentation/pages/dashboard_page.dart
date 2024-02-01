import 'package:envi_metrix/core/connection/internet_cubit.dart';
import 'package:envi_metrix/core/themes/app_colors.dart';
import 'package:envi_metrix/utils/utils.dart';
import 'package:envi_metrix/widgets/internet_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          Utils.ShowInternetNotifySnackbar(context, state);
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
                    onPressed: () {},
                    // onPressed: () => _handleShowSnackbar(context, state),
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
}
