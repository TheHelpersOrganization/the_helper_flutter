import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:the_helper/src/common/extension/image.dart';
import 'package:the_helper/src/common/widget/detail_list_tile.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';
import 'package:the_helper/src/features/profile/presentation/profile_controller.dart';
import 'package:the_helper/src/router/router.dart';

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
    final accountToken = ref.watch(authServiceProvider);
    final profile = ref.watch(profileServiceProvider);

    return profile.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, __) => Text('Error: $error'),
      data: (profile) => Scaffold(
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
                    title: Text(
                      profile.username.toString().toUpperCase(),
                    ),
                    centerTitle: true,
                    pinned: true,
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: 'Edit profile',
                        onPressed: () =>
                            context.pushNamed(AppRoute.profileEdit.name),
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings),
                        tooltip: 'Setting profile',
                        onPressed: () {
                          context.pushNamed(AppRoute.profileSetting.name);
                        },
                      )
                    ],
                    expandedHeight: 300 + kTextTabBarHeight + kToolbarHeight,
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
                                image: DecorationImage(
                                  image: profile.avatarId == null
                                      ? Image.asset(
                                          'assets/images/organization_placeholder.jpg',
                                        ).image
                                      : ImageX.backend(
                                          profile.avatarId!,
                                        ).image,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                          ),
                          accountToken.when(
                            loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            error: (_, __) =>
                                const Text('An error has happened'),
                            data: (data) => Text(
                              profile.username ?? data!.account.email,
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
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
                                  .sliverOverlapAbsorberHandleFor(context)),
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
                                          value:
                                              profile.phoneNumber ?? 'Unknown'),
                                      DetailListTile(
                                          label: 'First Name',
                                          value:
                                              profile.firstName ?? 'Unknown'),
                                      DetailListTile(
                                          label: 'Last Name',
                                          value: profile.lastName ?? 'Unknown'),
                                      DetailListTile(
                                          label: 'Date of Birth',
                                          value: DateFormat('dd-MM-yyyy')
                                              .format(profile.dateOfBirth!)),
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
      ),
    );
  }
}
