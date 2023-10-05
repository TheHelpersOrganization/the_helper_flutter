import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/dialog/confirmation_dialog.dart';
import 'package:the_helper/src/features/organization/domain/organization.dart';
import 'package:the_helper/src/features/organization_member/domain/organization_member.dart';
import 'package:the_helper/src/features/organization_member/presentation/member_mangement/controller/organization_member_management_controller.dart';
import 'package:the_helper/src/utils/member.dart';

class RemoveMemberDialog extends ConsumerWidget {
  final Organization organization;
  final OrganizationMember member;

  const RemoveMemberDialog({
    super.key,
    required this.organization,
    required this.member,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConfirmationDialog(
      titleText: 'Remove Member',
      content: Text.rich(
        TextSpan(
          text: 'Do you want to remove member ',
          children: [
            TextSpan(
              text: getMemberName(member),
              style: TextStyle(
                color: context.theme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      onConfirm: () => ref
          .read(removeMemberControllerProvider.notifier)
          .remove(organization.id, member.id),
    );
  }
}
