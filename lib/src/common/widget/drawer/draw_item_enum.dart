import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/widget/drawer/draw_item_model.dart';
import 'package:the_helper/src/features/change_role/domain/user_role.dart';
import 'package:the_helper/src/features/organization/presentation/switch_organization/switch_organization_dialog.dart';
import 'package:the_helper/src/router/router.dart';

const List<DrawerItemModel> volunteer = [
  DrawerItemModel(
    route: AppRoute.home,
    title: 'Home',
    icon: Icons.home,
  ),
  DrawerItemModel(
    route: AppRoute.activities,
    title: 'Activities',
    icon: Icons.search,
  ),
  DrawerItemModel(
    route: AppRoute.organizationSearch,
    title: 'Organizations',
    icon: Icons.search,
  ),
  DrawerItemModel(
    route: AppRoute.myOrganization,
    title: 'My Organizations',
    icon: Icons.work_outline,
  ),
  DrawerItemModel(
    route: AppRoute.news,
    title: 'News',
    icon: Icons.newspaper,
  ),
  DrawerItemModel(
    route: AppRoute.chat,
    title: 'Chat',
    icon: Icons.chat,
  ),
  DrawerItemModel(
    route: AppRoute.report,
    title: 'Report',
    icon: Icons.report,
  ),
  DrawerItemModel(
    route: AppRoute.settings,
    title: 'Settings',
    icon: Icons.settings,
  ),
  // DrawerItemModel(
  //   route: AppRoute.changeRole,
  //   title: 'Switch Role',
  //   icon: Icons.change_circle,
  // ),
];

final List<DrawerItemModel> moderator = [
  const DrawerItemModel(
    route: AppRoute.home,
    title: 'Home',
    icon: Icons.home,
  ),
  const DrawerItemModel(
    route: AppRoute.organizationMembersManagement,
    title: 'Organization Members',
    icon: Icons.work_outline,
  ),
  const DrawerItemModel(
    // route: AppRoute.report,
    title: 'Chat',
    icon: Icons.report,
  ),
  const DrawerItemModel(
    route: AppRoute.settings,
    title: 'Settings',
    icon: Icons.settings,
  ),
  DrawerItemModel(
    title: 'Switch Organizations',
    icon: Icons.groups_outlined,
    onTap: (context) {
      context.pop();
      showDialog(
        context: context,
        builder: (context) => const SwitchOrganizationDialog(),
      );
    },
  ),
  const DrawerItemModel(
    route: AppRoute.changeRole,
    title: 'Switch Role',
    icon: Icons.change_circle,
  ),
];

const List<DrawerItemModel> admin = [
  DrawerItemModel(
    route: AppRoute.home,
    title: 'Home',
    icon: Icons.home,
  ),
  DrawerItemModel(
    route: AppRoute.accountManage,
    title: 'Accounts Manage',
    icon: Icons.search,
  ),
  DrawerItemModel(
    route: AppRoute.organizationManage,
    title: 'Organizations Manage',
    icon: Icons.search,
  ),
  DrawerItemModel(
    route: AppRoute.accountRequestManage,
    title: 'Verify Request',
    icon: Icons.app_registration,
  ),
  DrawerItemModel(
    // route: AppRoute.news,
    title: 'Reports Manage',
    icon: Icons.newspaper,
  ),
  DrawerItemModel(
    // route: AppRoute.chat,
    title: 'News Manage',
    icon: Icons.chat,
  ),
  DrawerItemModel(
    // route: AppRoute.report,
    title: 'Chat',
    icon: Icons.report,
  ),
  DrawerItemModel(
    route: AppRoute.settings,
    title: 'Settings',
    icon: Icons.settings,
  ),
  DrawerItemModel(
    route: AppRoute.changeRole,
    title: 'Switch Role',
    icon: Icons.change_circle,
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
