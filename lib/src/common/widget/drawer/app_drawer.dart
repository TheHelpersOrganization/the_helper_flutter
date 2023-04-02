import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer_header.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer_item.dart';
import 'package:the_helper/src/common/widget/drawer/draw_item_enum.dart';

import '../../../features/authentication/presentation/logout_controller.dart';
import '../../../router/router.dart';
import 'package:the_helper/src/features/change_role/presentation/controllers/home_screen_controller.dart';

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
    final userRole = ref.watch(homeScreenControllerProvider);
    final drawerItem = getDrawerItem(userRole.role);
    return Column(
      children: [
        SafeArea(
          child: InkWell(
            onTap: () => context.goNamed(AppRoute.profile.name),
            child: const AppDrawerHeader(),
          ),
        ),
        const Divider(),
        for (var i in drawerItem)
          AppDrawerItem(
            route: i.route,
            title: i.title,
            icon: i.icon,
            onTap: () {
              print(userRole.role);
              context.goNamed(
                  i.route != null ? i.route!.name : AppRoute.developing.name);
            },
          ),
        AppDrawerItem(
            title: 'Logout',
            icon: Icons.logout,
            onTap: () => ref.read(logoutControllerProvider).signOut()),
      ],
    );
  }
}
