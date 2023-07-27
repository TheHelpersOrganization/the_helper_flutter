import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/screens/safe_screen.dart';
import 'package:the_helper/src/common/screens/screen404.dart';
import 'package:the_helper/src/features/account/presentation/account_request_manage/screens/account_request_detail_screen.dart';
import 'package:the_helper/src/features/account/presentation/account_request_manage/screens/account_request_manage_screen.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/screen/activity_detail_screen.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_creation/screen/mod_activity_creation_screen.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_edit/screen/mod_activity_edit_basic_screen.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_edit/screen/mod_activity_edit_contact_screen.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_edit/screen/mod_activity_edit_manager_screen.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_list_management/screen/mod_activity_list_management_screen.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_management/screen/mod_activity_management_screen.dart';
import 'package:the_helper/src/features/activity/presentation/search/screen/activity_search_screen.dart';
import 'package:the_helper/src/features/activity/presentation/search/screen/suggested_activity_screen.dart';
import 'package:the_helper/src/features/authentication/presentation/account_verification_completed_screen.dart';
import 'package:the_helper/src/features/authentication/presentation/account_verification_screen.dart';
import 'package:the_helper/src/features/authentication/presentation/login_screen.dart';
import 'package:the_helper/src/features/authentication/presentation/logout_screen.dart';
import 'package:the_helper/src/features/change_role/presentation/screens/change_role_screen.dart';
import 'package:the_helper/src/features/change_role/presentation/screens/home_screen.dart';
import 'package:the_helper/src/features/menu/presentation/screens/menu_screen.dart';
import 'package:the_helper/src/features/organization/presentation/admin_manage/screens/organization_request_manage_screen.dart';
import 'package:the_helper/src/features/organization/presentation/my/my_organization_screen.dart';
import 'package:the_helper/src/features/organization/presentation/organization_detail/screen/organization_detail_screen.dart';
import 'package:the_helper/src/features/organization/presentation/organization_registration/organization_registration.dart';
import 'package:the_helper/src/features/organization/presentation/organization_search/organization_search_screen.dart';
import 'package:the_helper/src/features/organization/presentation/organization_transfer_ownership/screen/organization_transfer_ownership_screen.dart';
import 'package:the_helper/src/features/organization/presentation/organization_transfer_ownership/screen/organization_transfer_ownership_success_screen.dart';
import 'package:the_helper/src/features/organization_member/presentation/member_mangement/screen/organization_member_management_screen.dart';
import 'package:the_helper/src/features/organization_member/presentation/member_mangement/screen/organization_member_role_assignment_screen.dart';
import 'package:the_helper/src/features/profile/presentation/profile/profile_screen.dart';
import 'package:the_helper/src/features/profile/presentation/profile_edit/profile_edit_screen.dart';
import 'package:the_helper/src/features/profile/presentation/profile_setting/profile_setting_screen.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift/screen/mod_shift_screen.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_creation/screen/mod_shift_creation_screen.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_creation/widget/shift_skill_view.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_edit/screen/mod_shift_edit_basic_screen.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_edit/screen/mod_shift_edit_contact_screen.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_edit/screen/mod_shift_edit_manager_screen.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_edit/screen/mod_shift_edit_skill_screen.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_volunteer/shift_volunteer_screen.dart';
import 'package:the_helper/src/features/shift/presentation/my_shift/screen/my_shift_screen.dart';
import 'package:the_helper/src/features/shift/presentation/shift/screen/shift_screen.dart';
import 'package:the_helper/src/router/chat_routes.dart';
import 'package:the_helper/src/router/notification_routes.dart';
import 'package:the_helper/src/router/router_notifier.dart';

import '../features/account/presentation/account_admin_manage/screens/account_manage_screen.dart';
import '../features/organization/presentation/admin_manage/screens/organization_admin_manage_screen.dart';
import '../features/profile/presentation/other_user_profile/other_user_profile_screen.dart';
import '../features/profile/presentation/profile_verified_request/profile_verified_request_screen.dart';
import '../features/report/presentation/admin_report_manage/screen/report_manage_screen.dart';
import '../features/report/presentation/report_detail/screen/report_detail_screen.dart';
import '../features/report/presentation/report_detail/screen/user_report_detail_screen.dart';
import '../features/report/presentation/user_report_history/screen/report_history_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

