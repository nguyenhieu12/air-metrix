import 'package:envi_metrix/features/news/presentation/pages/article_page.dart';
import 'package:envi_metrix/utils/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class NewsUnitTile extends StatelessWidget {
  const NewsUnitTile(
      {super.key,
      required this.title,
      required this.description,
      required this.urlToImage,
      required this.publishedAt,
      required this.content});

  final String? title;
  final String? description;
  final String? urlToImage;
  final String? publishedAt;
  final String? content;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context, rootNavigator: true)
          .push(PageTransition.slideTransition(ArticlePage(
        title: title,
        description: description,
        urlToImage: urlToImage,
        publishedAt: publishedAt,
        content: content,
      ))),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: 100.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                    image: NetworkImage(urlToImage ?? ''), fit: BoxFit.cover),
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(0, 0),
                      color: Colors.grey,
                      blurRadius: 0.75)
                ]),
            
          ),
          Gap(10.w),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? '',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16.w),
                ),
                Gap(3.h),
                Text(
                  title ?? '',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.75),
                      fontWeight: FontWeight.w400,
                      fontSize: 12.w),
                ),
                Gap(4.h),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 20,
                    ),
                    Gap(6.w),
                    Text(
                      convertStringToFormattedDateTime(),
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.8),
                          fontWeight: FontWeight.w400,
                          fontSize: 14.w),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  String convertStringToFormattedDateTime() {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    DateTime dateTime = dateFormat.parse(publishedAt ?? '');

    return DateFormat('dd/MM/yyyy').format(dateTime);
  }
}
