import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/image.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/features/profile/domain/profile.dart';
import 'package:the_helper/src/features/profile/presentation/profile/profile_activity_controller.dart';
import 'package:the_helper/src/features/profile/presentation/profile/profile_activity_tab.dart';
import 'package:the_helper/src/features/profile/presentation/profile/profile_detail_tab.dart';
import 'package:the_helper/src/features/profile/presentation/profile/profile_organization_tab.dart';
import 'package:the_helper/src/features/profile/presentation/profile/profile_overview_tab.dart';
import 'package:the_helper/src/features/profile/presentation/profile_controller.dart';
import 'package:the_helper/src/router/router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider);
    final activities = ref.watch(profileActivityControllerProvider);
    // final profile = profileService.getProfile();
    return profile.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, __) => Text('Error: $error'),
      data: (profile) {
        return Scaffold(
          drawer: const AppDrawer(),
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "${profile.username.toString().toUpperCase()}'s Profile",
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Edit profile',
                onPressed: () => context.pushNamed(AppRoute.profileEdit.name),
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                tooltip: 'Setting profile',
                onPressed: () {
                  context.pushNamed(AppRoute.profileSetting.name);
                },
              )
            ],
          ),
          body: DefaultTabController(
            length: 4,
            child: NestedScrollView(
              headerSliverBuilder: (context, _) {
                return [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [_profileHeaderWidget(context, profile)],
                    ),
                  ),
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                    sliver: SliverPersistentHeader(
                      pinned: true,
                      delegate: _TabBarDelegate(
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
                            Tab(
                              text: 'Detail',
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
                  ProfileOverviewTab(
                    skills: profile.skills,
                    interestedList: profile.interestedSkills,
                  ),
                  ProfileActivityTab(activities: activities),
                  const ProfileOrganizationTab(),
                  ProfileDetailTab(profile: profile),
                ],
              ),
              // body: Column(
              //   children: [
              //     Material(
              //       color: Theme.of(context).colorScheme.surface,
              //       child: TabBar(
              //         labelColor: Theme.of(context).colorScheme.primary,
              //         unselectedLabelColor:
              //             Theme.of(context).colorScheme.onSurfaceVariant,
              //         indicatorColor: Theme.of(context).colorScheme.primary,
              //         // indicatorWeight: 1,
              //         tabs: const [
              //           Tab(
              //             text: 'Overview',
              //           ),
              //           Tab(
              //             text: 'Activites',
              //           ),
              //           Tab(
              //             text: 'Organizatons',
              //           ),
              //           Tab(
              //             text: 'Detail',
              //           ),
              //         ],
              //       ),
              //     ),
              //     Expanded(
              //       child: TabBarView(
              //         children: [
              //           ProfileOverview(
              //             skills: profile.skills,
              //             interestedList: profile.interestedSkills,
              //           ),
              //           const Scaffold(body: Center(child: Text('activities'))),
              //           const Scaffold(
              //               body: Center(child: Text('Organizations'))),
              //           const Scaffold(body: Center(child: Text('Detail'))),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
            ),
          ),
        );
      },
    );
  }

  Widget _profileHeaderWidget(BuildContext context, Profile profile) {
    return Column(
      children: [
        Container(
          height: 300,
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
        // TODO: Should replace when reimplement profileService
        Text(
          profile.username!,
          style: Theme.of(context).textTheme.displayLarge,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            // alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: ExpandableText(
              profile.bio!,
              maxLines: 4,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              expandText: 'See More',
              collapseText: 'See Less',
              linkColor: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        )
      ],
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _TabBarDelegate({
    required this.tabBar,
  });
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => kMinInteractiveDimension;

  @override
  double get minExtent => kMinInteractiveDimension;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
