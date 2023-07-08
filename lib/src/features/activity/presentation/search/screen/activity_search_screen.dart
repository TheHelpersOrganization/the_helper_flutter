import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/button/notification_button.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/features/activity/presentation/search/controller/activity_controller.dart';
import 'package:the_helper/src/features/activity/presentation/search/widget/activity_filter_drawer.dart';
import 'package:the_helper/src/features/activity/presentation/search/widget/sliver_activity_list.dart';
import 'package:the_helper/src/features/activity/presentation/search/widget/sliver_activity_suggestion_list.dart';
import 'package:the_helper/src/features/activity/presentation/search/widget/sliver_persistent_search_bar.dart';

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
                    onPressed: () {},
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

  _buildSearchView(BuildContext context, String searchPattern) {
    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Search results for "$searchPattern"',
                style: context.theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
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
    final searchPattern = ref.watch(searchPatternProvider);

    return Scaffold(
      drawer: const AppDrawer(),
      endDrawer: const ActivityFilterDrawer(),
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            floating: true,
            title: Text('Search Activities'),
            centerTitle: true,
            actions: [
              NotificationButton(),
            ],
          ),
          const SliverPersistentHeader(
            pinned: true,
            delegate: SliverPersistentSearchBar(),
          ),
          if (searchPattern.trim() == '')
            ..._buildDefaultView(context)
          else
            ..._buildSearchView(context, searchPattern),
        ],
      ),
    );
  }
}
