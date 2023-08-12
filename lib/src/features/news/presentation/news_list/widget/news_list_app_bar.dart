import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/search_bar/river_debounce_search_bar.dart';
import 'package:the_helper/src/features/news/domain/news_query.dart';
import 'package:the_helper/src/features/news/presentation/news_list/controller/news_list_controller.dart';

class NewsListAppBar extends ConsumerWidget {
  const NewsListAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showSearchBox = ref.watch(showSearchBoxProvider);
    final sort = ref.watch(sortProvider);

    return SliverAppBar(
      leading: showSearchBox
          ? BackButton(onPressed: () {
              ref.read(showSearchBoxProvider.notifier).state = !showSearchBox;
            })
          : null,
      title: showSearchBox
          ? RiverDebounceSearchBar.autoDispose(
              provider: searchPatternProvider,
              debounceDuration: const Duration(seconds: 1),
              small: true,
            )
          : const Text('News'),
      floating: true,
      actions: showSearchBox
          ? null
          : [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  ref.read(showSearchBoxProvider.notifier).state =
                      !showSearchBox;
                },
              ),
              PopupMenuButton(
                icon: const Icon(Icons.sort),
                onSelected: (value) {
                  ref.read(sortProvider.notifier).state = value;
                },
                itemBuilder: (context) => [
                  NewsQuerySort.dateDesc,
                  NewsQuerySort.popularityDesc,
                  NewsQuerySort.viewsDesc
                ]
                    .map(
                      (item) => PopupMenuItem(
                        value: item,
                        child: Text(
                          'Sort by ${item.substring(1)}',
                          style: TextStyle(
                            color: sort == item
                                ? context.theme.primaryColor
                                : null,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
      // bottom: PreferredSize(
      //   preferredSize: const Size.fromHeight(64),
      //   child: Row(
      //     children: [
      //       PopupMenuButton(
      //         icon: const Icon(
      //           Icons.sort_outlined,
      //         ),
      //         itemBuilder: (context) => [
      //           const PopupMenuItem(
      //             value: NewsQuerySort.dateDesc,
      //             child: Text('Sort by date'),
      //           ),
      //           const PopupMenuItem(
      //             value: NewsQuerySort.viewsDesc,
      //             child: Text('Sort by views'),
      //           ),
      //         ],
      //       ),
      //     ],
      //   ),
      //),
    );
  }
}
