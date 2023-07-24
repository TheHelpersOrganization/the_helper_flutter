import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/widget/search_bar/debounce_search_bar.dart';

import '../../../../../common/widget/drawer/app_drawer.dart';
import '../controllers/account_manage_screen_controller.dart';
import '../widgets/account_list.dart';

const List<Tab> tabs = <Tab>[
  Tab(text: 'Active'),
  Tab(text: 'Banned'),
];

const List<Widget> tabViews = <Widget>[
  AccountList(tabIndex: 0),
  AccountList(tabIndex: 1),
];

class AccountManageScreen extends ConsumerWidget {
  const AccountManageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSearching = ref.watch(isSearchingProvider);
    final filterSelected = ref.watch(filterSelectedProvider);
    final verified = ref.watch(verifiedProvider);

    return Scaffold(
      drawer: const AppDrawer(),
      body: DefaultTabController(
        length: tabs.length,
        child: NestedScrollView(
          // floatHeaderSlivers: true,
          headerSliverBuilder: (_, __) => 
            [
            SliverAppBar(
              pinned: true,
              centerTitle: true,
              title: isSearching
              ? Padding(
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
                )
              :const Text(
                'Accounts manage',
              ),
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
                    const Text(
                      'Quick filter',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        FilterChip(
                          label: const Text('Verified'),
                          onSelected: (value) {
                            ref.read(filterSelectedProvider.notifier).state =
                                value;
                            ref.read(verifiedProvider.notifier).state = value;
                          },
                          selected: filterSelected && verified,
                        ),
                        const SizedBox(width: 12),
                        FilterChip(
                          label: const Text('Not verified'),
                          onSelected: (value) {
                            ref.read(filterSelectedProvider.notifier).state =
                                value;
                            ref.read(verifiedProvider.notifier).state = !value;
                          },
                          selected: filterSelected && !verified,
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
          ),
        ),
      ),
    );
  }
}
