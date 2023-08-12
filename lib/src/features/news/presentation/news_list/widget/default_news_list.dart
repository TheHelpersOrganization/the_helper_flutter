import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/common/widget/no_data_found.dart';
import 'package:the_helper/src/features/news/domain/news.dart';
import 'package:the_helper/src/features/news/presentation/common/widget/news_card.dart';
import 'package:the_helper/src/features/news/presentation/news_list/controller/news_list_controller.dart';

class DefaultNewsList extends ConsumerWidget {
  const DefaultNewsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchPattern = ref.watch(searchPatternProvider);
    final sort = ref.watch(sortProvider);
    final isSearchMode = searchPattern.isNotEmpty || sort != defaultSort;
    final searchQuery1 =
        searchPattern.isNotEmpty ? ' for "$searchPattern"' : '';
    final searchQuery2 = ' sorted by ${sort.substring(1)}';

    return SliverPadding(
      padding:
          EdgeInsets.symmetric(horizontal: 12, vertical: isSearchMode ? 0 : 24),
      sliver: MultiSliver(
        children: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    !isSearchMode
                        ? 'Latest News'
                        : 'Search results$searchQuery1$searchQuery2',
                    style: context.theme.textTheme.titleMedium,
                  ),
                  if (isSearchMode)
                    TextButton(
                      onPressed: () {
                        ref.read(searchPatternProvider.notifier).state = '';
                        ref.read(sortProvider.notifier).state = defaultSort;
                      },
                      child: const Text('Clear filters'),
                    ),
                ],
              ),
            ),
          ),
          RiverPagedBuilder<int, News>.autoDispose(
            firstPageKey: 0,
            provider: newsListPagedNotifierProvider,
            pagedBuilder: (controller, builder) => PagedSliverList(
              pagingController: controller,
              builderDelegate: builder,
            ),
            limit: 20,
            itemBuilder: (context, item, index) => NewsCard(news: item),
            firstPageErrorIndicatorBuilder: (context, controller) {
              return CustomErrorWidget(
                onRetry: () => controller.retryLastFailedRequest(),
              );
            },
            newPageErrorIndicatorBuilder: (context, controller) =>
                CustomErrorWidget(
              onRetry: () => controller.retryLastFailedRequest(),
            ),
            noItemsFoundIndicatorBuilder: (context, _) =>
                const NoDataFound.simple(
              contentTitle: 'No news found',
            ),
          ),
        ],
      ),
    );
  }
}
