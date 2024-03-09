import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Image360Screen extends StatefulWidget {
  const Image360Screen({super.key, required this.imagePath});

  final String imagePath;

  @override
  State<Image360Screen> createState() => _Image360ScreenState();
}

class _Image360ScreenState extends State<Image360Screen> {
  @override
  Widget build(BuildContext context) {
    // return Panorama(child: Image.asset('./assets/images/air_pollution.png'),);
    // return Stack(children: [
    //   _buildCloseButton(context: context),
    //   Panorama(
    //     child: Image.asset(widget.imagePath),
    //   )
    // ]);
    return Container();
  }

  Widget _buildCloseButton({required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, top: 30.h),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(100)),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
