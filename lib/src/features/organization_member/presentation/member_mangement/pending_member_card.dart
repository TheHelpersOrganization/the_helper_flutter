import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/bottom_sheet/custom_modal_botton_sheet.dart';
import 'package:the_helper/src/common/widget/dialog/confirmation_dialog.dart';
import 'package:the_helper/src/common/widget/dialog/loading_dialog_content.dart';
import 'package:the_helper/src/features/organization_member/domain/organization_member.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/domain_provider.dart';

import 'organization_member_management_controller.dart';

class PendingMemberCard extends ConsumerStatefulWidget {
  final OrganizationMember member;

  const PendingMemberCard({
    super.key,
    required this.member,
  });

  @override
  ConsumerState<PendingMemberCard> createState() => _PendingMemberCardState();
}

class _PendingMemberCardState extends ConsumerState<PendingMemberCard> {
  final reasonTextController = TextEditingController();

  Future<dynamic> showApproveDialog() {
    OrganizationMember member = widget.member;

    return showDialog(
      context: context,
      useRootNavigator: false,
      builder: (dialogContext) => ConfirmationDialog(
        titleText: 'Approve Member',
        content: RichText(
          text: TextSpan(
            text: 'Do you want to approve member ',
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
          showLoadingDialog(isApproving: true);
          await ref
              .read(approveMemberControllerProvider.notifier)
              .approve(member.organization!.id!, member.id);
          if (context.mounted) {
            context.pop();
          }
        },
      ),
    );
  }

  Future<dynamic> showRejectDialog() {
    OrganizationMember member = widget.member;

    return showDialog(
      context: context,
      useRootNavigator: false,
      builder: (dialogContext) => ConfirmationDialog(
        titleText: 'Reject Member',
        content: Column(children: [
          TextField(
            controller: reasonTextController,
            decoration: const InputDecoration(
              labelText: 'Reason',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ]),
        onConfirm: () async {
          context.pop();
          showLoadingDialog(isApproving: false);
          String reason = reasonTextController.text;
          await ref.read(rejectMemberControllerProvider.notifier).reject(
                member.organization!.id!,
                member.id,
                rejectionReason: reason,
              );
          reasonTextController.clear();
          if (context.mounted) {
            context.pop();
          }
        },
      ),
    );
  }

  void showLoadingDialog({required bool isApproving}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      useRootNavigator: false,
      builder: (context) => LoadingDialog(
        titleText: isApproving ? 'Approving member...' : 'Rejecting member...',
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
              ListTile(
                leading: const Icon(Icons.check_circle_outline),
                title: const Text('Approve member'),
                onTap: () {
                  context.pop();
                  showApproveDialog();
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel_outlined),
                title: const Text('Reject member'),
                onTap: () {
                  context.pop();
                  showRejectDialog();
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
    final pendingAt = member.updatedAt == null
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
          Text(
            ' Request at $pendingAt',
            //style: context.theme.textTheme.bodySmall,
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
