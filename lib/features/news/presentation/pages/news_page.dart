import 'package:envi_metrix/features/news/presentation/cubits/news_cubit.dart';
import 'package:envi_metrix/features/news/presentation/widgets/news_unit_tile.dart';
import 'package:envi_metrix/injector/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

    initNewsData();
    
  }

  void initNewsData() {
    newsCubit = Injector.instance();

    newsCubit.getNewsData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsCubit, NewsState>(
        bloc: newsCubit,
        builder: (context, state) {
          if (state is NewsLoading) {
            return _buildNewsLoading();
          } else if (state is NewsSuccess) {
            return _buildNewsContent(state);
          } else {
            return _buildNewsError();
          }
        });
  }

  Widget _buildNewsLoading() {
    return Container();
  }

  Widget _buildNewsError() {
    return Container();
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
                  content: state.listNewsEntity[index].content
                ),
          )),
    );
  }
}
