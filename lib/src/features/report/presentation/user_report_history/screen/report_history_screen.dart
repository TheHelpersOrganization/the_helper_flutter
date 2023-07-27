import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Widgets
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/features/report/presentation/user_report_history/widget/sort_modal.dart';

import '../../../../../common/widget/search_bar/debounce_search_bar.dart';
import '../../../domain/report_query.dart';
import '../controller/report_history_screen_controller.dart';
import '../widget/custom_list.dart';

//Screens

const List<Tab> tabs = <Tab>[
  Tab(text: 'Account'),
  Tab(text: 'Organization'),
  Tab(text: 'Activity'),
];

const List<Widget> tabViews = <Widget>[
  CustomScrollList(tabIndex: ReportType.account),
  CustomScrollList(tabIndex: ReportType.organization),
  CustomScrollList(tabIndex: ReportType.activity),
];

class ReportHistoryScreen extends ConsumerWidget {
  const ReportHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSearching = ref.watch(isSearchingProvider);
    final isPendding = ref.watch(penddingStatusProvider);
    final isReviewing = ref.watch(reviewingStatusProvider);
    final isRejected = ref.watch(rejectStatusProvider);
    final isCompleted = ref.watch(completedStatusProvider);
    final byDate = ref.watch(sortBySendDateProvider);
    final byNewest = ref.watch(sortByNewestProvider);

    return Scaffold(
      drawer: const AppDrawer(),
      body: DefaultTabController(
        length: tabs.length,
        child: NestedScrollView(
          headerSliverBuilder: (_, __) => [
            SliverAppBar(
              centerTitle: true,
              title: isSearching
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: DebounceSearchBar(
                        hintText: 'Search report requests',
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
                    )
                  : const Text(
                      'Report history',
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
            SliverToBoxAdapter(
                child: TabBar(
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
                              showModalBottomSheet(
                                  context: context, builder: (context)
                                  => SortOptionModal(
                                    byDate: byDate,
                                    byNewest: byNewest,
                                  ));
                            },
                            icon: const Icon(Icons.sort))
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        FilterChip(
                          label: const Text('Pending'),
                          onSelected: (value) {
                            ref.read(penddingStatusProvider.notifier).state =
                                value;
                          },
                          selected: isPendding,
                        ),
                        const SizedBox(width: 12),
                        FilterChip(
                          label: const Text('Reviewing'),
                          onSelected: (value) {
                            ref.read(reviewingStatusProvider.notifier).state =
                                value;
                          },
                          selected: isReviewing,
                        ),
                        const SizedBox(width: 12),
                        FilterChip(
                          label: const Text('Rejected'),
                          onSelected: (value) {
                            ref.read(rejectStatusProvider.notifier).state =
                                value;
                          },
                          selected: isRejected,
                        ),
                        const SizedBox(width: 12),
                        FilterChip(
                          label: const Text('Completed'),
                          onSelected: (value) {
                            ref.read(completedStatusProvider.notifier).state =
                                value;
                          },
                          selected: isCompleted,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(
                      height: 0,
                    ),
                  ],
                ),
              ),
            ),
          ],
          body: const TabBarView(children: tabViews),
        ),
      ),
    );
  }
}
