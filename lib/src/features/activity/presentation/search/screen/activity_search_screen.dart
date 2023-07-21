import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/common/widget/search_bar/debounce_search_bar.dart';
import 'package:the_helper/src/features/activity/presentation/search/controller/activity_controller.dart';
import 'package:the_helper/src/features/activity/presentation/search/controller/activity_filter_controller.dart';
import 'package:the_helper/src/features/activity/presentation/search/widget/activity_filter/activity_filter_drawer.dart';
import 'package:the_helper/src/features/activity/presentation/search/widget/sliver_activity_list.dart';
import 'package:the_helper/src/features/activity/presentation/search/widget/sliver_activity_suggestion_list.dart';
import 'package:the_helper/src/router/router.dart';

class ActivitySearchScreen extends ConsumerWidget {
  const ActivitySearchScreen({super.key});

  _buildDefaultView(BuildContext context) {
    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Activities you may interest',
                    style: context.theme.textTheme.titleMedium,
                  ),
                  TextButton(
                    onPressed: () {
                      context.pushNamed(AppRoute.activitySuggestion.name);
                    },
                    child: const Text(
                      'See more',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      const SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        sliver: SliverActivitySuggestionList(),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 48,
              ),
              Text(
                'More Activities',
                style: context.theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      const SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        sliver: SliverActivityList(),
      ),
    ];
  }

  _buildSearchView(
    BuildContext context,
    String searchPattern,
    bool hasSearchQuery,
    bool hasQuery,
    VoidCallback onClearFilter,
  ) {
    final sp = searchPattern.isEmpty ? '' : ' for "$searchPattern"';
    final wq = hasQuery ? ' with applied filter' : '';
    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'Search results$sp$wq',
                    style: context.theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (hasQuery || hasSearchQuery)
                    TextButton(
                      onPressed: onClearFilter,
                      child: const Text(
                        'Clear filter',
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
      const SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        sliver: SliverActivityList(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showSearch = ref.watch(showSearchProvider);
    final searchPattern = ref.watch(searchPatternProvider);
    final activityQuery = ref.watch(activityQueryProvider);

    return Scaffold(
      drawer: const AppDrawer(),
      endDrawer: const ActivityFilterDrawer(),
      body: Builder(
        builder: (context) => CustomScrollView(
          slivers: [
            SliverAppBar(
              toolbarHeight: kToolbarHeight + 12,
              floating: true,
              leading: showSearch
                  ? BackButton(
                      onPressed: () {
                        ref.read(showSearchProvider.notifier).state = false;
                      },
                    )
                  : null,
              title: showSearch
                  ? DebounceSearchBar(
                      initialValue: searchPattern,
                      debounceDuration: const Duration(seconds: 1),
                      onDebounce: (value) {
                        ref.read(searchPatternProvider.notifier).state = value;
                      },
                      onClear: () {
                        ref.read(searchPatternProvider.notifier).state = '';
                      },
                    )
                  : const Text('Search Activities'),
              actions: [
                if (!showSearch)
                  IconButton(
                    onPressed: () {
                      ref.read(showSearchProvider.notifier).state = true;
                    },
                    icon: const Icon(Icons.search_outlined),
                  ),
                IconButton(
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: const Icon(
                    Icons.filter_list_outlined,
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
            const SliverPadding(padding: EdgeInsets.symmetric(vertical: 12)),
            if (searchPattern.trim() == '' && activityQuery == null)
              ..._buildDefaultView(context)
            else
              ..._buildSearchView(
                context,
                searchPattern,
                searchPattern.trim() != '',
                activityQuery != null,
                () {
                  ref.read(searchPatternProvider.notifier).state = '';
                  ref.read(showSearchProvider.notifier).state = false;

                  ref.invalidate(activityQueryProvider);
                  ref.read(isMarkedToResetProvider.notifier).state = false;
                },
              ),
          ],
        ),
      ),
    );
  }
}
