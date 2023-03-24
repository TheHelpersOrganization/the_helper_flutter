import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/screens/loading_screen.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';
import 'package:the_helper/src/features/profile/presentation/profile_screen/profile_detail_tab.dart';
import 'package:the_helper/src/router/router.dart';

import '../../data/profile_repository.dart';

const List<Tab> tabs = <Tab>[
  Tab(text: 'Overview'),
  Tab(text: 'Activity'),
  Tab(text: 'Organization'),
  Tab(text: 'Detail'),
];

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends ConsumerState {
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
    final email =
        ref.watch(authServiceProvider).valueOrNull?.account.email ?? '';

    final profile = ref.watch(profileProvider);
    return profile.when(
      loading: () => const LoadingScreen(),
      error: (error, stack) => Text('Error: $error'),
      data: (profile) => Scaffold(
        drawer: const AppDrawer(),
        body: DefaultTabController(
          length: tabs.length,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  elevation: 0,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      tooltip: 'Edit profile',
                      onPressed: () {
                        context.pushNamed(AppRoute.editProfile.name);
                      },
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
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          profile.username ?? email,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          profile.bio ?? '',
                          style: Theme.of(context).textTheme.titleMedium,
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
                      height: 16,
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
