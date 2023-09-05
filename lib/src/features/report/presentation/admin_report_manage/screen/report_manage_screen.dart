import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Widgets
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';


import '../../../../../common/widget/search_bar/debounce_search_bar.dart';
import '../../../domain/report_query_parameter_classes.dart';
import '../controller/report_manage_screen_controller.dart';
import '../widget/custom_list.dart';
import '../widget/sort_modal.dart';


//Screens

const List<Tab> tabs = <Tab>[
  Tab(text: 'Pendding'),
  Tab(text: 'Reviewing'),
  Tab(text: 'Completed'),
  Tab(text: 'Reject'),
];

const List<Widget> tabViews = <Widget>[
  CustomScrollList(tabIndex: ReportStatus.pending),
  CustomScrollList(tabIndex: ReportStatus.reviewing),
  CustomScrollList(tabIndex: ReportStatus.completed),
  CustomScrollList(tabIndex: ReportStatus.rejected),
];

class ReportManageScreen extends ConsumerWidget {
  const ReportManageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSearching = ref.watch(isSearchingProvider);
    final filterAccount = ref.watch(filterAccountProvider);
    final filterOrg = ref.watch(filterOrganizationProvider);
    final filterActivity = ref.watch(filterActivityProvider);
    final filterNews = ref.watch(filterNewsProvider);
    final byDate = ref.watch(sortBySendDateProvider);
    final byNewest = ref.watch(sortByNewestProvider);

    return Scaffold(
      drawer: const AppDrawer(),
      body: DefaultTabController(
        length: tabs.length,
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (_, __) => [
            SliverAppBar(
              pinned: true,
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
                      ref.read(searchPatternProvider.notifier).state = null;
                    },
                  ),
                )
              :const Text(
                'Reports manage',
              ),
              floating: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    ref.read(isSearchingProvider.notifier).state = !isSearching;
                  },
                ),
              ],
              bottom: TabBar(
              labelColor: Theme.of(context).colorScheme.onSurface,
              tabs: tabs,
            ),
            ),
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
                          'Quick filter request type',
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
                    Wrap(
                      children: [
                        FilterChip(
                          label: const Text('Account'),
                          onSelected: (value) {
                            ref.read(filterAccountProvider.notifier).state =
                                value;
                          },
                          selected: filterAccount,
                        ),
                        const SizedBox(width: 12),
                        FilterChip(
                          label: const Text('Organization'),
                          onSelected: (value) {
                            ref.read(filterOrganizationProvider.notifier).state =
                                value;
                          },
                          selected: filterOrg,
                        ),
                        const SizedBox(width: 12),
                        FilterChip(
                          label: const Text('Activity'),
                          onSelected: (value) {
                            ref.read(filterActivityProvider.notifier).state =
                                value;
                          },
                          selected: filterActivity,
                        ),
                        const SizedBox(width: 12),
                        FilterChip(
                          label: const Text('News'),
                          onSelected: (value) {
                            ref.read(filterNewsProvider.notifier).state =
                                value;
                          },
                          selected: filterNews,
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
          body: const TabBarView(
            children: tabViews
            // .map((Widget e) {
            //   return SafeArea(
            //     top: false,
            //     bottom: false,
            //     child: Builder(builder: (context) {
            //       return CustomScrollView(
            //         slivers: <Widget>[
            //           SliverFillRemaining(
            //             child: e
            //           )
            //         ],
            //       );
            //     })
            //   );
            // }).toList(),
          ),
        ),
      ),
    );
  }
}
