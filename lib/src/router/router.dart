import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/screens/safe_screen.dart';
import 'package:the_helper/src/common/screens/screen404.dart';
import 'package:the_helper/src/common/widget/bottom_navigation_bar/bottom_navigator.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/activity_detail_screen.dart';
import 'package:the_helper/src/features/activity/presentation/activity_search/activity_search_screen.dart';
import 'package:the_helper/src/features/activity/presentation/shift/shift_detail_screen.dart';
import 'package:the_helper/src/features/activity/presentation/shift/shifts_screen.dart';
import 'package:the_helper/src/features/activity_manage/presentation/screens/activity_manage_screen.dart';
import 'package:the_helper/src/features/authentication/presentation/account_verification_completed_screen.dart';
import 'package:the_helper/src/features/authentication/presentation/account_verification_screen.dart';
import 'package:the_helper/src/features/authentication/presentation/login_screen.dart';
import 'package:the_helper/src/features/authentication/presentation/logout_screen.dart';
import 'package:the_helper/src/features/change_role/presentation/screens/change_role_screen.dart';
import 'package:the_helper/src/features/change_role/presentation/screens/home_screen.dart';
import 'package:the_helper/src/features/menu/presentation/screens/menu_screen.dart';
import 'package:the_helper/src/features/organization/presentation/my/my_organization_screen.dart';
import 'package:the_helper/src/features/organization/presentation/organization_detail/organization_detail_screen.dart';
import 'package:the_helper/src/features/organization/presentation/organization_manage/organization_manage_screen.dart';
import 'package:the_helper/src/features/organization/presentation/organization_registration/organization_registration.dart';
import 'package:the_helper/src/features/organization/presentation/organization_search/organization_search_screen.dart';
import 'package:the_helper/src/features/profile/presentation/profile/profile_screen.dart';
import 'package:the_helper/src/features/profile/presentation/profile_edit/profile_edit_screen.dart';
import 'package:the_helper/src/features/profile/presentation/profile_setting/profile_setting_screen.dart';
import 'package:the_helper/src/router/router_notifier.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

final routes = [
  ShellRoute(
    builder: (_, __, child) {
      return SafeScreen(child: child);
    },
    routes: [
      GoRoute(
        path: AppRoute.developing.path,
        name: AppRoute.developing.name,
        builder: (_, __) => const ChangeRoleScreen(),
      ),
      GoRoute(
        path: AppRoute.login.path,
        name: AppRoute.login.name,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoute.logout.path,
        name: AppRoute.logout.name,
        builder: (context, state) => const LogoutScreen(),
      ),
      GoRoute(
        path: AppRoute.accountVerification.path,
        name: AppRoute.accountVerification.name,
        builder: (_, __) => const AccountVerificationScreen(),
      ),
      GoRoute(
        path: AppRoute.changeRole.path,
        name: AppRoute.changeRole.name,
        builder: (_, __) => const ChangeRoleScreen(),
      ),
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (_, __, child) {
          return CustomBottomNavigator(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoute.home.path,
            name: AppRoute.home.name,
            builder: (_, __) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoute.accountVerificationCompleted.path,
            name: AppRoute.accountVerificationCompleted.name,
            builder: (_, __) => const AccountVerificationCompletedScreen(),
          ),
          GoRoute(
            path: AppRoute.news.path,
            name: AppRoute.news.name,
            builder: (_, __) => const DevelopingScreen(),
          ),
          GoRoute(
            path: AppRoute.chat.path,
            name: AppRoute.chat.name,
            builder: (_, __) => const DevelopingScreen(),
          ),
          GoRoute(
            path: AppRoute.notification.path,
            name: AppRoute.notification.name,
            builder: (_, __) => const DevelopingScreen(),
          ),
          GoRoute(
            path: AppRoute.report.path,
            name: AppRoute.report.name,
            builder: (_, __) => const DevelopingScreen(),
          ),
          GoRoute(
            path: AppRoute.menu.path,
            name: AppRoute.menu.name,
            builder: (_, __) => const MenuScreen(),
          ),
          GoRoute(
            path: AppRoute.settings.path,
            name: AppRoute.settings.name,
            builder: (_, __) => const MenuScreen(),
          ),
          GoRoute(
            path: AppRoute.myOrganization.path,
            name: AppRoute.myOrganization.name,
            builder: (context, state) => const MyOrganizationScreen(),
          )
        ],
      ),
      profileRoutes,
      organizationRoutes,
      activityRoutes,
    ],
  ),
];

// GoRoute(

