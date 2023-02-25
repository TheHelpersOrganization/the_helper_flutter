import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_auth_flutter_riverpod/src/common/widget/drawer/app_drawer_header.dart';
import 'package:simple_auth_flutter_riverpod/src/common/widget/drawer/app_drawer_item.dart';

import '../../../router/router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(child: _buildDrawerItem(context)),
      );

  _buildDrawerItem(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => context.go(Routes.profile),
          child: const AppDrawerHeader(),
        ),
        const Divider(),
        AppDrawerItem(
          route: Routes.home,
          title: 'Home',
          icon: Icons.home,
          onTap: () => context.go(Routes.home),
        ),
        AppDrawerItem(
          route: Routes.activities,
          title: 'Activities',
          icon: Icons.search,
          onTap: () => context.go(Routes.activities),
        ),
        AppDrawerItem(
            title: 'News',
            icon: Icons.newspaper,
            onTap: () => context.go(Routes.news)),
        AppDrawerItem(
            title: 'Chat',
            icon: Icons.chat,
            onTap: () => context.go(Routes.chat)),
        // AppDrawerItem(
        //     title: 'Notification',
        //     icon: Icons.notifications,
        //     onTap: () => context.go(Routes.notification)),
        AppDrawerItem(
            title: 'Report',
            icon: Icons.report,
            onTap: () => context.go(Routes.report)),
        const Divider(),
        AppDrawerItem(
            title: 'Settings',
            icon: Icons.settings,
            onTap: () => context.go(Routes.settings)),
        const AppDrawerItem(title: 'Switch Role', icon: Icons.change_circle),
        const AppDrawerItem(title: 'Logout', icon: Icons.logout),
      ],
    );
  }
}