final routes = [
  ShellRoute(
    navigatorKey: shellNavigatorKey,
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
        routes: [
          GoRoute(
            path: AppRoute.organizationMemberRoleAssignment.path,
            name: AppRoute.organizationMemberRoleAssignment.name,
            builder: (context, state) => OrganizationMemberRoleAssignmentScreen(
              memberId: int.parse(
                state.pathParameters['memberId']!,
              ),
            ),
          ),
        ],
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
                  path: AppRoute.activityEdit.path,
                  name: AppRoute.activityEdit.name,
                  builder: (context, state) {
                    final activityId =
                        int.parse(state.pathParameters['activityId']!);
                    return ModActivityEditBasicScreen(activityId: activityId);
                  },
                ),
                GoRoute(
                  path: AppRoute.activityEditContact.path,
                  name: AppRoute.activityEditContact.name,
                  builder: (context, state) {
                    final activityId =
                        int.parse(state.pathParameters['activityId']!);
                    return ModActivityEditContactScreen(activityId: activityId);
                  },
                ),
                GoRoute(
                  path: AppRoute.activityEditManager.path,
                  name: AppRoute.activityEditManager.name,
                  builder: (context, state) {
                    final activityId =
                        int.parse(state.pathParameters['activityId']!);
                    return ModActivityEditManagerScreen(activityId: activityId);
                  },
                ),
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
                GoRoute(
                  path: AppRoute.shiftEdit.path,
                  name: AppRoute.shiftEdit.name,
                  builder: (context, state) {
                    final activityId =
                        int.parse(state.pathParameters['activityId']!);
                    final shiftId = int.parse(state.pathParameters['shiftId']!);
                    return ModShiftEditBasicScreen(
                        activityId: activityId, shiftId: shiftId);
                  },
                ),
                GoRoute(
                  path: AppRoute.shiftEditSkills.path,
                  name: AppRoute.shiftEditSkills.name,
                  builder: (context, state) {
                    final activityId =
                        int.parse(state.pathParameters['activityId']!);
                    final shiftId = int.parse(state.pathParameters['shiftId']!);
                    return ModShiftEditSkillScreen(
                        activityId: activityId, shiftId: shiftId);
                  },
                ),
                GoRoute(
                  path: AppRoute.shiftEditContacts.path,
                  name: AppRoute.shiftEditContacts.name,
                  builder: (context, state) {
                    final activityId =
                        int.parse(state.pathParameters['activityId']!);
                    final shiftId = int.parse(state.pathParameters['shiftId']!);
                    return ModShiftEditContactScreen(
                        activityId: activityId, shiftId: shiftId);
                  },
                ),
                GoRoute(
                  path: AppRoute.shiftEditManagers.path,
                  name: AppRoute.shiftEditManagers.name,
                  builder: (context, state) {
                    final activityId =
                        int.parse(state.pathParameters['activityId']!);
                    final shiftId = int.parse(state.pathParameters['shiftId']!);
                    return ModShiftEditManagerScreen(
                        activityId: activityId, shiftId: shiftId);
                  },
                ),
              ]),
        ],
      ),
      GoRoute(
        path: AppRoute.organizationActivityCreation.path,
        name: AppRoute.organizationActivityCreation.name,
        builder: (_, __) => const ModActivityCreationScreen(),
      ),
      GoRoute(
        path: AppRoute.home.path,
        name: AppRoute.home.name,
        builder: (_, __) => const HomeScreen(),
        routes: [
          notificationRoutes,
        ],
      ),
      GoRoute(
        path: AppRoute.news.path,
        name: AppRoute.news.name,
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
      GoRoute(
        path: AppRoute.organizationRequestsManage.path,
        name: AppRoute.organizationRequestsManage.name,
        builder: (context, state) => const OrganizationRequestManageScreen(),
      ),
      GoRoute(
          path: AppRoute.accountRequestManage.path,
          name: AppRoute.accountRequestManage.name,
          builder: (context, state) => const AccountRequestManageScreen(),
          routes: [
            GoRoute(
              path: AppRoute.accountRequestDetail.path,
              name: AppRoute.accountRequestDetail.name,
              builder: (_, state) => AccountRequestDetailScreen(
                requestId: int.parse(
                  state.pathParameters[
                      AppRoute.accountRequestDetail.path.substring(1)]!,
                ),
              ),
            ),
          ]),
      GoRoute(
          path: AppRoute.reportManage.path,
          name: AppRoute.reportManage.name,
          builder: (context, state) => const ReportManageScreen(),
          routes: [
            GoRoute(
              path: AppRoute.reportDetail.path,
              name: AppRoute.reportDetail.name,
              builder: (_, state) => ReportDetailScreen(
                id: int.parse(
                  state
                      .pathParameters[AppRoute.reportDetail.path.substring(1)]!,
                ),
              ),
            ),
          ]),
      GoRoute(
          path: AppRoute.reportHistory.path,
          name: AppRoute.reportHistory.name,
          builder: (context, state) => const ReportHistoryScreen(),
          routes: [
            GoRoute(
              path: AppRoute.reportHistoryDetail.path,
              name: AppRoute.reportHistoryDetail.name,
              builder: (_, state) => UserReportDetailScreen(
                requestId: int.parse(
                  state.pathParameters[
                      AppRoute.reportHistoryDetail.path.substring(1)]!,
                ),
              ),
            ),
          ]),
      accountRoutes,
      profileRoutes,
      ...organizationRoutes,
      ...activityRoutes,
      chatRoutes,
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
    GoRoute(
      path: AppRoute.profileVerified.path,
      name: AppRoute.profileVerified.name,
      builder: (_, __) => ProfileVerifiedRequestScreen(),
    ),
    GoRoute(
      path: AppRoute.otherProfile.path,
      name: AppRoute.otherProfile.name,
      builder: (_, state) => OtherUserProfileScreen(
        userId: int.parse(
          state.pathParameters[AppRoute.otherProfile.path.substring(1)]!,
        ),
      ),
    ),
  ],
);

