import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/widget/drawer/draw_item_model.dart';
import 'package:the_helper/src/features/change_role/domain/user_role.dart';
import 'package:the_helper/src/features/organization/data/mod_organization_repository.dart';
import 'package:the_helper/src/features/organization/presentation/switch_organization/switch_organization_dialog.dart';
import 'package:the_helper/src/router/router.dart';

const List<DrawerItemModel> volunteer = [
  DrawerItemModel(
    route: AppRoute.home,
    title: 'Home',
    icon: Icons.home_outlined,
    enabled: true,
  ),
  DrawerItemModel(
    route: AppRoute.activitySearch,
    title: 'Activities',
    icon: Icons.search_outlined,
    enabled: true,
  ),
  DrawerItemModel(
    route: AppRoute.activityMy,
    title: 'My Shifts',
    icon: Icons.volunteer_activism_outlined,
  ),
  DrawerItemModel(
    route: AppRoute.organizationSearch,
    title: 'Organizations',
    icon: Icons.search_outlined,
    enabled: true,
  ),
  DrawerItemModel(
    route: AppRoute.myOrganization,
    title: 'My Organizations',
    icon: Icons.work_outline,
  ),
  DrawerItemModel(
    route: AppRoute.news,
    title: 'News',
    icon: Icons.newspaper_outlined,
  ),
  DrawerItemModel(
    route: AppRoute.reportHistory,
    title: 'Report history',
    icon: Icons.timelapse,
  ),
  DrawerItemModel(
    route: AppRoute.chats,
    title: 'Chat',
    icon: Icons.chat_outlined,
  ),
  DrawerItemModel(
    route: AppRoute.organizationRegistration,
    title: 'Create organization',
    icon: Icons.group_add,
  ),
  // DrawerItemModel(
  //   route: AppRoute.report,
  //   title: 'Report',
  //   icon: Icons.report_outlined,
  // ),
];

final List<DrawerItemModel> moderator = [
  const DrawerItemModel(
    route: AppRoute.home,
    title: 'Home',
    icon: Icons.home_outlined,
  ),
  const DrawerItemModel(
    route: AppRoute.organizationMembersManagement,
    title: 'Organization Members',
    icon: Icons.person_outline,
  ),
  const DrawerItemModel(
    route: AppRoute.organizationActivityListManagement,
    title: 'Organization Activities',
    icon: Icons.work_outline,
  ),
  const DrawerItemModel(
    route: AppRoute.organizationNews,
    title: 'Organization News',
    icon: Icons.newspaper_outlined,
  ),
  const DrawerItemModel(
    route: AppRoute.chats,
    title: 'Chat',
    icon: Icons.chat_outlined,
  ),
  const DrawerItemModel(
    route: AppRoute.reportHistory,
    title: 'Report history',
    icon: Icons.timelapse,
  ),
  DrawerItemModel(
    title: 'Switch Organizations',
    icon: Icons.groups_outlined,
    onTap: (context) {
      context.pop();
      showDialog(
        context: context,
        useRootNavigator: false,
        builder: (context) => const SwitchOrganizationDialog(),
      );
    },
  ),
  const DrawerItemModel(
    route: AppRoute.organizationRegistration,
    title: 'Create organization',
    icon: Icons.group_add,
  ),
];

const List<DrawerItemModel> admin = [
  DrawerItemModel(
    route: AppRoute.home,
    title: 'Home',
    icon: Icons.home_outlined,
  ),
  DrawerItemModel(
    route: AppRoute.accountManage,
    title: 'Accounts',
    icon: Icons.account_circle_outlined,
    subPaths: [
      DrawerItemModel(
        route: AppRoute.accountManage,
        title: 'Accounts manage',
        icon: Icons.search_outlined,
      ),
      DrawerItemModel(
        route: AppRoute.accountRequestManage,
        title: 'Accounts requests manage',
        icon: Icons.search_outlined,
      ),
    ],
  ),
  DrawerItemModel(
    title: 'Organizations',
    icon: Icons.work,
    subPaths: [
      DrawerItemModel(
        route: AppRoute.organizationAdminManage,
        title: 'Organizations manage',
        icon: Icons.search_outlined,
      ),
      DrawerItemModel(
        route: AppRoute.organizationRequestsManage,
        title: 'Organizations requests manage',
        icon: Icons.search_outlined,
      ),
    ],
  ),
  DrawerItemModel(
    route: AppRoute.activityManage,
    title: 'Activities manage',
    icon: Icons.volunteer_activism,
  ),
  DrawerItemModel(
    route: AppRoute.reportManage,
    title: 'Reports manage',
    icon: Icons.newspaper_outlined,
  ),
  DrawerItemModel(
    route: AppRoute.chats,
    title: 'Chat',
    icon: Icons.chat_outlined,
  ),
];

List<DrawerItemModel> getDrawerItem(Role role) {
  switch (role) {
    case Role.moderator:
      return moderator;
    case Role.admin:
      return admin;
    default:
      return volunteer;
  }
}

final joinedOrganizationsProvider = FutureProvider(
  (ref) => ref.watch(modOrganizationRepositoryProvider).getOwnedOrganizations(),
);
