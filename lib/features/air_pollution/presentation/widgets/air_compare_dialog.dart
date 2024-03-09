import 'package:envi_metrix/widgets/location_search_bar.dart';
import 'package:flutter/material.dart';

class AirCompareDialog extends StatefulWidget {
  const AirCompareDialog({super.key});

  @override
  State<AirCompareDialog> createState() => _AirCompareDialogState();
}

class _AirCompareDialogState extends State<AirCompareDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // LocationSearchBar()
          ],
        ),
      ),
    );
  }
}