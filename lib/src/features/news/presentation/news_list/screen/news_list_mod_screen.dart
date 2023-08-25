import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/features/news/presentation/news_list/widget/moderator/app_bar/organization_news_list_app_bar.dart';
import 'package:the_helper/src/features/news/presentation/news_list/widget/moderator/organization_news_list.dart';
import 'package:the_helper/src/router/router.dart';

class NewsListModScreen extends StatelessWidget {
  const NewsListModScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: const CustomScrollView(
        slivers: [
          OrganizationNewsListAppBar(),
          SliverPadding(
            padding: EdgeInsets.all(12),
            sliver: OrganizationNewsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.goNamed(AppRoute.newsCreate.name);
        },
        icon: const Icon(Icons.add),
        label: const Text('News'),
      ),
    );
  }
}
