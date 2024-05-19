import 'dart:io';

import 'package:envi_metrix/core/themes/app_colors.dart';
import 'package:envi_metrix/features/news/presentation/cubits/news_cubit.dart';
import 'package:envi_metrix/features/news/presentation/widgets/news_unit_tile.dart';
import 'package:envi_metrix/injector/injector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late NewsCubit newsCubit;

  @override
  void initState() {
    super.initState();

    newsCubit = Injector.instance();

    newsCubit.getNewsData();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => newsCubit.getNewsData(),
      child: BlocBuilder<NewsCubit, NewsState>(
          bloc: newsCubit,
          builder: (context, state) {
            if (state is NewsLoading) {
              return _buildNewsLoading();
            } else if (state is NewsSuccess) {
              return _buildNewsContent(state);
            } else {
              return _buildNewsError();
            }
          }),
    );
  }

  Widget _buildNewsLoading() {
    return Center(
        child: Platform.isAndroid
            ? CircularProgressIndicator(
                color: AppColors.loading, strokeWidth: 2.0)
            : CupertinoActivityIndicator(color: AppColors.loading));
  }

  Widget _buildNewsError() {
    return Center(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            ColorFiltered(
              colorFilter: const ColorFilter.mode(Colors.purple, BlendMode.color),
              child: Image.asset('./assets/icons/news_error_icon.png',
                  width: 75.w, height: 75.w),
            ),
            Gap(8.h),
            Text(
              'Cannot load news data',
              style: TextStyle(
                  fontSize: 19.w,
                  fontWeight: FontWeight.w400,
                  color: Colors.purple),
            ),
            Text(
              'Check your Internet connection',
              style: TextStyle(
                  fontSize: 15.w,
                  fontWeight: FontWeight.w400,
                  color: Colors.purple),
            ),
            Gap(10.h),
            GestureDetector(
              onTap: () => newsCubit.getNewsData(),
              child: Container(
                width: 120.w,
                height: 35.w,
                decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(30)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.refresh,
                      color: Colors.white,
                      size: 22.w,
                    ),
                    Gap(6.w),
                    DefaultTextStyle(
                        style: TextStyle(color: Colors.white, fontSize: 20.w),
                        child: const Text('Reload'))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNewsContent(NewsSuccess state) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 20.h),
      child: ListView.builder(
          itemCount: state.listNewsEntity.length,
          itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(bottom: 15.h),
                child: NewsUnitTile(
                    title: state.listNewsEntity[index].title,
                    description: state.listNewsEntity[index].description,
                    urlToImage: state.listNewsEntity[index].urlToImage,
                    publishedAt: state.listNewsEntity[index].publishedAt,
                    content: state.listNewsEntity[index].content),
              )),
    );
  }
}
