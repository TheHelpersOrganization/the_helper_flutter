import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/extension/widget.dart';
import 'package:the_helper/src/common/widget/search_bar/river_debounce_search_bar.dart';
import 'package:the_helper/src/features/news/domain/news_query.dart';
import 'package:the_helper/src/features/news/presentation/organization_news_list/controller/organization_news_list_controller.dart';

class OrganizationNewsListAppBar extends ConsumerWidget {
  const OrganizationNewsListAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showSearchBox = ref.watch(showSearchBoxProvider);
    ref.watch(searchPatternProvider);
    final isPublished = ref.watch(isPublishedProvider);
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
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              FilterChip(
                label: const Text('All'),
                selected: isPublished == null,
                onSelected: (value) {
                  if (value) {
                    ref.read(isPublishedProvider.notifier).state = null;
                  }
                },
              ),
              FilterChip(
                label: const Text('Published'),
                selected: isPublished == true,
                onSelected: (value) {
                  if (value) {
                    ref.read(isPublishedProvider.notifier).state = true;
                  }
                },
              ),
              FilterChip(
                label: const Text('Draft'),
                selected: isPublished == false,
                onSelected: (value) {
                  if (value) {
                    ref.read(isPublishedProvider.notifier).state = false;
                  }
                },
              ),
              const Spacer(),
            ].sizedBoxSpacing(const SizedBox(width: 8)),
          ),
        ),
      ),
    );
  }
}
