import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer_drop_down.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer_header.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer_item.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer_user.dart';
import 'package:the_helper/src/common/widget/drawer/draw_item_controller.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';
import 'package:the_helper/src/features/change_role/application/role_service.dart';
import 'package:the_helper/src/features/change_role/data/role_repository.dart';
import 'package:the_helper/src/features/change_role/domain/user_role.dart';
import 'package:the_helper/src/features/change_role/presentation/controllers/role_controller.dart';
import 'package:the_helper/src/features/notification/application/notification_service.dart';
import 'package:the_helper/src/features/organization/application/current_organization_service.dart';
import 'package:the_helper/src/features/organization/data/current_organization_repository.dart';
import 'package:the_helper/src/features/organization/domain/organization_status.dart';
import 'package:the_helper/src/features/profile/data/profile_repository.dart';
import 'package:the_helper/src/features/profile/presentation/profile_controller.dart';
import 'package:the_helper/src/utils/image.dart';

import '../../../features/authentication/presentation/logout_controller.dart';
import '../../../router/router.dart';

List<Role> tempRole = [
  Role.admin,
  Role.moderator,
  Role.operator,
  Role.volunteer
];

class AppDrawer extends ConsumerWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) => SafeArea(
        child: Drawer(
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
        ),
      );

  Widget _buildDrawerItem(BuildContext context, WidgetRef ref) {
    final accountData = ref.watch(authServiceProvider).valueOrNull?.account;
    final accountId = accountData?.id;
    final isEmailVerified = accountData?.isEmailVerified ?? false;

    final userRoleState = ref.watch(roleServiceProvider);
    final userRole = userRoleState.valueOrNull;
    final roles = ref.watch(getAccountRolesProvider).valueOrNull;
    final currentOrganization =
        ref.watch(currentOrganizationServiceProvider).valueOrNull;
    final isOrganizationVerified =
        currentOrganization?.status == OrganizationStatus.verified;
    final joinedOrganizations =
        ref.watch(joinedOrganizationsProvider).valueOrNull;

    if (userRoleState.isLoading || roles == null) return ListView();

    final drawerItem = getDrawerItem(userRole ?? Role.volunteer);
    return ListView(
      children: [
        InkWell(
          onTap: () => context.goNamed(AppRoute.profile.name),
          child: const SizedBox(height: 80, child: AppDrawerUser()),
        ),
        const Divider(),
        if (userRole == Role.moderator && currentOrganization != null) ...[
          AppDrawerItem(
            title: currentOrganization.name,
            titleStyle: context.theme.textTheme.titleMedium,
            subtitle: 'Current organization',
            subtitleStyle: context.theme.textTheme.bodyMedium,
            leading: CircleAvatar(
              radius: 24,
              backgroundImage: getBackendImageOrLogoProvider(
                currentOrganization.logo,
              ),
            ),
            onTap: isOrganizationVerified
                ? () => context.pushNamed(
                      AppRoute.organization.name,
                      pathParameters: {
                        'orgId': currentOrganization.id.toString(),
                      },
                    )
                : null,
            isSub: false,
            enabled: isEmailVerified,
          ),
          const Divider(),
        ],
        for (var i in drawerItem)
          if (i.subPaths != null)
            AppDrawerDropDown(
              title: i.title,
              icon: i.icon,
              subPaths: i.subPaths!,
            )
          else
            AppDrawerItem(
              title: i.title,
              icon: i.icon,
              isSub: false,
              path: i.route?.path,
              onTap: () {
                if (i.onTap != null) {
                  i.onTap!(context);
                  return;
                }
                context.goNamed(
                    i.route != null ? i.route!.name : AppRoute.developing.name);
              },
              enabled: i.enabled ??
                  isEmailVerified &&
                          (userRole == Role.moderator
                              ? isOrganizationVerified
                              : true) ||
                      i.route?.path == AppRoute.home.path,
            ),
        if (userRole == Role.moderator &&
            accountId != null &&
            currentOrganization != null &&
            accountId == currentOrganization.ownerId)
          AppDrawerItem(
            title: 'Transfer ownership',
            icon: Icons.backup_table_outlined,
            isSub: false,
            onTap: () => context.goNamed(
              AppRoute.organizationTransferOwnership.name,
            ),
            path: AppRoute.organizationTransferOwnership.path,
            enabled: isEmailVerified && userRole == Role.moderator
                ? isOrganizationVerified
                : true,
          ),
        if (userRole == Role.admin &&
            (accountData?.roles.contains(Role.superadmin) == true ||
                accountData?.roles.contains(Role.operator) == true))
          AppDrawerItem(
            title: 'Admins manage',
            icon: Icons.admin_panel_settings_outlined,
            isSub: false,
            onTap: () => context.goNamed(AppRoute.accountAdminGrant.name),
            path: AppRoute.accountAdminGrant.path,
            enabled: isEmailVerified,
          ),
        if (roles.length > 1 || joinedOrganizations?.isNotEmpty == true)
          AppDrawerItem(
            title: 'Change Role',
            icon: Icons.change_circle_outlined,
            isSub: false,
            onTap: () => context.goNamed(AppRoute.changeRole.name),
            enabled: isEmailVerified,
          ),
        AppDrawerItem(
            title: 'Logout',
            icon: Icons.logout_outlined,
            isSub: false,
            enabled: true,
            onTap: () {
              ref.read(logoutControllerProvider).signOut();
              ref.read(roleServiceProvider.notifier).removeCurrentRole();
              ref.invalidate(roleRepositoryProvider);
              ref.invalidate(profileControllerProvider);
              ref.invalidate(profileRepositoryProvider);
              ref.invalidate(authServiceProvider);
              ref.invalidate(currentOrganizationServiceProvider);
              ref.invalidate(currentOrganizationRepositoryProvider);
              ref.invalidate(joinedOrganizationsProvider);
              ref.invalidate(notificationCountProvider);
            }),
      ],
    );
  }
}
