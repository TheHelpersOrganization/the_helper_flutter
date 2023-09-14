import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/search_bar/river_debounce_search_bar.dart';
import 'package:the_helper/src/features/news/domain/news_query.dart';
import 'package:the_helper/src/features/news/presentation/news_list/controller/news_list_mod_controller.dart';

class OrganizationNewsListAppBar extends ConsumerWidget {
  const OrganizationNewsListAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showSearchBox = ref.watch(showSearchBoxProvider);
    ref.watch(searchPatternProvider);
    final sort = ref.watch(sortProvider);

    return SliverAppBar(
      leading: showSearchBox
          ? BackButton(
              onPressed: () =>
                  ref.read(showSearchBoxProvider.notifier).state = false,
            )
          : null,
      title: showSearchBox
          ? RiverDebounceSearchBar.autoDispose(
              provider: searchPatternProvider,
              small: true,
            )
          : const Text(
              'Organization News',
            ),
      floating: true,
      actions: !showSearchBox
          ? [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  ref.read(showSearchBoxProvider.notifier).state = true;
                },
              ),
              PopupMenuButton(
                icon: const Icon(Icons.sort),
                position: PopupMenuPosition.under,
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
            ]
          : null,
    );
  }
}
