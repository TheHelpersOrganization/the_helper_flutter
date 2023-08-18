import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletons/skeletons.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/news/presentation/common/widget/large_news_card.dart';
import 'package:the_helper/src/features/news/presentation/news_list/controller/news_list_volunteer_controller.dart';

class PopularNewsList extends ConsumerWidget {
  const PopularNewsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsState = ref.watch(popularNewsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Popular News',
            style: context.theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 330,
            child: newsState.when(
              loading: () => SkeletonListView(),
              error: (_, __) => Text(_.toString()),
              data: (news) => ListView(
                scrollDirection: Axis.horizontal,
                children: news.map((n) => LargeNewsCard(news: n)).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
