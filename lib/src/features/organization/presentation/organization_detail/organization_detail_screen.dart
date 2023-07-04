import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:the_helper/src/common/delegate/tabbar_delegate.dart';
import 'package:the_helper/src/common/extension/image.dart';
import 'package:the_helper/src/common/widget/detail_list_tile.dart';
import 'package:the_helper/src/features/organization/data/organization_repository.dart';
import 'package:the_helper/src/router/router.dart';

import '../../domain/organization.dart';

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
    final mediaQuery = MediaQuery.of(context);

    // expected aspect ratio: 3 / 1
    final expandedHeight = min<double>(
          mediaQuery.size.width * (1 / 3),
          mediaQuery.size.height * .25,
        ) -
        mediaQuery.padding.top;
        
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
                // SliverStack(
                //   children: [
                //     SliverAppBar(
                //     elevation: 0,
                //     scrolledUnderElevation: 0,
                //     pinned: true,
                //     automaticallyImplyLeading: false,
                //     backgroundColor: Colors.transparent,
                //     expandedHeight: expandedHeight,
                //     flexibleSpace: org.banner != null
                //         ? FlexibleSpaceBar(background: Container(
                //           decoration: BoxDecoration(
                //             image: DecorationImage(
                //               image: ImageX.backend(org.banner!).image,
                //               fit: BoxFit.cover),
                //           ),
                //         ))
                //         : null,
                //   ),

                //     SliverPinnedHeader(
                //       child: SafeArea(
                //         bottom: false,
                //         // minimum: Theme.of(context)..symmetric(horizontal: true).resolve(
                //         //       Directionality.of(context),
                //         //     ),
                //         child: Row(
                //           children: [
                //             IconButton(
                //               icon: const Icon(Icons.arrow_back),
                //               onPressed: () {
                //                 if (context.canPop()) {
                //                   context.pop();
                //                 } else {
                //                   context.goNamed(AppRoute.home.name);
                //                 }
                //               },
                //             ),
                //             const Spacer(),
                //             Icon(Icons.notification_add),
                //           ],
                //         ),
                //       ),
                //     ),
                // SliverToBoxAdapter(
                //   child: _organizationHeaderWidget(context, org),
                // ),
                // //                     SliverList(
                // //   delegate: SliverChildListDelegate(
                // //     [_organizationHeaderWidget(context, org)],
                // //   ),
                // // ),
                //   ]
                // ),
                // SliverList(
                //   delegate: SliverChildListDelegate(
                //     [_organizationHeaderWidget(context, org)],
                //   ),
                // ),
                SliverOverlapAbsorber(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                      context),
                  sliver: SliverPersistentHeader(
                    pinned: true,
                    delegate: TabBarDelegate(
                      tabBar: const TabBar(
                        tabs: [
                          Tab(
                            text: 'Overview',
                          ),
                          Tab(
                            text: 'Activities',
                          ),
                          Tab(
                            text: 'Organizatons',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                Text('tab 1'),
                Text('tab 2'),
                Text('tab 3'),
              ],
            ),
          ),
        ),
    ),
    );
  }

  Widget _organizationHeaderWidget(
    BuildContext context, 
    Organization data, 
    // Account account
  ) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ImageX.backend(data.banner!).image,
                  fit: BoxFit.cover),)),
            Text(
              data.name!,
              style: Theme.of(context).textTheme.displayLarge,
            ),
            // ProfileVerifiedStatus(
            //   verified: account.isAccountVerified,
            // ),
          ],
        ),
        Positioned(
          bottom: -20,
          left: 15,
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(
                width: 8,
                color: Theme.of(context).primaryColor,
              ),
              shape: BoxShape.circle,
              image: DecorationImage(
                image: data.logo == null
                    ? Image.asset(
                        'assets/images/organization_placeholder.jpg',
                      ).image
                    : ImageX.backend(
                        data.logo!,
                      ).image,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
