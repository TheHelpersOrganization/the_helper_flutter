import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/bottom_sheet/custom_modal_botton_sheet.dart';
import 'package:the_helper/src/common/widget/dialog/confirmation_dialog.dart';
import 'package:the_helper/src/common/widget/dialog/loading_dialog_content.dart';
import 'package:the_helper/src/features/organization/domain/organization_member_role.dart';
import 'package:the_helper/src/features/organization_member/domain/organization_member.dart';
import 'package:the_helper/src/features/organization_member/presentation/member_mangement/controller/organization_member_management_controller.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/domain_provider.dart';

class JoinedMemberCard extends ConsumerStatefulWidget {
  final OrganizationMember member;
  final OrganizationMember myMember;

  const JoinedMemberCard({
    super.key,
    required this.member,
    required this.myMember,
  });

  @override
  ConsumerState<JoinedMemberCard> createState() => _MemberCardState();
}

class _MemberCardState extends ConsumerState<JoinedMemberCard> {
  Future<dynamic> showRemoveDialog() {
    OrganizationMember member = widget.member;

    return showDialog(
      context: context,
      useRootNavigator: false,
      builder: (dialogContext) => ConfirmationDialog(
        titleText: 'Remove Member',
        content: RichText(
          text: TextSpan(
            text: 'Do you want to remove member ',
            children: [
              TextSpan(
                text: getMemberName(),
                style: TextStyle(
                  color: context.theme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        onConfirm: () async {
          context.pop();
          showLoadingDialog();
          await ref
              .read(removeMemberControllerProvider.notifier)
              .remove(member.organization!.id, member.id);
          if (context.mounted) {
            context.pop();
          }
        },
      ),
    );
  }

  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      useRootNavigator: false,
      builder: (context) => const LoadingDialog(
        titleText: 'Removing member...',
      ),
    );
  }

  String getMemberName() {
    OrganizationMember member = widget.member;
    String memberName = member.profile?.username ??
        member.profile?.email ??
        member.accountId.toString();
    return memberName;
  }

  void showOptionsSheet() {
    OrganizationMember member = widget.member;
    OrganizationMember myMember = widget.myMember;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return CustomModalBottomSheet(
          titleText: getMemberName(),
          content: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.account_circle_outlined),
                title: const Text('View profile'),
                onTap: () {
                  context.pop();
                  context.pushNamed(
                    AppRoute.otherProfile.name,
                    pathParameters: {
                      'userId': member.accountId.toString(),
                    },
                  );
                },
              ),
              if (myMember.hasRole(
                      OrganizationMemberRoleType.organizationMemberManager) &&
                  member.id != myMember.id)
                ListTile(
                  leading: const Icon(Icons.assignment_ind_outlined),
                  title: const Text('Assign roles'),
                  onTap: () {
                    context.pop();
                    context.pushNamed(
                      AppRoute.organizationMemberRoleAssignment.name,
                      pathParameters: {
                        'memberId': member.id.toString(),
                      },
                    );
                  },
                ),
              if (myMember.hasRole(
                      OrganizationMemberRoleType.organizationMemberManager) &&
                  member.id != myMember.id)
                ListTile(
                  leading: const Icon(Icons.person_remove_outlined),
                  title: const Text('Remove member'),
                  textColor: Colors.red,
                  iconColor: Colors.red,
                  onTap: () {
                    context.pop();
                    showRemoveDialog();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    OrganizationMember member = widget.member;
    String memberName = getMemberName();
    final joinedAt = member.updatedAt == null
        ? 'Unknown'
        : DateFormat('dd/MM/yyyy').format(member.updatedAt!);

    return ListTile(
      onTap: () {
        showOptionsSheet();
      },
      leading: CircleAvatar(
        backgroundImage:
            member.profile == null || member.profile!.avatarId == null
                ? Image.asset('assets/images/logo.png').image
                : NetworkImage(
                    getImageUrl(
                      member.profile!.avatarId!,
                    ),
                  ),
        radius: 20,
      ),
      title: Text(
        memberName + (widget.myMember.id == member.id ? ' (You)' : ''),
        style: context.theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                color: context.theme.colorScheme.secondary,
                weight: 100,
                size: 18,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  'Joined at $joinedAt',
                  //style: context.theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
          if (member.roles?.isNotEmpty ?? false) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.assignment_ind_outlined,
                  color: context.theme.colorScheme.secondary,
                  weight: 100,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text('${member.roles!.first.displayName}'),
              ],
            ),
          ]
        ],
      ),
      isThreeLine: member.roles?.isNotEmpty ?? false,
      trailing: IconButton(
        onPressed: () {
          showOptionsSheet();
        },
        icon: Icon(
          Icons.more_vert,
          color: context.theme.colorScheme.secondary,
        ),
      ),
    );
  }
}
