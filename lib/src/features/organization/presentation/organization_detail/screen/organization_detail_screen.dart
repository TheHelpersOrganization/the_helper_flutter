import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:the_helper/src/common/delegate/tabbar_delegate.dart';
import 'package:the_helper/src/features/organization/data/organization_repository.dart';
import 'package:the_helper/src/router/router.dart';

import '../widget/organization_activity_tab.dart';
import '../widget/organization_detail_tab.dart';
import '../widget/organization_header.dart';
import '../widget/organization_overview_tab.dart';

const List<Tab> tabs = <Tab>[
  Tab(text: 'Overview'),
  Tab(text: 'Activity'),
  Tab(text: 'Detail'),
];

class OrganizationDetailScreen extends ConsumerWidget {
  const OrganizationDetailScreen({super.key, required this.orgId});
  final int orgId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final org = ref.watch(getOrganizationProvider(orgId));

    return org.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, __) => Text('Error: $error'),
      data: (org) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.goNamed(AppRoute.home.name);
              }
            },
          ),
          title: Text('${org.name} Organization'),
          centerTitle: true,
        ),
        body: DefaultTabController(
          length: tabs.length,
          child: NestedScrollView(
            headerSliverBuilder: (context, _) {
              return <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate(
                    [OrganizationHeaderWidget(organization: org)],
                  ),
                ),
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverPersistentHeader(
                    pinned: true,
                    delegate: TabBarDelegate(
                      tabBar: const TabBar(
                        tabs: tabs,
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                OrganizationOverviewTab(id: orgId),
                OrganizationActivityTab(id: orgId),
                OrganizationDetailTab(data: org),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
