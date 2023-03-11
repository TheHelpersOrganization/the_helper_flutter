import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/presentation/profile_controller.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/presentation/profile_detail_tab.dart';

const List<Tab> tabs = <Tab>[
  Tab(text: 'Overview'),
  Tab(text: 'Activity'),
  Tab(text: 'Organization'),
  Tab(text: 'Detail'),
];

class ProfileW extends ConsumerWidget {
  const ProfileW({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider);
    return Scaffold(
      body: DefaultTabController(
        length: tabs.length,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                elevation: 0,
                leading: Icon(Icons.menu),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    tooltip: 'Add new entry',
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    tooltip: 'Add new entry',
                    onPressed: () {},
                  ),
                ],
                pinned: true,
                expandedHeight: 400.0,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: profile.when(
                    data: (profile) => Text(
                      profile.username,
                      textScaleFactor: 1,
                    ),
                    error: (Object error, StackTrace stackTrace) =>
                        Text('Erorr: $error'),
                    loading: () => const CircularProgressIndicator(),
                  ),
                  // background: Padding(
                  //   padding: const EdgeInsets.all(36.0),
                  //   child: Container(
                  //     width: 200,
                  //     height: 200,
                  //     decoration: const BoxDecoration(
                  //       shape: BoxShape.circle,
                  //       image: DecorationImage(
                  //         image: NetworkImage(
                  //           'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
                  //         ),
                  //         fit: BoxFit.fitHeight,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  background: Container(
                      child: Column(
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(
                              'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
                            ),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      Text('Duy Phong',
                          style: Theme.of(context).primaryTextTheme.labelLarge),
                      Text('huhuhu'),
                    ],
                  )),
                  stretchModes: const [StretchMode.zoomBackground],
                ),
              ),
              SliverPersistentHeader(
                delegate: MySliverPersistentHeaderDelegate(
                  TabBar(
                    labelColor: Theme.of(context).colorScheme.onSurface,
                    tabs: tabs,
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            children: [
              const Tab(text: 'Overview'),
              const Tab(text: 'Activity'),
              const Tab(text: 'Organization'),
              Column(
                children: [
                  SizedBox(
                    height: 160,
                  ),
                  ProfileDetailTab(),
                ],
              ),
            ],
            // children: tabs,
          ),
        ),
      ),
    );
  }
}

class MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  MySliverPersistentHeaderDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(MySliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