//   name: AppRoute.profile.name,
//   path: AppRoute.profile.path,
//   builder: (context, state) => const ProfileScreen(),
//   routes: [
//     GoRoute(
//         name: AppRoute.editProfile.name,
//         path: AppRoute.editProfile.path,
//         builder: (context, state) => ProfileEditScreen()),
//   ],
// ),
// GoRoute(
//     name: AppRoute.editProfile.name,
//     path: AppRoute.editProfile.path,
//     builder: (context, state) => EditProfileScreen()),
// GoRoute(
//   path: AppRoute.organizationRegistration.path,
//   name: AppRoute.organizationRegistration.name,
//   builder: (context, state) => const OrganizationRegistrationScreen(),
// ),

// ShellRoute(
//   navigatorKey: _shellNavigatorKey,
//   builder: (context, state, child) {
//     return CustomBottomNavigator(child: child);
//   },
//   routes: [
//     // GoRoute(
//     //   path: '/',
//     //   name: AppRoute.home.name,
//     //   builder: (context, state) => const HomeScreen(),
//     //   routes: [
//     // organizationRoutes,
//     // GoRoute(
//     //   name: AppRoute.accountVerificationCompleted.name,
//     //   path: AppRoute.accountVerificationCompleted.path,
//     //   builder: (context, state) =>
//     //       const AccountVerificationCompletedScreen(),
//     // ),
//     // GoRoute(
//     //   name: AppRoute.activities.name,
//     //   path: AppRoute.activities.path,
//     //   builder: (context, state) => const DevelopingScreen(),
//     // ),
//     // GoRoute(
//     //     name: AppRoute.news.name,
//     //     path: AppRoute.news.path,
//     //     builder: (context, state) => const DevelopingScreen()),
//     // GoRoute(
//     //     name: AppRoute.chat.name,
//     //     path: AppRoute.chat.path,
//     //     builder: (context, state) => const DevelopingScreen()),
//     // GoRoute(
//     //     name: AppRoute.notification.name,
//     //     path: AppRoute.notification.path,
//     //     builder: (context, state) => const DevelopingScreen()),
//     // GoRoute(
//     //     name: AppRoute.report.name,
//     //     path: AppRoute.report.path,
//     //     builder: (context, state) => const DevelopingScreen()),
//     // GoRoute(
//     //     name: AppRoute.settings.name,
//     //     path: AppRoute.settings.path,
//     //     builder: (context, state) => const DevelopingScreen()),
//     // GoRoute(
//     //     name: AppRoute.menu.name,
//     //     path: AppRoute.menu.path,
//     //     builder: (context, state) => const MenuScreen()),
//     // GoRoute(
//     //   name: AppRoute.organizationManage.name,
//     //   path: AppRoute.organizationManage.path,
//     //   builder: (_, __) => const OrganizationManageScreen(),
//     // ),
//     // GoRoute(
//     //   path: AppRoute.activitySearch.path,
//     //   name: AppRoute.activitySearch.name,
//     //   builder: (_, __) => const SearchActivityScreen(),
//     // ),
//     // GoRoute(
//     //   path: AppRoute.activityManage.path,
//     //   name: AppRoute.activityManage.name,
//     //   builder: (_, __) => const ActivityManageScreen(),
//     // ),
//     // GoRoute(
//     //   path: AppRoute.organizationSearch.path,
//     //   name: AppRoute.organizationSearch.name,
//     //   builder: (context, state) => const OrganizationSearchScreen(),
//     // ),
//     // GoRoute(
//     //   path: AppRoute.organization.path,
//     //   name: AppRoute.organization.name,
//     //   builder: (_, state) =>
//     //       OrganizationDetailScreen(orgId: state.params['id']!),
//     // ),
//     // GoRoute(
//     //   path: AppRoute.activity.path,
//     //   name: AppRoute.activity.name,
//     //   builder: (_, state) =>
//     //       const DetailActivityScreen(activityId: state.params['id']),
//     // ),
//     // ],
//     // ),
//   ],
// ),
// final authRoutes = [

// ];

final profileRoutes = GoRoute(
  path: AppRoute.profile.path,
  name: AppRoute.profile.name,
  builder: (_, __) => const ProfileScreen(),
  routes: [
    GoRoute(
      path: AppRoute.profileEdit.path,
      name: AppRoute.profileEdit.name,
      builder: (_, __) => ProfileEditScreen(),
    ),
    GoRoute(
      path: AppRoute.profileSetting.path,
      name: AppRoute.profileSetting.name,
      builder: (_, __) => const ProfileSettingScreen(),
    ),
  ],
);

final organizationRoutes = GoRoute(
  path: AppRoute.organizationManage.path,
  name: AppRoute.organizationManage.name,
  builder: (_, __) => const OrganizationManageScreen(),
  routes: [
    GoRoute(
      path: AppRoute.organizationSearch.path,
      name: AppRoute.organizationSearch.name,
      builder: (_, __) => const OrganizationSearchScreen(),
    ),
    GoRoute(
      path: AppRoute.organizationRegistration.path,
      name: AppRoute.organizationRegistration.name,
      builder: (_, __) => const OrganizationRegistrationScreen(),
    ),
    // Todo: parse
    GoRoute(
      path: AppRoute.organization.path,
      name: AppRoute.organization.name,
      builder: (_, state) => OrganizationDetailScreen(
        orgId: state.params[AppRoute.organization.path.substring(1)]!,
      ),
    ),
  ],
);

