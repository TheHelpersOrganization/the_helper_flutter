import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_auth_flutter_riverpod/src/common/widget/drawer/app_drawer.dart';
import 'package:simple_auth_flutter_riverpod/src/features/profile/presentation/profile_controller.dart';
import 'package:simple_auth_flutter_riverpod/src/features/profile/presentation/profile_detail_tab.dart';

const List<Tab> tabs = <Tab>[
  Tab(text: 'Overview'),
  Tab(text: 'Activity'),
  Tab(text: 'Organization'),
  Tab(text: 'Detail'),
];

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState {
  late ScrollController _scrollController;

  bool get _isSliverAppBarExtended =>
      _scrollController.hasClients &&
      _scrollController.offset > (400 - kToolbarHeight);
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileControllerProvider);
    return profile.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
      data: (profile) => Scaffold(
        body: DefaultTabController(
          length: tabs.length,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  elevation: 0,
                  leading: const Icon(Icons.menu),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      tooltip: 'Edit profile',
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings),
                      tooltip: 'Setting profile',
                      onPressed: () {},
                    ),
                  ],
                  // title: _isSliverAppBarExtended ? Text(profile.username) : null,
                  pinned: true,
                  expandedHeight: 400,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    background: Column(
                      children: [
                        const SizedBox(height: kToolbarHeight),
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 8,
                                color: Theme.of(context).secondaryHeaderColor),
                            shape: BoxShape.circle,
                            image: const DecorationImage(
                              image: NetworkImage(
                                'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
                              ),
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                        Text(
                          profile.username,
                          style:
                              Theme.of(context).primaryTextTheme.displayMedium,
                        ),
                        Text(
                          profile.bio,
                          style:
                              Theme.of(context).primaryTextTheme.headlineMedium,
                        ),
                      ],
                    ),
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
                  children: const [
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
