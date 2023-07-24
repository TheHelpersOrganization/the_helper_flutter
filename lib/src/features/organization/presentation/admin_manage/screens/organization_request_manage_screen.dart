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

const List<Widget> tabViews = <Widget>[
  CustomRequestScrollList(tabIndex: OrganizationStatus.pending),
  CustomRequestScrollList(tabIndex: OrganizationStatus.rejected),
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
          floatHeaderSlivers: true,
          headerSliverBuilder: (_, __) => [
            SliverAppBar(
              pinned: true,
              centerTitle: true,
              title: isSearching
              ? Padding(
                  padding: const EdgeInsets.all(12),
                  child: DebounceSearchBar(
                    hintText: 'Search organization requests',
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
              bottom: TabBar(
                labelColor: Theme.of(context).colorScheme.onSurface,
                tabs: tabs,
              ),
            ),
          ],
          body: const TabBarView(children: tabViews
          // .map((Widget e) {
          //   return SafeArea(
          //     top: false,
          //     bottom: false,
          //       child: Builder(builder: (context) {
          //         return CustomScrollView(
          //           slivers: <Widget>[
          //             SliverFillRemaining(
          //               child: e
          //             )
          //           ],
          //         );
          //       })
          //     );
          //   }).toList(),
          ),
        ),
      ),
    );
  }
}
