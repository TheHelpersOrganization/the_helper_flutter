import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer_header.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer_item.dart';

import '../../../features/authentication/presentation/logout_controller.dart';
import '../../../router/router.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) => Drawer(
        child: SingleChildScrollView(
          child: _buildDrawerItem(context, ref),
          padding: const EdgeInsets.only(right: 8),
        ),
      );

  _buildDrawerItem(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        SafeArea(
          child: InkWell(
            onTap: () => context.goNamed(AppRoute.profile.name),
            child: const AppDrawerHeader(),
          ),
        ),
        const Divider(),
        AppDrawerItem(
          // route: AppRoute.home,
          path: AppRoute.home.path,
          title: 'Home',
          icon: Icons.home,
          onTap: () => context.goNamed(AppRoute.home.name),
        ),
        // AppDrawerItem(
        //   // route: AppRoute.activities,
        //   path: '/activities',
        //   title: 'Activities',
        //   icon: Icons.search,
        //   onTap: () {
        //     context.goNamed(AppRoute.activities.name);
        //   },
        // ),
        AppDrawerItem(
          // route: AppRoute.organizationSearch,
          path: AppRoute.organizationManage.path,
          title: 'Organization',
          icon: Icons.search,
          onTap: () {
            context.goNamed(AppRoute.organizationSearch.name);
          },
        ),
        AppDrawerItem(
          // route: AppRoute.organizationRegistration,
          path: AppRoute.organizationRegistration.path,
          title: 'Register Organization',
          icon: Icons.app_registration,
          onTap: () {
            context.goNamed(AppRoute.organizationRegistration.name);
          },
        ),
        AppDrawerItem(
            title: 'News',
            icon: Icons.newspaper,
            onTap: () => context.goNamed(AppRoute.news.name)),
        AppDrawerItem(
            title: 'Chat',
            icon: Icons.chat,
            onTap: () => context.goNamed(AppRoute.chat.name)),
        AppDrawerItem(
            title: 'Report',
            icon: Icons.report,
            onTap: () => context.goNamed(AppRoute.report.name)),
        const Divider(),
        AppDrawerItem(
            title: 'Settings',
            icon: Icons.settings,
            onTap: () => context.goNamed(AppRoute.settings.name)),
        AppDrawerItem(
            title: 'Switch Role',
            icon: Icons.change_circle,
            onTap: () => context.goNamed(AppRoute.changeRole.name)),
        AppDrawerItem(
            title: 'Logout',
            icon: Icons.logout,
            onTap: () => ref.read(logoutControllerProvider).signOut()),
      ],
    );
  }
}
