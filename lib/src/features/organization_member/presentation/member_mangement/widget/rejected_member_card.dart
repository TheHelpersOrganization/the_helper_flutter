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

class RejectedMemberCard extends ConsumerStatefulWidget {
  final OrganizationMember member;
  final OrganizationMember myMember;

  const RejectedMemberCard({
    super.key,
    required this.member,
    required this.myMember,
  });

  @override
  ConsumerState<RejectedMemberCard> createState() => _MemberCardState();
}

class _MemberCardState extends ConsumerState<RejectedMemberCard> {
  Future<dynamic> showRemoveDialog() {
    OrganizationMember member = widget.member;

    return showDialog(
      context: context,
      useRootNavigator: false,
      builder: (dialogContext) => ConfirmationDialog(
        titleText: 'Remove Member',
        content: Text.rich(
          TextSpan(
            text: 'Do you want to remove member ',
            style: const TextStyle(
                color: Colors.black
              ),
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

    final dateOfRejection = member.updatedAt == null
        ? 'Unknown'
        : DateFormat('dd/MM/yyyy').format(member.updatedAt!);

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
                      'userId': member.id.toString(),
                    },
                  );
                },
              ),
              if (myMember.hasRole(
                      OrganizationMemberRoleType.organizationMemberManager) &&
                  member.id != widget.myMember.id)
                ListTile(
                  leading: const Icon(Icons.person_add_outlined),
                  title: const Text('Add member back'),
                  onTap: () {
                    context.pop();
                    showDialog(
                      context: context,
                      builder: (context) => ConfirmationDialog(
                        titleText: 'Add Member Back',
                        content: Text(
                          'Do you want to add ${member.profile?.username} back?',
                        ),
                        onConfirm: () {
                          context.pop();
                          showLoadingDialog();
                          ref
                              .read(
                                  approveMemberBackControllerProvider.notifier)
                              .approveBack(member.organization!.id, member.id);
                          if (context.mounted) {
                            context.pop();
                          }
                        },
                      ),
                    );
                  },
                ),
              if (myMember.hasRole(
                      OrganizationMemberRoleType.organizationMemberManager) &&
                  member.id != widget.myMember.id)
                ListTile(
                  title: Text(
                    'Rejection reason: ${member.rejectionReason ?? 'Unspecified'}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  subtitle: Text('Date of rejection: $dateOfRejection'),
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
    final dateOfRejection = member.updatedAt == null
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
        memberName,
        style: context.theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Row(
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
              'Rejected at $dateOfRejection',
              maxLines: 2,
              //style: context.theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
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
