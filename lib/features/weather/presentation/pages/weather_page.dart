import 'package:envi_metrix/services/time_converter/time_converter.dart';
import 'package:flutter/material.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(TimeConverter.getCurrentHourTimestamp().toString()),
    );
  }
}