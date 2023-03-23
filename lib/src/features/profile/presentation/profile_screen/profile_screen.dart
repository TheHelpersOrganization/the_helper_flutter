import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';

import '../../../../router/router.dart';
import '../../data/profile_repository.dart';

// Todo: implement tab provider
const List<Tab> tabs = <Tab>[
  Tab(text: 'Overview'),
  Tab(text: 'Activity'),
  Tab(text: 'Organization'),
  Tab(text: 'Detail'),
];

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    return profile.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, __) => Text('Error: $error'),
      data: (profile) {
        print(profile);
        return Scaffold(
          drawer: const AppDrawer(),
          body: DefaultTabController(
            length: tabs.length,
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                    sliver: SliverAppBar(
                      title: Text(
                        profile.username.toString().toUpperCase(),
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: 'Edit profile',
                          onPressed: () =>
                              context.pushNamed(AppRoute.editProfile.name),
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings),
                          tooltip: 'Setting profile',
                          onPressed: () {
                            context.pushNamed(AppRoute.profileSetting.name);
                          },
                        )
                      ],
                      centerTitle: true,
                      pinned: true,
                      expandedHeight: 300 + kTextTabBarHeight + kToolbarHeight,
                      forceElevated: innerBoxIsScrolled,
                      // forceElevated: true,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Column(
                          children: [
                            const SizedBox(height: kToolbarHeight),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 8,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  shape: BoxShape.circle,
                                  image: const DecorationImage(
                                    image: NetworkImage(
                                      'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
                                    ),
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              profile.username!,
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            const SizedBox(height: kTextTabBarHeight),
                          ],
                        ),
                      ),
                      bottom: const TabBar(
                        tabs: tabs,
                      ),
                    ),
                  ),
                ];
              },
              // Todo: implement TabBarView
              body: TabBarView(
                children: tabs.map((Tab tab) {
                  return SafeArea(
                    child: Builder(
                      builder: (BuildContext context) {
                        return CustomScrollView(
                          key: PageStorageKey<String>(tab.text.toString()),
                          slivers: <Widget>[
                            SliverOverlapInjector(
                              handle: NestedScrollView
                                  .sliverOverlapAbsorberHandleFor(context),
                            ),
                            SliverPadding(
                              padding: const EdgeInsets.all(8),
                              sliver: SliverFixedExtentList(
                                itemExtent: 48.0,
                                delegate: (tab.text != 'Detail')
                                    ? SliverChildBuilderDelegate(
                                        (context, index) {
                                          return ListTile(
                                            title: Text('Item $index'),
                                          );
                                        },
                                        // childCount: 20,
                                      )
                                    : SliverChildListDelegate([
                                        DetailListTile(
                                            label: 'Phone Number',
                                            value: profile.phoneNumber ??
                                                'Unknown'),
                                        DetailListTile(
                                            label: 'First Name',
                                            value:
                                                profile.firstName ?? 'Unknown'),
                                        DetailListTile(
                                            label: 'Last Name',
                                            value:
                                                profile.lastName ?? 'Unknown'),
                                        // DetailListTile(
                                        //     label: 'Date of Birth',
                                        //     value: DateFormat('dd-MM-yyyy')
                                        //         .format(profile.dateOfBirth!)),
                                        DetailListTile(
                                            label: 'Gender',
                                            value: profile.gender ?? 'Unknown'),
                                        // DetailListTile(label: 'Location', value: profile.location?? 'Unknown'),
                                      ]),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class DetailListTile extends ConsumerWidget {
  const DetailListTile({super.key, required this.label, required this.value});
  final label;
  final value;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(label), Text(value)]),
    );
  }
}
