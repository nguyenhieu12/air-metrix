import 'package:envi_metrix/screens/image_360_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class Image360Dialog extends StatefulWidget {
  const Image360Dialog({super.key});

  @override
  State<Image360Dialog> createState() => _ArDialogState();
}

class _ArDialogState extends State<Image360Dialog> {
  bool isPollutionSelected = true;
  final String airPollutionImagePath = './assets/images/air_pollution.png';
  final String airFreshImagePath = './assets/images/air_fresh.png';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.only(top: 30.h, bottom: 30.h),
      contentPadding: EdgeInsets.zero,
      content: Container(
        height: 475.h,
        width: MediaQuery.of(context).size.width * 0.95,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            _buildCloseIcon(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(10),
                Text(
                  'Choose mode',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 19.w),
                ),
                Gap(20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildOption(
                        optionName: 'Pollution',
                        imagePath: airPollutionImagePath,
                        selected: isPollutionSelected,
                        isLeft: true),
                    _buildOption(
                        optionName: 'Fresh',
                        imagePath: airFreshImagePath,
                        selected: !isPollutionSelected,
                        isLeft: false)
                  ],
                ),
                Gap(30.h),
                _buildChooseButton()
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCloseIcon() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Align(
        alignment: Alignment.topRight,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.clear,
            color: Colors.black,
            size: 24.w,
          ),
        ),
      ),
    );
  }

  Widget _buildOption(
      {required String optionName,
      required String imagePath,
      required bool selected,
      required bool isLeft}) {
    return Padding(
      padding:
          EdgeInsets.only(left: isLeft ? 15.w : 0, right: isLeft ? 0 : 15.w),
      child: SizedBox(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            optionName,
            style: TextStyle(fontSize: 17.w),
          ),
          Gap(6.h),
          GestureDetector(
            onTap: () {
              setState(() {
                isPollutionSelected = !isPollutionSelected;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  color:
                      selected ? Colors.green.withOpacity(0.75) : Colors.white,
                  borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: EdgeInsets.only(
                    top: 10.h, bottom: 10.h, left: 15.w, right: 15.w),
                child: Column(
                  children: [
                    Container(
                      width: 120.w,
                      height: 250.h,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(imagePath), fit: BoxFit.cover)),
                    ),
                    Gap(10.h),
                    _buildTick(isSelected: selected)
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }

  Widget _buildTick({required bool isSelected}) {
    return isSelected ? Container(
      width: 30.w,
      height: 30.w,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(100)),
      child: const Icon(
        Icons.check,
        color: Colors.green,
      ),
    ) : SizedBox(
      width: 30.w,
      height: 30.w,
    );
  }

  Widget _buildChooseButton() {
    return ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Image360Screen(
                      imagePath: isPollutionSelected
                          ? airPollutionImagePath
                          : airFreshImagePath)));
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        child: Text(
          'Choose',
          style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: 18.w, color: Colors.white),
        ));
  }
}
