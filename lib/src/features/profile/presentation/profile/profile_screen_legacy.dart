// import 'dart:ui' as ui;
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:expandable_text/expandable_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:intl/intl.dart';
// import 'package:sliver_tools/sliver_tools.dart';
// import 'package:the_helper/src/common/extension/image.dart';
// import 'package:the_helper/src/common/widget/detail_list_tile.dart';
// import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
// import 'package:the_helper/src/features/authentication/application/auth_service.dart';
// import 'package:the_helper/src/features/profile/presentation/profile/profile_detail_tab.dart';
// import 'package:the_helper/src/features/profile/presentation/profile_controller.dart';
// import 'package:the_helper/src/router/router.dart';

// import 'profile_activity_tab.dart';
// import 'profile_organization_tab.dart';
// import 'profile_overview_tab.dart';

// // Todo: implement tab provider
// const List<Tab> tabs = <Tab>[
//   Tab(text: 'Overview'),
//   Tab(text: 'Activity'),
//   Tab(text: 'Organization'),
//   Tab(text: 'Detail'),
// ];

// class ProfileScreenOld extends ConsumerWidget {
//   const ProfileScreenOld({super.key});

//   Size _textSize({required String text, TextStyle? style, int? maxLines}) {
//     final TextPainter textPainter = TextPainter(
//       text: TextSpan(text: text, style: style),
//       maxLines: maxLines,
//       textDirection: ui.TextDirection.ltr,
//     )..layout(minWidth: 0, maxWidth: double.infinity);
//     return textPainter.size;
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final accountToken = ref.watch(authServiceProvider);
//     final profile = ref.watch(profileServiceProvider);
//     return profile.when(
//       loading: () => const Center(
//         child: CircularProgressIndicator(),
//       ),
//       error: (error, __) => Text('Error: $error'),
//       data: (profile) {
//         final String bio = profile.bio ?? "Nothing here";
//         print(_textSize(text: bio));
//         return Scaffold(
//           drawer: const AppDrawer(),
//           body: DefaultTabController(
//             length: tabs.length,
//             child: NestedScrollView(
//               headerSliverBuilder: (context, innerBoxIsScrolled) {
//                 return <Widget>[
//                   SliverOverlapAbsorber(
//                     handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
//                         context),
//                     sliver: MultiSliver(
//                       children: [
//                         SliverAppBar(
//                           forceElevated: innerBoxIsScrolled,
//                           title: Text(
//                             profile.username.toString().toUpperCase(),
//                           ),
//                           centerTitle: true,
//                           // pinned: true,
//                           // floating: true,
//                           // snap: true,
//                           actions: [
//                             IconButton(
//                               icon: const Icon(Icons.edit),
//                               tooltip: 'Edit profile',
//                               onPressed: () =>
//                                   context.pushNamed(AppRoute.profileEdit.name),
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.settings),
//                               tooltip: 'Setting profile',
//                               onPressed: () {
//                                 context.pushNamed(AppRoute.profileSetting.name);
//                               },
//                             )
//                           ],
//                           expandedHeight:
//                               512 + kTextTabBarHeight + kToolbarHeight,
//                           // forceElevated: true,
//                           flexibleSpace: FlexibleSpaceBar(
//                             background: Column(
//                               children: [
//                                 const SizedBox(height: kToolbarHeight),
//                                 Container(
//                                   height: 300,
//                                   decoration: BoxDecoration(
//                                     border: Border.all(
//                                       width: 8,
//                                       color: Theme.of(context).primaryColor,
//                                     ),
//                                     shape: BoxShape.circle,
//                                     image: DecorationImage(
//                                       image: profile.avatarId == null
//                                           ? Image.asset(
//                                               'assets/images/organization_placeholder.jpg',
//                                             ).image
//                                           : ImageX.backend(
//                                               profile.avatarId!,
//                                             ).image,
//                                       fit: BoxFit.fitHeight,
//                                     ),
//                                   ),
//                                 ),
//                                 // TODO: Should replace when reimplement profileService
//                                 accountToken.when(
//                                   loading: () => const Center(
//                                     child: CircularProgressIndicator(),
//                                   ),
//                                   error: (_, __) =>
//                                       const Text('An error has happened'),
//                                   data: (data) => Text(
//                                     profile.username ?? data!.account.email,
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .displayLarge,
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(32.0),
//                                   child: Container(
//                                     padding: const EdgeInsets.all(16.0),
//                                     // alignment: Alignment.center,
//                                     decoration: BoxDecoration(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .secondary,
//                                       borderRadius: const BorderRadius.all(
//                                         Radius.circular(20),
//                                       ),
//                                     ),
//                                     child: ExpandableText(
//                                       profile.bio!,
//                                       maxLines: 4,
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .onSecondary,
//                                       ),
//                                       expandText: 'See More',
//                                       collapseText: 'See Less',
//                                       linkColor: Theme.of(context)
//                                           .colorScheme
//                                           .onPrimaryContainer,
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                           // bottom: const TabBar(
//                           //   tabs: tabs,
//                           // ),
//                         ),
//                         SliverPersistentHeader(
//                           pinned: true,
//                           floating: true,
//                           delegate: _TabBarDelegate(
//                             tabBar: const TabBar(tabs: tabs),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   // SliverPersistentHeader(
//                   //   delegate: TabBarPersistentHeaderDelegate(
//                   //     tabBar: const TabBar(
//                   //       tabs: tabs,
//                   //     ),
//                   //     minHeight: 48,
//                   //     maxHeight: 48,
//                   //   ),
//                   //   pinned: true,
//                   // ),
//                 ];
//               },
//               // Todo: implement TabBarView
//               body: TabBarView(
//                 children: [
//                   ProfileOverviewTab(
//                     skills: profile.skills,
//                     interestedList: profile.interestedSkills,
//                   ),
//                   const ProfileActivityTab(),
//                   const ProfileOrganizationTab(),
//                   ProfileDetailTab(profile: profile),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class _TabBarDelegate extends SliverPersistentHeaderDelegate {
//   final TabBar tabBar;

//   _TabBarDelegate({
//     required this.tabBar,
//   });
//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Container(
//       color: Colors.white,
//       child: tabBar,
//     );
//   }

//   @override
//   double get maxExtent => kToolbarHeight;

//   @override
//   double get minExtent => kToolbarHeight;

//   @override
//   bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
//     return false;
//   }
// }
