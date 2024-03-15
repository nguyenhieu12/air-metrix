import 'package:flutter/material.dart';

class WatchlistItem extends StatefulWidget {
  const WatchlistItem(
      {super.key,
      required this.locationName,
      required this.airQuality,
      required this.backgroundColor,
      required this.imagePath,
      required this.lat,
      required this.long});

  final String locationName;
  final String airQuality;
  final Color backgroundColor;
  final String imagePath;
  final double lat;
  final double long;

  @override
  State<WatchlistItem> createState() => _WatchlistItemState();
}

class _WatchlistItemState extends State<WatchlistItem> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
