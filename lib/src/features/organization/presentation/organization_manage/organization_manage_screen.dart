import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';

const List<Tab> tabs = <Tab>[
  Tab(text: 'Joined'),
  Tab(text: 'Pending'),
  Tab(text: 'Rejected'),
];

// Todo: rename class
class OrganizationManageScreen extends ConsumerWidget {
  const OrganizationManageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: DefaultTabController(
        length: tabs.length,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  forceElevated: innerBoxIsScrolled,
                  title: const Text('Your Organizations'),
                  centerTitle: true,
                  pinned: true,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      tooltip: 'Search organization',
                      onPressed: () {},
                    ),
                  ],
                  bottom: const TabBar(
                    tabs: tabs,
                  ),
                ),
              ),
            ];
          },
          body: const TabBarView(
            children: tabs,
          ),
        ),
      ),
    );
  }
}
