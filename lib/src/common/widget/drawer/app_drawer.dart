import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer_header.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer_item.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer_user.dart';
import 'package:the_helper/src/common/widget/drawer/draw_item_enum.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';
import 'package:the_helper/src/features/change_role/domain/user_role.dart';
import 'package:the_helper/src/features/change_role/presentation/controllers/role_controller.dart';
import 'package:the_helper/src/features/profile/data/profile_repository.dart';
import 'package:the_helper/src/features/profile/presentation/profile_controller.dart';

import '../../../features/authentication/presentation/logout_controller.dart';
import '../../../router/router.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) => Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: Column(
          children: [
            const AppDrawerHeader(),
            const Divider(
              height: 0,
            ),
            Expanded(
              child: _buildDrawerItem(context, ref),
            ),
          ],
        ),
      );

  Widget _buildDrawerItem(BuildContext context, WidgetRef ref) {
    final userRoleState = ref.watch(roleControllerProvider);
    final userRole = userRoleState.valueOrNull;
    final roles = ref.watch(getAllRolesProvider).valueOrNull;

    if (userRoleState.isLoading || roles == null) return ListView();

    final drawerItem = getDrawerItem(userRole ?? Role.volunteer);
    return ListView(
      children: [
        InkWell(
          onTap: () => context.goNamed(AppRoute.profile.name),
          child: const AppDrawerUser(),
        ),
        const Divider(),
        for (var i in drawerItem)
          AppDrawerItem(
            route: i.route,
            title: i.title,
            icon: i.icon,
            onTap: () {
              if (i.onTap != null) {
                i.onTap!(context);
                return;
              }
              context.goNamed(
                  i.route != null ? i.route!.name : AppRoute.developing.name);
            },
          ),
        if (userRole == Role.volunteer && roles.isNotEmpty)
          AppDrawerItem(
            title: 'Change Role',
            icon: Icons.change_circle,
            onTap: () => context.goNamed(AppRoute.changeRole.name),
          ),
        AppDrawerItem(
            title: 'Logout',
            icon: Icons.logout,
            onTap: () {
              ref.read(logoutControllerProvider).signOut();
              ref.invalidate(profileServiceProvider);
              ref.invalidate(profileRepositoryProvider);
              ref.invalidate(authServiceProvider);
            }),
      ],
    );
  }
}
