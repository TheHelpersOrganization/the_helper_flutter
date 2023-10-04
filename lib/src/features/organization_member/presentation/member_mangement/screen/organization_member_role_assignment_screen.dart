import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/dialog/confirmation_dialog.dart';
import 'package:the_helper/src/common/widget/dialog/loading_dialog_content.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/common/widget/loading_overlay.dart';
import 'package:the_helper/src/features/organization_member/presentation/member_mangement/controller/organization_member_role_assignment_controller.dart';
import 'package:the_helper/src/utils/async_value_ui.dart';
import 'package:the_helper/src/utils/image.dart';
import 'package:the_helper/src/utils/profile.dart';

class OrganizationMemberRoleAssignmentScreen extends ConsumerWidget {
  final int memberId;

  const OrganizationMemberRoleAssignmentScreen({
    super.key,
    required this.memberId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memberAndRolesState = ref.watch(memberAndRolesProvider(memberId));
    final updateRoleState = ref.watch(updateRoleControllerProvider);

    ref.listen<AsyncValue>(
      updateRoleControllerProvider,
      (_, state) {
        state.showSnackbarOnError(
          context,
          name: roleAssignmentSnackbarName,
        );
        state.showSnackbarOnSuccess(
          context,
          content: const Text('Role updated successfully'),
          name: roleAssignmentSnackbarName,
        );
      },
    );

    return LoadingOverlay.customDarken(
      isLoading: updateRoleState.isLoading,
      indicator: const LoadingDialog(),
      child: Scaffold(
        appBar: memberAndRolesState.maybeWhen(
          skipLoadingOnRefresh: false,
          data: (memberAndRoles) {
            final member = memberAndRoles.member;
            final profile = member.profile!;

            final memberName = getProfileName(profile);

            return AppBar(
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundImage:
                        getBackendImageOrLogoProvider(profile.avatarId),
                    radius: 16,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "$memberName's Roles",
                    style: context.theme.textTheme.titleMedium,
                  ),
                ],
              ),
            );
          },
          orElse: () => AppBar(),
        ),
        body: memberAndRolesState.when(
          skipLoadingOnRefresh: false,
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (_, __) {
            print(__);
            print(_);
            return Center(
              child: CustomErrorWidget(
                onRetry: () => ref.invalidate(
                  memberProvider(memberId),
                ),
              ),
            );
          },
          data: (memberAndRoles) {
            final roles = memberAndRoles.roleInfo;
            final availableRoles = roles.availableRoles;
            final assignedRoles = roles.assignedRoles;
            final canGrantRoles = roles.canGrantRoles;
            final canRevokeRoles = roles.canRevokeRoles;

            final assignedRoleWidgets = assignedRoles.map(
              (role) {
                final roleName = role.displayName ?? role.name.name;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  isThreeLine: true,
                  title: Text(roleName),
                  subtitle: role.description != null
                      ? Text(
                          role.description!,
                          style: TextStyle(
                            color: context.theme.colorScheme.secondary,
                          ),
                        )
                      : null,
                  trailing: canRevokeRoles.any((r) => r.name == role.name)
                      ? TextButton.icon(
                          icon: const Icon(Icons.remove_outlined),
                          label: const Text('Remove'),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => ConfirmationDialog(
                                titleText: 'Remove role',
                                content: Text.rich(
                                  TextSpan(
                                    text:
                                        'Are you sure you want to remove role ',
                                    style: const TextStyle(color: Colors.black),
                                    children: [
                                      TextSpan(
                                        text: roleName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const TextSpan(
                                          text: ' from this member?'),
                                    ],
                                  ),
                                ),
                                onConfirm: () {
                                  context.pop();
                                  ref
                                      .read(
                                          updateRoleControllerProvider.notifier)
                                      .revokeRole(
                                        memberId: memberId,
                                        role: role.name,
                                      );
                                },
                              ),
                            );
                          },
                        )
                      : null,
                );
              },
            );
            final availableRoleWidgets = availableRoles.map(
              (role) {
                final roleName = role.displayName ?? role.name.name;

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  isThreeLine: true,
                  title: Text(roleName),
                  subtitle: role.description != null
                      ? Text(
                          role.description!,
                          style: TextStyle(
                            color: context.theme.colorScheme.secondary,
                          ),
                        )
                      : null,
                  trailing: canGrantRoles
                          .any((element) => element.name == role.name)
                      ? TextButton.icon(
                          icon: const Icon(Icons.add_outlined),
                          label: const Text('Assign'),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => ConfirmationDialog(
                                titleText: 'Assign role',
                                content: Text.rich(
                                  TextSpan(
                                    text:
                                        'Are you sure you want to assign role ',
                                    children: [
                                      TextSpan(
                                        text: roleName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const TextSpan(text: ' to this member?'),
                                    ],
                                  ),
                                ),
                                onConfirm: () {
                                  context.pop();
                                  ref
                                      .read(
                                          updateRoleControllerProvider.notifier)
                                      .grantRole(
                                        memberId: memberId,
                                        role: role.name,
                                      );
                                },
                              ),
                            );
                          },
                        )
                      : null,
                );
              },
            );

            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 24,
                horizontal: 12,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Assigned Roles',
                      style: context.theme.textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (assignedRoleWidgets.isNotEmpty)
                      ...assignedRoleWidgets
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'No assigned roles.',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    Text(
                      'Available Roles',
                      style: context.theme.textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (availableRoleWidgets.isNotEmpty)
                      ...availableRoleWidgets
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'No available roles.',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
