import 'package:flutter/material.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/features/news/presentation/news_list/widget/latest_news_list.dart';
import 'package:the_helper/src/features/news/presentation/news_list/widget/news_list_app_bar.dart';
import 'package:the_helper/src/features/news/presentation/news_list/widget/popular_news_list.dart';

class NewsListScreen extends StatelessWidget {
  const NewsListScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      drawer: AppDrawer(),
      body: CustomScrollView(
        slivers: [
          NewsListAppBar(),
          SliverPadding(padding: EdgeInsets.only(top: 24)),
          SliverToBoxAdapter(
            child: PopularNewsList(),
          ),
          LatestNewsList(),
        ],
      ),
    );
  }
}
