import 'package:envi_metrix/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DisasterSymbolDialog extends StatefulWidget {
  const DisasterSymbolDialog({super.key});

  @override
  State<DisasterSymbolDialog> createState() => _DisasterSymbolDialogState();
}

class _DisasterSymbolDialogState extends State<DisasterSymbolDialog> {
  final Map<String, String> listSymbol = {
    'drought': 'Drought',
    'dustHaze': 'Dust and haze',
    'earthquakes': 'Earthquake',
    'floods': 'Flood',
    'landslides': 'Landslide',
    'seaLakeIce': 'Sea and Lake Ice',
    'severeStorms': 'Severe Storm',
    'snow': 'Snow',
    'tempExtremes': 'High Temperature',
    'volcanoes': 'Volcano',
    'wildfires': 'Wildfire'
  };

  @override
  Widget build(BuildContext context) {
    return _buildDisasterListSymbol();
  }

  Widget _buildDisasterListSymbol() {
    return AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      content: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Gap(10.h),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 50.w),
                  child: Text(
                    'Disaster symbols',
                    style: TextStyle(
                        fontSize: 20.w,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textDefault),
                  ),
                ),
                Gap(10.w),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.clear_outlined,
                    color: Colors.black,
                    size: 22.w,
                  ),
                )
              ],
            ),
            Gap(20.h),
            Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [_buildListSymbol(), Gap(15.w), _buildListName()],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildListSymbol() {
    List<Widget> symbols = [];

    for (var symbol in listSymbol.keys) {
      symbols.add(
        Image.asset(
          './assets/icons/${symbol}_icon.png',
          width: 33.w,
          height: 33.w,
        ),
      );

      symbols.add(Gap(16.5.h));
    }

    return Column(
      children: [...symbols],
    );
  }

  Widget _buildListName() {
    List<Widget> names = [];

    for (var name in listSymbol.values) {
      name == 'Drought' ? names.add(Gap(8.h)) : names.add(const SizedBox());
      names.add(Text(
        name,
        style: TextStyle(
            color: AppColors.textDefault,
            fontSize: 16.2.w,
            fontWeight: FontWeight.w400),
      ));
      names.add(
        Gap(25.5.h),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [...names],
    );
  }
}
