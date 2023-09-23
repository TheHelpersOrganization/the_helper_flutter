import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/image.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';
import 'package:the_helper/src/features/authentication/domain/account.dart';
import 'package:the_helper/src/features/chat/domain/create_chat.dart';
import 'package:the_helper/src/features/chat/presentation/chat/controller/chat_controller.dart';
import 'package:the_helper/src/features/profile/domain/profile.dart';
import 'package:the_helper/src/features/profile/presentation/profile/profile_activity_tab.dart';
import 'package:the_helper/src/features/profile/presentation/profile/profile_detail_tab.dart';
import 'package:the_helper/src/features/profile/presentation/profile/profile_organization_tab.dart';

import 'package:the_helper/src/features/profile/presentation/profile_controller.dart';
import 'package:the_helper/src/features/report/domain/report_query_parameter_classes.dart';

import './profile_verified_status.dart';
import '../../../report/presentation/submit_report/screen/submit_report_screen.dart';
import '../profile/profile_organization_controller.dart';
import 'profile_overview_tab.dart';

class OtherUserProfileScreen extends ConsumerWidget {
  final int userId;

  const OtherUserProfileScreen({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider(id: userId));
    final orgs = ref.watch(profileOrganizationControllerProvider);
    final account = ref.watch(authServiceProvider).value!.account;
    final createChatState = ref.watch(createChatControllerProvider);
    // final profile = profileService.getProfile();
    return profile.when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, __) => Scaffold(
        body: Text('Error: $error'),
      ),
      data: (profile) {
        print(profile);
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                context.pop();
              },
            ),
            // actions: [
            //   IconButton(
            //       onPressed: () {
            //         Navigator.of(context).push(
            //             MaterialPageRoute(builder: (BuildContext context) {
            //           return SubmitReportScreen(
            //             id: profile.id!,
            //             name: profile.username.toString(),
            //             entityType: ReportType.account,
            //             avatarId: profile.avatarId,
            //             subText: profile.email,
            //           );
            //         }));
            //       },
            //       icon: const Icon(Icons.report)),
            // ],
            centerTitle: true,
            title: Text(
              "${profile.username.toString().toUpperCase()}'s Profile",
            ),
          ),
          body: DefaultTabController(
            length: 4,
            child: NestedScrollView(
              headerSliverBuilder: (context, _) {
                return [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        _profileHeaderWidget(
                          context,
                          profile,
                          account,
                          createChatState.isLoading
                              ? null
                              : () {
                                  ref
                                      .read(
                                          createChatControllerProvider.notifier)
                                      .createChat(
                                        CreateChat(to: userId),
                                      );
                                },
                        )
                      ],
                    ),
                  ),
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                    sliver: SliverPersistentHeader(
                      pinned: true,
                      delegate: _TabBarDelegate(
                        tabBar: const TabBar(
                          isScrollable: true,
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
                    profile: profile,
                  ),
                  const ProfileActivityTab(),
                  ProfileOrganizationTab(orgs: orgs),
                  ProfileDetailTab(profile: profile),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _profileHeaderWidget(
    BuildContext context,
    Profile profile,
    Account account,
    VoidCallback? onChatButtonPressed,
  ) {
    return Column(
      children: [
        Container(
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(
              width: 4,
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
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Text(
            profile.username!,
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ),
        ProfileVerifiedStatus(
          verified: account.isAccountVerified,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                onPressed: onChatButtonPressed,
                icon: const Icon(
                  Icons.chat,
                  size: 20,
                ),
                label: const Text('Chat'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return SubmitReportScreen(
                      id: profile.id!,
                      name: profile.username.toString(),
                      entityType: ReportType.account,
                      avatarId: profile.avatarId,
                      subText: profile.email,
                    );
                  }));
                },
                icon: const Icon(
                  Icons.report_outlined,
                  size: 20,
                ),
                label: const Text('Report'),
              ),
            ],
          ),
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
              textAlign: TextAlign.left,
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
