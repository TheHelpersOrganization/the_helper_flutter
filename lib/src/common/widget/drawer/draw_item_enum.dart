import 'package:flutter/material.dart';
import 'package:the_helper/src/common/widget/drawer/draw_item_model.dart';
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
    route: AppRoute.organizationRegistration,
    title: 'Register Organization',
    icon: Icons.app_registration,
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
  DrawerItemModel(
    route: AppRoute.changeRole,
    title: 'Switch Role',
    icon: Icons.change_circle,
  ),
];

const List<DrawerItemModel> moderator = [
  DrawerItemModel(
    route: AppRoute.home,
    title: 'Home',
    icon: Icons.home,
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

List<DrawerItemModel> getDrawerItem(int role) {
  switch (role) {
    case 2:
      return moderator;
    case 3:
      return admin;
    default:
      return volunteer;
  }
}
