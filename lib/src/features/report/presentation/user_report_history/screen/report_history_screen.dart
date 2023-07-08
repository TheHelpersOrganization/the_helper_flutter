import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Widgets
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/features/report/domain/report_type.dart';

import '../../../../../common/widget/search_bar/debounce_search_bar.dart';
import '../controller/report_history_screen_controller.dart';
import '../widget/custom_list.dart';


//Screens

const List<Tab> tabs = <Tab>[
  Tab(text: 'Account'),
  Tab(text: 'Organization'),
  Tab(text: 'Activity'),
];

class ReportHistoryScreen extends ConsumerWidget {
  const ReportHistoryScreen({super.key});

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
                'Reports history',
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
                    hintText: 'Search report request',
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
              CustomScrollList(tabIndex: ReportType.account),
              CustomScrollList(tabIndex: ReportType.organization),
              CustomScrollList(tabIndex: ReportType.activity),
            ]),
        ),
      ),
    );
  }
}