final shiftRoutes = [
  GoRoute(
    path: AppRoute.shifts.path,
    name: AppRoute.shifts.name,
    // Todo: repalce with implemented screen
    builder: (_, state) {
      final activityId =
          int.parse(state.params[AppRoute.activity.path.substring(1)]!);
      return ShiftsScreen(activityId: activityId);
    },
    routes: [
      GoRoute(
        path: AppRoute.shift.path,
        name: AppRoute.shift.name,
        // Todo: repalce with implemented screen
        builder: (_, state) {
          final activityId =
              int.parse(state.params[AppRoute.activity.path.substring(1)]!);
          final shiftId =
              int.parse(state.params[AppRoute.shift.path.substring(1)]!);
          return ShiftDetailScreen(
            activityId: activityId,
            shiftId: shiftId,
          );
        },
      ),
    ],
  ),
];

final activityRoutes = GoRoute(
  path: AppRoute.activityManage.path,
  name: AppRoute.activityManage.name,
  builder: (_, __) => const ActivityManageScreen(),
  routes: [
    GoRoute(
      path: AppRoute.activity.path,
      name: AppRoute.activity.name,
      builder: (_, state) {
        final activityId =
            int.parse(state.params[AppRoute.activity.path.substring(1)]!);
        return ActivityDetailScreen(
          activityId: activityId,
        );
      },
      routes: shiftRoutes,
    ),
    GoRoute(
      path: AppRoute.activitySearch.path,
      name: AppRoute.activitySearch.name,
      builder: (_, __) => const ActivitySearchScreen(),
    ),
  ],
);

enum AppRoute {
  // 404
  developing(
    path: '/developing',
    name: 'developing',
  ),

  home(
    path: '/home',
    name: 'home',
  ),
  changeRole(
    path: '/role',
    name: 'change-role',
  ),
  login(
    path: '/login',
    name: 'login',
  ),
  logout(
    path: '/logout',
    name: 'logout',
  ),
  accountVerification(
    path: '/verification',
    name: 'account-verification',
  ),

  // Todo: create modal instead of using this route
  accountVerificationCompleted(
      path: '/verification-completed', name: 'account-verification-completed'),

  // Todo: news crud
  news(
    path: '/news',
    name: 'news',
  ),
  chat(
    path: '/chat',
    name: 'chat',
  ),

  // Todo: notification crud
  notification(
    path: '/notification',
    name: 'notification',
  ),

  // Todo: report crud
  report(
    path: '/report',
    name: 'report',
  ),
  settings(
    path: '/settings',
    name: 'setting',
  ),

  // Quick access to develop screen
  testScreen(
    path: '/test',
    name: 'test',
  ),

  // Profile
  profile(
    path: '/profile',
    name: 'profile',
  ),
  profileEdit(
    path: 'edit',
    name: 'profile-edit',
  ),
  profileSetting(
    path: 'setting',
    name: 'profile-setting',
  ),

  // Org
  organizationManage(
    path: '/organization',
    name: 'organization-manage',
  ),
  organization(
    path: ':orgId',
    name: 'organization',
  ),
  organizationSearch(
    path: 'search',
    name: 'organization-search',
  ),
  organizationRegistration(
    path: 'registration',
    name: 'organization-registration',
  ),

  activitySearch(
    path: 'search',
    name: 'activity-search',
  ),
  activity(
    path: ':activityId',
    name: 'activity',
  ),
  activityManage(
    path: '/activity',
    name: 'activity-manage',
  ),

  // shift
  shifts(
    path: 'shift',
    name: 'shifts',
  ),
  shift(
    path: ':shiftId',
    name: 'shift',
  ),

  //Admin feature
  menu(
    path: '/menu',
    name: 'menu',
  ),

  accountManage(
    path: '/account-manage',
    name: 'account-manage',
  ),
  myOrganization(
    path: '/my-organization',
    name: 'my-organization',
  ),
  organizationMembersManagement(
    path: '/organization-members',
    name: 'organization-members',
  ),
  ;

  const AppRoute({
    required this.path,
    required this.name,
  });

  final String path;
  final String name;
}

final routerProvider = Provider.autoDispose<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider.notifier);

  return GoRouter(
    refreshListenable: notifier,
    initialLocation: AppRoute.home.path,
    navigatorKey: rootNavigatorKey,
    routes: routes,
    redirect: notifier.redirect,
  );
});
