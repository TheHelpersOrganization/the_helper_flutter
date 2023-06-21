import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/screens/safe_screen.dart';
import 'package:the_helper/src/common/screens/screen404.dart';
import 'package:the_helper/src/common/widget/bottom_navigation_bar/bottom_navigator.dart';
import 'package:the_helper/src/features/account/presentation/account_request_manage/screens/account_request_manage_screen.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/screen/activity_detail_screen.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_creation/screen/mod_activity_creation_screen.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_creation/screen/mod_activity_manager_chooser.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_list_management/screen/mod_activity_list_management_screen.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_management/screen/mod_activity_management_screen.dart';
import 'package:the_helper/src/features/activity/presentation/search/screen/activity_search_screen.dart';
import 'package:the_helper/src/features/activity/presentation/shift/shift_detail_screen.dart';
import 'package:the_helper/src/features/activity/presentation/shift/shifts_screen.dart';
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
import 'package:the_helper/src/features/organization_member/presentation/member_mangement/organization_member_management_screen.dart';
import 'package:the_helper/src/features/profile/presentation/profile/profile_screen.dart';
import 'package:the_helper/src/features/profile/presentation/profile_edit/profile_edit_screen.dart';
import 'package:the_helper/src/features/profile/presentation/profile_setting/profile_setting_screen.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift/screen/mod_shift_screen.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_creation/screen/mod_shift_creation_screen.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_creation/widget/shift_skill_view.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_volunteer/shift_volunteer_screen.dart';
import 'package:the_helper/src/router/router_notifier.dart';

