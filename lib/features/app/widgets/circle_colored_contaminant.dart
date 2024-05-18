import 'package:flutter/material.dart';

class CircleColoredContaminant extends StatelessWidget {
  const CircleColoredContaminant(
      {super.key,
      required this.contaminantName,
      required this.backgroundColor,
      required this.circleSize,
      required this.textSize});

  final String contaminantName;
  final Color backgroundColor;
  final double circleSize;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: circleSize,
      height: circleSize,
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Colors.white, width: 1.0)),
      child: Center(
        child: DefaultTextStyle(
          style: TextStyle(
              fontSize: textSize,
              color: Colors.white,
              fontWeight: FontWeight.w700),
          child: Text(contaminantName),
        ),
      ),
    );
  }
}