final organizationRoutes = [
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
    path: AppRoute.organizationTransferOwnership.path,
    name: AppRoute.organizationTransferOwnership.name,
    builder: (_, __) => const OrganizationTransferOwnershipScreen(),
  ),
  GoRoute(
    path: AppRoute.organizationTransferOwnershipSuccess.path,
    name: AppRoute.organizationTransferOwnershipSuccess.name,
    builder: (_, __) => const OrganizationTransferOwnershipSuccessScreen(),
  ),
  GoRoute(
    path: AppRoute.organization.path,
    name: AppRoute.organization.name,
    builder: (_, state) => OrganizationDetailScreen(
      orgId: int.parse(
        state.pathParameters['orgId']!,
      ),
    ),
  ),
];

final shiftRoutes = [
  GoRoute(
    path: AppRoute.shift.path,
    name: AppRoute.shift.name,
    // Todo: repalce with implemented screen
    builder: (_, state) {
      final activityId = int.parse(state.pathParameters['activityId']!);
      final shiftId = int.parse(state.pathParameters['shiftId']!);

      return ShiftScreen(
        activityId: activityId,
        shiftId: shiftId,
      );
    },
  ),
];

final activityRoutes = [
  GoRoute(
    path: AppRoute.activitySearch.path,
    name: AppRoute.activitySearch.name,
    builder: (_, __) => const ActivitySearchScreen(),
    routes: [
      GoRoute(
        path: AppRoute.activitySuggestion.path,
        name: AppRoute.activitySuggestion.name,
        builder: (_, __) => const SuggestedActivityScreen(),
      ),
    ],
  ),
  GoRoute(
    path: AppRoute.activityMy.path,
    name: AppRoute.activityMy.name,
    builder: (_, __) => const MyShiftScreen(),
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
];

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

  // Todo: news crud
  news(
    path: '/news',
    name: 'news',
  ),

  chats(
    path: '/chat',
    name: 'chats',
  ),
  initialChat(
    path: 'to/:chatId',
    name: 'initial-chat',
  ),
  chat(
    path: ':chatId',
    name: 'chat',
  ),

  // Todo: notification crud
  notifications(
    path: 'notification',
    name: 'notifications',
  ),
  notificationsDelete(path: 'delete', name: 'notifications-delete'),
  notification(
    path: ':notificationId',
    name: 'notification',
  ),

  // Todo: report crud
  reportManage(
    path: '/report-manage',
    name: 'report-manage',
  ),
  reportDetail(path: ':reportId', name: 'report-detaail'),
  reportHistory(path: '/report-history', name: 'report-history'),
  reportHistoryDetail(path: ':reportId', name: 'report-history-detail'),
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
  otherProfile(
    path: ':userId',
    name: 'profile-other',
  ),
  profileEdit(
    path: 'edit',
    name: 'profile-edit',
  ),
  profileSetting(
    path: 'setting',
    name: 'profile-setting',
  ),
  profileVerified(
    path: 'verified',
    name: 'profile-verified',
  ),

  // Org
  // organizationManage(
  //   path: '/organization',
  //   name: 'organization-manage',
  // ),
  organizationRequestsManage(
    path: '/organization-requests',
    name: 'organization-requests-manage',
  ),
  organization(
    path: '/organization/:orgId',
    name: 'organization',
  ),
  organizationSearch(
    path: '/organization/search',
    name: 'organization-search',
  ),
  organizationRegistration(
    path: '/organization/registration',
    name: 'organization-registration',
  ),
  organizationMembersManagement(
    path: '/organization-members',
    name: 'organization-members',
  ),
  organizationMemberRoleAssignment(
    path: ':memberId/roles',
    name: 'organization-member-role-assignment',
  ),
  organizationTransferOwnership(
    path: '/organization/transfer-ownership',
    name: 'organization-transfer-ownership',
  ),
  organizationTransferOwnershipSuccess(
    path: '/organization/transfer-ownership/success',
    name: 'organization-transfer-ownership-success',
  ),

  activityManage(
    path: '/activity',
    name: 'activity-manage',
  ),
  activitySearch(
    path: '/activity/search',
    name: 'activity-search',
  ),
  activitySuggestion(
    path: 'suggestion',
    name: 'activity-suggestion',
  ),
  activityMy(
    path: '/activity/my',
    name: 'activity-my',
  ),
  activity(
    path: '/activity/:activityId',
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
  activityEdit(
    path: 'edit',
    name: 'activity-edit',
  ),
  activityEditContact(
    path: 'edit/contacts',
    name: 'activity-edit-contact',
  ),
  activityEditManager(
    path: 'edit/managers',
    name: 'activity-edit-manager',
  ),
  organizationShift(
    path: 'shift/:shiftId',
    name: 'organization-shift',
  ),
  shiftEdit(
    path: 'shift/:shiftId/edit',
    name: 'shift-edit',
  ),
  shiftEditSkills(
    path: 'shift/:shiftId/edit/skills',
    name: 'shift-edit-skill',
  ),
  shiftEditContacts(
    path: 'shift/:shiftId/edit/contacts',
    name: 'shift-edit-contact',
  ),
  shiftEditManagers(
    path: 'shift/:shiftId/edit/managers',
    name: 'shift-edit-managers',
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
    path: 'shift/:shiftId',
    name: 'shift',
  ),

  //Admin feature
  menu(
    path: '/menu',
    name: 'menu',
  ),

  accountManage(
    path: '/accounts',
    name: 'accounts',
  ),
  organizationAdminManage(
    path: '/organization-admin-manage',
    name: 'organization-admin-manage',
  ),
  myOrganization(
    path: '/my-organization',
    name: 'my-organization',
  ),
  accountRequestManage(
    path: '/account-requests',
    name: 'account-requests',
  ),
  accountRequestDetail(
    path: ':requestId',
    name: 'account-requests-detail',
  ),
  screenBuilderCanvas(
    path: '/screen-builder',
    name: 'screen-builder',
  ),
  ;

  const AppRoute({
    required this.path,
    required this.name,
  });

  final String path;
  final String name;
}

final routerProvider = Provider<GoRouter>((ref) {
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
