import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/features/organization/data/organization_repository.dart';

import '../../../../common/extension/image.dart';

const List<Tab> tabs = <Tab>[
  Tab(text: 'Overview'),
  Tab(text: 'Activity'),
];

class OrganizationDetailScreen extends ConsumerWidget {
  const OrganizationDetailScreen({super.key, required this.orgId});
  final String orgId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final org = ref.watch(getOrganizationProvider(int.parse(orgId)));
    return Scaffold(
      // drawer: const AppDrawer(),

      body: org.when(
        data: (org) => DefaultTabController(
          length: tabs.length,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    forceElevated: innerBoxIsScrolled,
                    // Todo: extract this icon button to a widget
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => context.pop(),
                    ),
                    title: Text('${org.name} Organization'),
                    centerTitle: true,
                    pinned: true,
                    // TODO: should change this fixed size to varialbles of display content inside flexibleSpace
                    expandedHeight: 300 + kTextTabBarHeight + kToolbarHeight,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Column(
                        children: [
                          const SizedBox(height: kToolbarHeight),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 4,
                                  color: Theme.of(context).primaryColor,
                                ),
                                image: DecorationImage(
                                  image: org.logo == null
                                      ? Image.asset(
                                              'assets/images/organization_placeholder.jpg')
                                          .image
                                      : ImageX.backend(org.logo!).image,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            org.name,
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          const SizedBox(
                            height: kTextTabBarHeight,
                          )
                        ],
                      ),
                    ),
                    bottom: const TabBar(tabs: tabs),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: tabs.map(
                (tab) {
                  return SafeArea(
                    child: Builder(
                      builder: (context) {
                        return CustomScrollView(
                          key: PageStorageKey<String>(tab.text.toString()),
                          slivers: <Widget>[
                            SliverOverlapInjector(
                                handle: NestedScrollView
                                    .sliverOverlapAbsorberHandleFor(context)),
                            SliverPadding(
                                padding: const EdgeInsets.all(8),
                                sliver: SliverFixedExtentList(
                                    itemExtent: 48.0,
                                    delegate: (tab.text == 'Detail')
                                        ? SliverChildListDelegate([])
                                        : SliverChildBuilderDelegate(
                                            (context, index) => ListTile(
                                                title: Text('Item $index')),
                                          ))),
                          ],
                        );
                      },
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text(e.toString())),
      ),
    );
  }
}
