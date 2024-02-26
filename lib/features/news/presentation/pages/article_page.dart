import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage(
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article'),
        centerTitle: true,
        shadowColor: Colors.black,
        // leading: Icon(Icons.),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 10.w, right: 10.w),
          child: Column(
            children: [
              Gap(10.w),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      title ?? '',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 20.w),
                    ),
                  ),
                ],
              ),
              Gap(12.w),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      description ?? '',
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.75),
                          fontWeight: FontWeight.w400,
                          fontSize: 15.w),
                    ),
                  ),
                ],
              ),
              Gap(12.w),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.95,
                child: Image.network(urlToImage ?? ''),
              ),
              SafeArea(
                child: Markdown(
                  data: content ?? '',
                  styleSheet: MarkdownStyleSheet(
                      p: TextStyle(
                    fontSize: 17.w,
                  )),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
