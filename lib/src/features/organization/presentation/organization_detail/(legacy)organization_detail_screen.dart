import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/widget/detail_list_tile.dart';

import 'package:the_helper/src/features/organization/data/organization_repository.dart';
import 'package:the_helper/src/router/router.dart';

import '../../../../common/extension/image.dart';

const List<Tab> tabs = <Tab>[
  Tab(text: 'Overview'),
  Tab(text: 'Activity'),
  Tab(text: 'Detail'),
];

// const List<Chip> chips = <Chip>[
//   Chip(label: const Text('Environment')),
//   Chip(label: const Text('Environment')),
// ];

class OrganizationDetailScreen extends ConsumerWidget {
  const OrganizationDetailScreen({super.key, required this.orgId});
  final String orgId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double bannerHeight = 300;
    const double logoDiameter = 300;
    // print(orgId);
    final org = ref.watch(getOrganizationProvider(int.parse(orgId)));
    return Scaffold(
      // drawer: const AppDrawer(),

      body: org.when(
        data: (org) => DefaultTabController(
          length: tabs.length,
          child: NestedScrollView(
            // floatHeaderSlivers: true,
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
                      onPressed: () {
                        context.goNamed(AppRoute.organizationSearch.name);
                      },
                    ),
                    actions: [
                      if (innerBoxIsScrolled)
                        IconButton(
                          icon: const Icon(Icons.pending),
                          onPressed: () {},
                        ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {},
                      ),
                    ],
                    title: innerBoxIsScrolled
                        ? Text('${org.name} Organization')
                        : null,
                    centerTitle: true,
                    pinned: true,
                    // TODO: should change this fixed size to varialbles of display content inside flexibleSpace
                    expandedHeight: 300 + bannerHeight + logoDiameter / 2,
                    // kTextTabBarHeight +
                    // kToolbarHeight, // 300 is the others size
                    flexibleSpace: FlexibleSpaceBar(
                      background: Column(
                        children: [
                          // const SizedBox(height: kToolbarHeight),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: bannerHeight,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: Image.asset(
                                                'assets/images/organization_placeholder.jpg')
                                            .image,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                  Container(
                                    height: logoDiameter / 2,
                                    // color: Colors.black,
                                  ),
                                ],
                              ),
                              Positioned(
                                top: bannerHeight - logoDiameter / 2,
                                child: Container(
                                  height: logoDiameter,
                                  width: logoDiameter,
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
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 16),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Column(
                              children: [
                                Text(org.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium),
                                Text(org.description,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                                ElevatedButton(
                                    onPressed: () {},
                                    child: const Text('Request to join')),
                              ],
                            ),
                          ),
                          // const SizedBox(height: kTextTabBarHeight),
                        ],
                      ),
                    ),
                    bottom: PreferredSize(
                      preferredSize: TabBar(tabs: tabs).preferredSize,
                      child: Material(
                        color: innerBoxIsScrolled
                            ? Theme.of(context).colorScheme.surface
                            : Theme.of(context).appBarTheme.foregroundColor,
                        child: TabBar(tabs: tabs),
                      ),
                    ),
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
                          // shrinkWrap: true,
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
                                    ? SliverChildListDelegate([
                                        DetailListTile(
                                          label: 'Phone Number',
                                          value: org.phoneNumber,
                                        ),
                                        DetailListTile(
                                          label: 'Email Address',
                                          value: org.email,
                                        ),
                                        DetailListTile(
                                          label: 'Website',
                                          value: org.website,
                                        ),
                                      ])
                                    : SliverChildBuilderDelegate(
                                        (context, index) => ListTile(
                                          title: Text('Item $index'),
                                        ),
                                        childCount: 1,
                                      ),
                              ),
                            ),
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

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(
    this._tabBar,
  );
  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      // : Theme.of(context).colorScheme.background,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
