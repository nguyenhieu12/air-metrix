import 'package:envi_metrix/core/themes/app_colors.dart';
import 'package:envi_metrix/features/air_pollution/presentation/cubits/air_pollution_cubit.dart';
import 'package:envi_metrix/features/app/cubits/app_cubit.dart';
import 'package:envi_metrix/injector/injector.dart';
import 'package:envi_metrix/services/location/user_location.dart';
import 'package:envi_metrix/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';

class LocationSearchBar extends StatefulWidget {
  const LocationSearchBar({super.key, required this.airPollutionCubit});

  final AirPollutionCubit airPollutionCubit;

  @override
  State<LocationSearchBar> createState() => _LocationSearchBarState();
}

class _LocationSearchBarState extends State<LocationSearchBar> {
  late AppCubit _cubit;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _longController = TextEditingController();
  final UserLocation userLocation = UserLocation();

  final FocusNode _searchBarFocus = FocusNode();

  bool isFocused = false;

  double? lat;
  double? long;

  @override
  void initState() {
    super.initState();
    _searchBarFocus.addListener(() {
      setState(() {
        isFocused = !isFocused;
      });
    });

    _cubit = Injector.instance();
  }

  @override
  void dispose() {
    super.dispose();
    _searchBarFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(left: 10.w, right: 15.w),
        child: Row(
          children: [
            SizedBox(
              width: 285.w,
              // child: Autocomplete<Map<String, dynamic>>(
              //     optionsBuilder: (TextEditingValue textEditingValue) {
              //   if (textEditingValue.text == '') {
              //     return const Iterable<Map<String, dynamic>>.empty();
              //   }

              //   return _cubit.cityData.where((element) {
              //     return element
              //         .containsKey(textEditingValue.text.toUpperCase());
              //   });
              // })),

              child: TextFormField(
                controller: _searchController,
                focusNode: _searchBarFocus,
                cursorColor: AppColors.searchBarCursor,
                style: TextStyle(fontSize: 20.w),
                cursorHeight: 22.h,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      fontSize: 19.w,
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 5.w),
                      child: Icon(
                        Icons.search,
                        size: 25.w,
                      ),
                    ),
                    suffixIcon: _buildSuffixIcon(context),
                    enabledBorder: _getBorder(AppColors.searchBarBorder, 20),
                    focusedBorder:
                        _getBorder(AppColors.searchBarBorderFocused, 20)),
              ),
            ),
            Gap(10.w),
            Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 110, 255),
                  borderRadius: BorderRadius.circular(40)),
              child: GestureDetector(
                onTap: () => _handleGetUserLocation(),
                child: Icon(
                  Icons.my_location,
                  size: 24.w,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSuffixIcon(BuildContext context) {
    return isFocused
        ? Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: GestureDetector(
              onTap: () => _searchController.clear(),
              child: Icon(
                Icons.clear,
                size: 25.w,
              ),
            ),
          )
        : Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: GestureDetector(
              onTap: () => showCoordinatesInput(context),
              child: Icon(
                Icons.add_location_alt_outlined,
                size: 25.w,
              ),
            ),
          );
  }

  void showCoordinatesInput(BuildContext context) {
    showDialog(
        barrierColor: Colors.grey.withOpacity(0.6),
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            contentPadding: EdgeInsets.only(left: 15.w, right: 15.w),
            content: Container(
              width: 450.w,
              height: 200.h,
              decoration: const BoxDecoration(borderRadius: BorderRadius.zero),
              child: Stack(
                children: [
                  _buildCloseIcon(context),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Gap(10.h),
                      Text(
                        'Enter coordinates',
                        style: TextStyle(
                            fontSize: 20.w, fontWeight: FontWeight.w500),
                      ),
                      Gap(25.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildInputSection(
                              controller: _latController,
                              label: 'Latitude',
                              hintText:
                                  lat != null ? lat.toString() : '21.031087',
                              key: 'lat'),
                          Gap(10.w),
                          _buildInputSection(
                              controller: _longController,
                              label: 'Longitude',
                              hintText:
                                  long != null ? long.toString() : '105.825827',
                              key: 'long')
                        ],
                      ),
                      Gap(25.h),
                      _buildSearchButton(context),
                      Gap(15.h)
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget _buildCloseIcon(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Align(
        alignment: Alignment.topRight,
        child: GestureDetector(
            onTap: () => Navigator.pop(context, [lat, long]),
            child: Icon(
              Icons.clear_rounded,
              size: 24.w,
              color: Colors.black,
            )),
      ),
    );
  }

  Widget _buildInputSection(
      {required TextEditingController controller,
      required String label,
      required String hintText,
      required String key}) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: EdgeInsets.only(left: 6.w, right: 6.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: label,
                  style:
                      TextStyle(fontSize: 16.w, color: AppColors.textDefault)),
              WidgetSpan(
                  child: SizedBox(
                width: 6.w,
              )),
              TextSpan(
                  text: '*',
                  style: TextStyle(fontSize: 16.w, color: AppColors.textError))
            ])),
            Gap(5.h),
            TextField(
              controller: controller,
              onChanged: (value) => key == 'lat'
                  ? lat = double.parse(value)
                  : long = double.parse(value),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,6}')),
              ],
              decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(fontSize: 14.w),
                  enabledBorder:
                      _getBorder(AppColors.searchCoordinatesUnfocus, 10),
                  focusedBorder:
                      _getBorder(AppColors.searchCoordinatesBorder, 10),
                  contentPadding: EdgeInsets.zero,
                  prefix: SizedBox(width: 8.w)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSearchButton(BuildContext context) {
    return InkWell(
      onTap: () => _handleSearchByCoordinates(context),
      child: Container(
        width: 100.w,
        decoration: BoxDecoration(
            color: AppColors.searchButton,
            borderRadius: BorderRadius.circular(30)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 8.h),
          child: Center(
              child: Text(
            'Search',
            style: TextStyle(color: AppColors.textWhite, fontSize: 16.w),
          )),
        ),
      ),
    );
  }

  OutlineInputBorder _getBorder(Color borderColor, double borderRadius) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: borderColor, width: 1.5),
    );
  }

  void _handleSearchByCoordinates(BuildContext context) async {
    if (lat != null && long != null) {
      await widget.airPollutionCubit.fetchAirPollutionData(lat!, long!);
      _searchBarFocus.unfocus();
      // ignore: use_build_context_synchronously
      Navigator.pop(context, [lat, long]);
    }
  }

  Future<void> _handleGetUserLocation() async {
    if (await userLocation.isAccepted()) {
      Position currentPosition = await Utils.getUserLocation();

      widget.airPollutionCubit.fetchAirPollutionData(
          currentPosition.latitude, currentPosition.longitude);
    }
  }
}
