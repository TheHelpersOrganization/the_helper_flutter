import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Widgets
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/features/organization/domain/organization_status.dart';
import 'package:the_helper/src/features/organization/presentation/admin_manage/controllers/organization_manage_screen_controller.dart';
import 'package:the_helper/src/features/organization/presentation/admin_manage/widgets/custom_request_list.dart';

import '../../../../../common/widget/search_bar/debounce_search_bar.dart';

//Screens

const List<Tab> tabs = <Tab>[
  Tab(text: 'Pending'),
  Tab(text: 'Reject'),
];

class OrganizationRequestManageScreen extends ConsumerWidget {
  const OrganizationRequestManageScreen({super.key});

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
                'Organizations request manage',
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
                    hintText: 'Search organizations',
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
              CustomRequestScrollList(tabIndex: OrganizationStatus.pending),
              CustomRequestScrollList(tabIndex: OrganizationStatus.rejected),
            ]),
        ),
      ),
    );
  }
}
