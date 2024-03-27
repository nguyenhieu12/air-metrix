import 'package:envi_metrix/services/location/default_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

class MapPollutionPage extends StatefulWidget {
  const MapPollutionPage({super.key});

  @override
  State<MapPollutionPage> createState() => _MapPollutionPageState();
}

class _MapPollutionPageState extends State<MapPollutionPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      FlutterMap(
        options: MapOptions(
            initialCenter: LatLng(DefaultLocation.lat, DefaultLocation.long),
            initialZoom: 3.0),
        children: [
          TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
          TileLayer(
            urlTemplate:
                'https://tiles.aqicn.org/tiles/usepa-aqi/{z}/{x}/{y}.png',
          ),
        ],
      ),
      _buildBackIcon()
    ]);
  }

  Widget _buildBackIcon() {
    return Padding(
      padding: EdgeInsets.only(top: 30.h, left: 18.w),
      child: Align(
        alignment: Alignment.topLeft,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.grey,
                      offset: Offset(1.2, 1.2),
                      blurRadius: 2.0,
                      spreadRadius: 1.0)
                ]),
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 25.w,
            ),
          ),
        ),
      ),
    );
  }
}
