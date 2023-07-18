import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/activity/domain/activity_status.dart';

//Widgets
import 'package:the_helper/src/features/activity/presentation/admin_manage/widgets/activity_list.dart';

import '../../../../../common/widget/drawer/app_drawer.dart';
import '../../../../../common/widget/search_bar/debounce_search_bar.dart';
import '../controllers/activity_manage_screen_controller.dart';

//Screens

const List<Tab> tabs = <Tab>[
  Tab(text: 'Ongoing'),
  Tab(text: 'Pendding'),
  Tab(text: 'Completed'),
  Tab(text: 'Cancelled'),
];

class AdminActivityManageScreen extends ConsumerWidget {
  const AdminActivityManageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSearching = ref.watch(isSearchingProvider);

    return Scaffold(
      drawer: const AppDrawer(),
      body: DefaultTabController(
        length: tabs.length,
        child: NestedScrollView(
          headerSliverBuilder: (_, __) => [
            SliverAppBar(
              centerTitle: true,
              title: const Text(
                'Activity manage',
              ),
              floating: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    ref.read(isSearchingProvider.notifier).state = !isSearching;
                  },
                ),
              ],
            ),
            if (isSearching)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: DebounceSearchBar(
                    hintText: 'Search accounts',
                    debounceDuration: const Duration(seconds: 1),
                    small: true,
                    onDebounce: (value) {
                      ref.read(searchPatternProvider.notifier).state =
                          value.trim().isNotEmpty ? value.trim() : null;
                    },
                    onClear: () {
                      ref.read(searchPatternProvider.notifier).state = null;
                    },
                  ),
                ),
              ),
            SliverToBoxAdapter(
                child: TabBar(
              labelColor: Theme.of(context).colorScheme.onSurface,
              tabs: tabs,
            )),
          ],
          body: const TabBarView(
            children: [
              CustomScrollList(tabIndex: [ActivityStatus.ongoing]),
              CustomScrollList(tabIndex: [ActivityStatus.pending]),
              CustomScrollList(tabIndex: [ActivityStatus.completed]),
              CustomScrollList(tabIndex: [ActivityStatus.cancelled]),
            ]),
        ),
      ),
    );
  }
}