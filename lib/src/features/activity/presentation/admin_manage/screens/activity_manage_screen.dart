import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/activity/domain/activity_status.dart';

//Widgets
import 'package:the_helper/src/features/activity/presentation/admin_manage/widgets/activity_list.dart';

import '../../../../../common/widget/drawer/app_drawer.dart';
import '../../../../../common/widget/search_bar/debounce_search_bar.dart';
import '../controllers/activity_manage_screen_controller.dart';
import '../widgets/activity_filter_drawer.dart';

//Screens

const List<Tab> tabs = <Tab>[
  Tab(text: 'Ongoing'),
  Tab(text: 'Pendding'),
  Tab(text: 'Completed'),
  Tab(text: 'Cancelled'),
];

const List<Widget> tabViews = <Widget>[
  CustomScrollList(tabIndex: ActivityStatus.ongoing),
  CustomScrollList(tabIndex: ActivityStatus.pending),
  CustomScrollList(tabIndex: ActivityStatus.completed),
  CustomScrollList(tabIndex: ActivityStatus.cancelled),
];

class AdminActivityManageScreen extends ConsumerWidget {
  const AdminActivityManageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSearching = ref.watch(isSearchingProvider);
    final filterSelected = ref.watch(filterSelectedProvider);
    final banned = ref.watch(isBanned);

    return Scaffold(
      drawer: const AppDrawer(),
      endDrawer: const ActivityFilterDrawer(),
      body: DefaultTabController(
        length: tabs.length,
        child: NestedScrollView(
          headerSliverBuilder: (context, __) => [
            SliverAppBar(
              centerTitle: true,
              title: isSearching
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: DebounceSearchBar(
                        hintText: 'Search reports',
                        debounceDuration: const Duration(seconds: 1),
                        small: true,
                        onDebounce: (value) {
                          ref.read(searchPatternProvider.notifier).state =
                              value.trim().isNotEmpty ? value.trim() : null;
                        },
                        onClear: () {
                          ref.read(searchPatternProvider.notifier).state =
                              null;
                        },
                      ),
                    )
                  : const Text(
                      'Activities manage',
                    ),
              floating: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    ref.read(isSearchingProvider.notifier).state =
                        !isSearching;
                  },
                ),
              ],
              bottom: TabBar(
                isScrollable: true,
                labelColor: Theme.of(context).colorScheme.onSurface,
                tabs: tabs,
              )),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Quick filter',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () {
                            Scaffold.of(context).openEndDrawer();
                          },
                          icon: const Icon(
                            Icons.filter_list_outlined,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        FilterChip(
                          label: const Text('Active'),
                          onSelected: (value) {
                            ref.read(filterSelectedProvider.notifier).state =
                                value;
                            ref.read(isBanned.notifier).state = !value;
                          },
                          selected: filterSelected && !banned,
                        ),
                        const SizedBox(width: 12),
                        FilterChip(
                          label: const Text('Banned'),
                          onSelected: (value) {
                            ref.read(filterSelectedProvider.notifier).state =
                                value;
                            ref.read(isBanned.notifier).state = value;
                          },
                          selected: filterSelected && banned,
                        ),
                      ],
                    ),
                    // const SizedBox(height: 16),
                    // const Divider(
                    //   height: 0,
                    // ),
                  ],
                ),
              ),
            ),
          ],
          body: const TabBarView(
            children: tabViews)
        ),
      ),
    );
  }
}
