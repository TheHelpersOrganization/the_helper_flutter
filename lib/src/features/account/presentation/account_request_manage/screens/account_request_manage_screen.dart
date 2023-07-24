import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Widgets
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/features/account/domain/account_request_query.dart';
import 'package:the_helper/src/features/account/presentation/account_request_manage/widgets/custom_list.dart';

import '../../../../../common/widget/search_bar/debounce_search_bar.dart';
import '../controllers/account_request_manage_screen_controller.dart';

//Screens

const List<Tab> tabs = <Tab>[
  Tab(text: 'Pendding'),
  Tab(text: 'Approved'),
  Tab(text: 'Blocked'),
];

const List<Widget> tabViews = <Widget>[
  CustomScrollList(tabIndex: AccountRequestStatus.pending),
  CustomScrollList(tabIndex: AccountRequestStatus.completed),
  CustomScrollList(tabIndex: AccountRequestStatus.blocked),
];

class AccountRequestManageScreen extends ConsumerWidget {
  const AccountRequestManageScreen({super.key});

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
                    hintText: 'Search account requests',
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
                'Account requests manage',
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
              tabs: tabs,)
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
