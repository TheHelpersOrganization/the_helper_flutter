import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/features/news/presentation/news_list/controller/news_list_controller.dart';
import 'package:the_helper/src/features/news/presentation/news_list/widget/default_news_list.dart';
import 'package:the_helper/src/features/news/presentation/news_list/widget/news_list_app_bar.dart';
import 'package:the_helper/src/features/news/presentation/news_list/widget/popular_news_list.dart';

class NewsListScreen extends ConsumerWidget {
  const NewsListScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchPattern = ref.watch(searchPatternProvider);
    final sort = ref.watch(sortProvider);

    return Scaffold(
      drawer: const AppDrawer(),
      body: CustomScrollView(
        slivers: [
          const NewsListAppBar(),
          const SliverPadding(padding: EdgeInsets.only(top: 24)),
          if (searchPattern.isEmpty && sort == defaultSort)
            const SliverToBoxAdapter(
              child: PopularNewsList(),
            ),
          const DefaultNewsList(),
        ],
      ),
    );
  }
}
