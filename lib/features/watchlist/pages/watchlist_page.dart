import 'package:envi_metrix/features/watchlist/cubits/watchlist_cubit.dart';
import 'package:envi_metrix/features/watchlist/widgets/watchlist_item.dart';
import 'package:envi_metrix/injector/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  late WatchlistCubit _cubit;

  @override
  void initState() {
    super.initState();

    _cubit = Injector.instance();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<WatchlistCubit, WatchlistState>(
        bloc: _cubit,
        builder: (context, state) {
          if (state is WatchlistSuccess) {
            return _buildWatchlistContent();
          } else {
            return _buildEmptyElement();
          }
        },
      ),
    );
  }

  Widget _buildWatchlistContent() {
    return _cubit.watchlistItems.isEmpty
        ? _buildEmptyElement()
        : _buildListElement();
  }

  Widget _buildListElement() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text(
          'Watchlist',
          style: TextStyle(
              fontSize: 22.w, color: Colors.white, fontWeight: FontWeight.w500),
        ),
        leading: Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 28.w,
            ),
          ),
        ),
      ),
      body: ListView.builder(
          itemCount: _cubit.watchlistItems.length,
          itemBuilder: (context, index) {
            final item = _cubit.watchlistItems[index];

            return Slidable(
              endActionPane:
                  ActionPane(motion: const StretchMotion(), children: [
                SlidableAction(
                  // onPressed: (context) => _cubit.removeItem(index: index),
                  onPressed: (context) {},
                  backgroundColor: Colors.red,
                  icon: Icons.delete,
                  label: 'Delete',
                )
              ]),
              child: _buildItemContent(item: item),
            );
          }),
    );
  }

  Widget _buildItemContent({required WatchlistItem item}) {
    return Padding(
      padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 15.h),
      child: Container(
        // width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0.5, 0.5),
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 0.5,
                  spreadRadius: 1.5),
              BoxShadow(
                  offset: const Offset(0, 0),
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 0.5,
                  spreadRadius: 0.5),
            ]),
        child: Row(
          children: [
            Gap(10.w),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 26.w,
                        color: item.backgroundColor,
                      ),
                      Flexible(
                        child: Text(
                          item.locationName,
                          style: TextStyle(
                              color: item.backgroundColor,
                              fontSize: 22.w,
                              fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Gap(10.h),
                  Padding(
                    padding: EdgeInsets.only(left: 5.w),
                    child: Text(
                      'Quality: ${item.airQuality}',
                      style: TextStyle(
                        color: item.backgroundColor,
                        fontSize: 21.w,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Gap(20.w),
            SizedBox(
              width: 105.w,
              height: 105.w,
              child: Image.asset(
                item.imagePath,
                fit: BoxFit.cover,
              ),
            )
          ],
        ),
      ),
    );

    // return Container(
    //   width: 200.w,
    //   height: 150.w,
    //   color: Colors.red,
    // );
  }

  Widget _buildEmptyElement() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text(
          'Watchlist',
          style: TextStyle(
              fontSize: 22.w, color: Colors.white, fontWeight: FontWeight.w500),
        ),
        leading: Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 28.w,
            ),
          ),
        ),
      ),
      body: Center(
        child: Text(
          'Watchlist is empty!',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w400, fontSize: 20.w),
        ),
      ),
    );
  }

  // String getQualityImagePath({required WatchlistItem item}) {
  //   if (item.airQuality == 1) {
  //     return './assets/images/good_aqi.png';
  //   } else if (item.airQuality == 2) {
  //     return './assets/images/moderate_aqi.png';
  //   } else if (item.airQuality == 3) {
  //     return './assets/images/unhealthy_aqi.png';
  //   } else if (item.airQuality == 4) {
  //     return './assets/images/very_unhealthy_aqi.png';
  //   } else {
  //     return './assets/images/hazardous_aqi.png';
  //   }
  // }
}
