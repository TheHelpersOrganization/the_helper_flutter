import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/screens/screen404.dart';
import 'package:the_helper/src/common/widget/bottom_navigation_bar/bottom_navigator.dart';
import 'package:the_helper/src/features/authentication/presentation/account_verification_completed_screen.dart';
import 'package:the_helper/src/features/authentication/presentation/account_verification_screen.dart';
import 'package:the_helper/src/features/authentication/presentation/login_screen.dart';
import 'package:the_helper/src/features/authentication/presentation/logout_screen.dart';
import 'package:the_helper/src/features/menu/presentation/screens/menu_screen.dart';
import 'package:the_helper/src/features/organization/presentation/registration/organization_registration.dart';
import 'package:the_helper/src/features/organization/presentation/search/organization_search_screen.dart';
import 'package:the_helper/src/features/organization_manage/presentation/screens/organization_manage_screen.dart';

import '../common/screens/safe_screen.dart';
import '../features/profile/presentation/edit_profile_screen/edit_profile_screen.dart';
import '../features/profile/presentation/profile_screen/profile_screen.dart';
import '../features/organization/presentation/organization_detail/organization_detail_screen.dart';

import './router_notifier.dart';
import '../features/change_role/presentation/screens/change_role_screen.dart';
import '../features/change_role/presentation/screens/home_screen.dart';
import '../features/account_manage/presentation/screens/account_manage_screen.dart';
import '../features/account_request_manage/presentation/screens/account_request_manage_screen.dart';
import '../features/activity_manage/presentation/screens/activity_manage_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

final routes = [
  ShellRoute(
    builder: (context, state, child) {
      return SafeScreen(child: child);
    },
    routes: [
      GoRoute(
          name: AppRoute.login.name,
          path: AppRoute.login.path,
          builder: (context, state) => const LoginScreen()),
      GoRoute(
          name: AppRoute.logout.name,
          path: AppRoute.logout.path,
          builder: (context, state) => const LogoutScreen()),
      GoRoute(
          name: AppRoute.accountVerification.name,
          path: AppRoute.accountVerification.path,
          builder: (context, state) => const AccountVerificationScreen()),
      GoRoute(
          name: AppRoute.profile.name,
          path: AppRoute.profile.path,
          builder: (context, state) => const ProfileScreen()),
      GoRoute(
          name: AppRoute.editProfile.name,
          path: AppRoute.editProfile.path,
          builder: (context, state) => EditProfileScreen()),
      GoRoute(
        path: AppRoute.organizationRegistration.path,
        name: AppRoute.organizationRegistration.name,
        builder: (context, state) => const OrganizationRegistrationScreen(),
      ),
      GoRoute(
          name: AppRoute.changeRole.name,
          path: AppRoute.changeRole.path,
          builder: (context, state) => const ChangeRoleScreen()),
      GoRoute(
          name: AppRoute.accountManage.name,
          path: AppRoute.accountManage.path,
          builder: (context, state) => const AccountManageScreen()),
      GoRoute(
          name: AppRoute.accountRequestManage.name,
          path: AppRoute.accountRequestManage.path,
          builder: (context, state) => const AccountRequestManageScreen()),
      GoRoute(
          name: AppRoute.activityManage.name,
          path: AppRoute.activityManage.path,
          builder: (context, state) => const ActivityManageScreen()),
      GoRoute(
          name: AppRoute.organizationManage.name,
          path: AppRoute.organizationManage.path,
          builder: (context, state) => const OrganizationManageScreen()),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return CustomBottomNavigator(child: child);
        },
        routes: [
          GoRoute(
            name: AppRoute.home.name,
            path: AppRoute.home.path,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
              name: AppRoute.accountVerificationCompleted.name,
              path: AppRoute.accountVerificationCompleted.path,
              builder: (context, state) =>
                  const AccountVerificationCompletedScreen()),
          GoRoute(
              name: AppRoute.activities.name,
              path: AppRoute.activities.path,
              builder: (context, state) => const DevelopingScreen()),
          GoRoute(
              name: AppRoute.news.name,
              path: AppRoute.news.path,
              builder: (context, state) => const DevelopingScreen()),
          GoRoute(
              name: AppRoute.chat.name,
              path: AppRoute.chat.path,
              builder: (context, state) => const DevelopingScreen()),
          GoRoute(
              name: AppRoute.notification.name,
              path: AppRoute.notification.path,
              builder: (context, state) => const DevelopingScreen()),
          GoRoute(
              name: AppRoute.report.name,
              path: AppRoute.report.path,
              builder: (context, state) => const DevelopingScreen()),
          GoRoute(
              name: AppRoute.settings.name,
              path: AppRoute.settings.path,
              builder: (context, state) => const DevelopingScreen()),
          GoRoute(
              name: AppRoute.developing.name,
              path: AppRoute.developing.path,
              builder: (context, state) => const DevelopingScreen()),
          GoRoute(
              name: AppRoute.menu.name,
              path: AppRoute.menu.path,
              builder: (context, state) => const MenuScreen()),
          GoRoute(
            path: AppRoute.organizationSearch.path,
            name: AppRoute.organizationSearch.name,
            builder: (context, state) => const OrganizationSearchScreen(),
          ),
          GoRoute(
            path: AppRoute.organization.path,
            name: AppRoute.organization.name,
            builder: (_, state) =>
                OrganizationDetailScreen(orgId: state.params['id']!),
          ),
        ],
      ),
    ],
  ),
];

enum AppRoute {
  splash(path: '/splash', name: 'splash'), // Internal access only
  home(path: '/', name: 'home'),
  changeRole(path: '/change-role', name: 'change-role'),
  login(path: '/login', name: 'login'),
  logout(path: '/logout', name: 'logout'),
  accountVerification(
      path: '/account-verification', name: 'account-verification'),
  accountVerificationCompleted(
      path: '/account-verification-completed',
      name: 'account-verification-completed'),
  profile(path: '/profile', name: 'profile'),
  editProfile(path: '/profile/edit', name: 'profile-edit'),
  profileSetting(
    path: '/profile/setting',
    name: 'profile-setting',
  ),
  activities(path: '/activities', name: 'activities'),
  news(path: '/news', name: 'news'),
  chat(path: '/chat', name: 'chat'),
  notification(path: '/notification', name: 'notification'),
  report(path: '/report', name: 'report'),
  settings(path: '/settings', name: 'setting'),

  // Quick access to develop screen
  testScreen(path: '/test', name: 'test'),

  developing(path: '/not-exist', name:'not-exist'),

  //Admin feature
  menu(
    path: '/menu',
    name: 'menu',
  ),
  organization(
    path: '/organization/:id',
    name: 'organization',
  ),
  accountManage(path: '/account-manage', name: 'account-manage'),
  accountRequestManage(path: '/account-request-manage', name: 'account-request-manage'),
  activityManage(path: '/activity-manage', name: 'activity-manage'),
  organizationManage(path: '/organization-manage', name: 'organization-manage'),
  organizationSearch(
    path: '/organization-search',
    name: 'organization-search',
  ),
  organizationRegistration(
    path: '/organization-registration',
    name: 'organization-registration',
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
    navigatorKey: _rootNavigatorKey,
    routes: routes,
    redirect: notifier.redirect,
  );
});