import '../features/account/presentation/account_admin_manage/screens/account_manage_screen.dart';
import '../features/organization/presentation/admin_manage/screens/organization_admin_manage_screen.dart';

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
        path: AppRoute.changeRole.path,
        name: AppRoute.changeRole.name,
        builder: (_, __) => const ChangeRoleScreen(),
      ),
      GoRoute(
        path: AppRoute.organizationMembersManagement.path,
        name: AppRoute.organizationMembersManagement.name,
        builder: (context, state) =>
            const OrganizationMembersManagementScreen(),
      ),
      GoRoute(
        path: AppRoute.organizationActivityListManagement.path,
        name: AppRoute.organizationActivityListManagement.name,
        builder: (_, __) => const ModActivityListManagementScreen(),
        routes: [
          GoRoute(
              path: AppRoute.organizationActivityManagement.path,
              name: AppRoute.organizationActivityManagement.name,
              builder: (_, state) {
                final activityId =
                    int.parse(state.pathParameters['activityId']!);
                return ModActivityManagementScreen(activityId: activityId);
              },
              routes: [
                GoRoute(
                  path: AppRoute.shiftCreation.path,
                  name: AppRoute.shiftCreation.name,
                  builder: (_, state) {
                    final activityId =
                        int.parse(state.pathParameters['activityId']!);
                    return ModShiftCreationScreen(
                      activityId: activityId,
                    );
                  },
                  routes: [
                    GoRoute(
                      path: AppRoute.shiftCreationSkill.path,
                      name: AppRoute.shiftCreationSkill.name,
                      builder: (_, state) {
                        return ShiftSkillView(
                          skills: state.extra as dynamic,
                        );
                      },
                    )
                  ],
                ),
                GoRoute(
                  path: AppRoute.organizationShift.path,
                  name: AppRoute.organizationShift.name,
                  builder: (_, state) {
                    final activityId = int.parse(
                      state.pathParameters['activityId']!,
                    );
                    final shiftId = int.parse(
                      state.pathParameters['shiftId']!,
                    );
                    return ModShiftScreen(
                      activityId: activityId,
                      shiftId: shiftId,
                    );
                  },
                  routes: [
                    GoRoute(
                      path: AppRoute.shiftVolunteer.path,
                      name: AppRoute.shiftVolunteer.name,
                      builder: (_, state) {
                        final activityId = int.parse(
                          state.pathParameters['activityId']!,
                        );
                        final shiftId = int.parse(
                          state.pathParameters['shiftId']!,
                        );
                        return ShiftVolunteerScreen(
                          activityId: activityId,
                          shiftId: shiftId,
                        );
                      },
                    ),
                  ],
                ),
              ]),
        ],
      ),
      GoRoute(
        path: AppRoute.organizationActivityCreation.path,
        name: AppRoute.organizationActivityCreation.name,
        builder: (_, __) => const ModActivityCreationScreen(),
        routes: [
          GoRoute(
            path: AppRoute.organizationActivityCreationManagerChooser.path,
            name: AppRoute.organizationActivityCreationManagerChooser.name,
            builder: (_, __) => const ModActivityManagerChooser(),
          ),
        ],
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
          ),
          GoRoute(
            path: AppRoute.accountManage.path,
            name: AppRoute.accountManage.name,
            builder: (context, state) => const AccountManageScreen(),
          ),
          GoRoute(
            path: AppRoute.organizationAdminManage.path,
            name: AppRoute.organizationAdminManage.name,
            builder: (context, state) => const OrganizationAdminManageScreen(),
          ),
        ],
      ),
      accountRoutes,
      profileRoutes,
      organizationRoutes,
      activityRoutes,
    ],
  ),
];

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
    GoRoute(
      path: AppRoute.organization.path,
      name: AppRoute.organization.name,
      builder: (_, state) => OrganizationDetailScreen(
        orgId: int.parse(
          state.pathParameters[AppRoute.organization.path.substring(1)]!,
        ),
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
          int.parse(state.pathParameters[AppRoute.activity.path.substring(1)]!);
      return ShiftsScreen(activityId: activityId);
    },
    routes: [
      GoRoute(
        path: AppRoute.shift.path,
        name: AppRoute.shift.name,
        // Todo: repalce with implemented screen
        builder: (_, state) {
          final activityId = int.parse(
              state.pathParameters[AppRoute.activity.path.substring(1)]!);
          final shiftId = int.parse(state
              .pathParameters[AppRoute.organizationShift.path.substring(1)]!);
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
  builder: (_, __) => const DevelopingScreen(),
  routes: [
    GoRoute(
      path: AppRoute.activitySearch.path,
      name: AppRoute.activitySearch.name,
      builder: (_, __) => const ActivitySearchScreen(),
    ),
    GoRoute(
      path: AppRoute.activity.path,
      name: AppRoute.activity.name,
      builder: (_, state) {
        final activityId = int.parse(state.pathParameters['activityId']!);
        return ActivityDetailScreen(
          activityId: activityId,
        );
      },
      routes: shiftRoutes,
    ),
  ],
);

final accountRoutes = GoRoute(
  path: AppRoute.account.path,
  name: AppRoute.account.name,
  builder: (_, __) => const DevelopingScreen(),
  routes: [
    GoRoute(
      path: AppRoute.accountVerification.path,
      name: AppRoute.accountVerification.name,
      builder: (context, state) => const AccountVerificationScreen(),
    ),
    GoRoute(
      path: AppRoute.accountVerificationCompleted.path,
      name: AppRoute.accountVerificationCompleted.name,
      builder: (context, state) => const AccountVerificationCompletedScreen(),
    ),
    GoRoute(
      path: AppRoute.accountRequestManage.path,
      name: AppRoute.accountRequestManage.name,
      builder: (context, state) => const AccountRequestManageScreen(),
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

  // Todo: create modal instead of using this route
  account(
    path: '/account',
    name: 'account',
  ),
  accountVerification(
    path: 'verification',
    name: 'account-verification',
  ),
  accountVerificationCompleted(
    path: 'verification-completed',
    name: 'account-verification-completed',
  ),
  accountRequestManage(
    path: 'manage',
    name: 'account-request-manage',
  ),

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
  organizationRequestsManage(
    path: '/organization-requests',
    name: 'organization-requests-manage',
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
  organizationMembersManagement(
    path: '/organization-members',
    name: 'organization-members',
  ),

  activityManage(
    path: '/activity',
    name: 'activity-manage',
  ),
  activitySearch(
    path: 'search',
    name: 'activity-search',
  ),
  activity(
    path: ':activityId',
    name: 'activity',
  ),

  organizationActivityListManagement(
    path: '/activity-management',
    name: 'activity-list-management',
  ),
  organizationActivityManagement(
    path: ':activityId',
    name: 'activity-management',
  ),
  organizationShift(
    path: 'shift/:shiftId',
    name: 'organization-shift',
  ),
  shiftCreation(
    path: 'shift/create',
    name: 'shift-creation',
  ),
  shiftCreationSkill(
    path: 'shift/create/skills',
    name: 'shift-creation-skills',
  ),

  organizationActivityCreation(
    path: '/activity-creation',
    name: 'activity-creation',
  ),
  organizationActivityCreationManagerChooser(
    path: 'managers',
    name: 'activity-creation-manager-chooser',
  ),
  shiftVolunteer(
    path: 'volunteer',
    name: 'shift-volunteer',
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
  organizationAdminManage(
    path: '/organization-admin-manage',
    name: 'organization-admin-manage',
  ),
  myOrganization(
    path: '/my-organization',
    name: 'my-organization',
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
    errorBuilder: (context, state) => const DevelopingScreen(),
  );
});
