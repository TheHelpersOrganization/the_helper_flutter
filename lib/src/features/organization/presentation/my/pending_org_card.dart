import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/dialog/loading_dialog_content.dart';
import 'package:the_helper/src/common/widget/dialog/success_dialog_content.dart';
import 'package:the_helper/src/features/organization/domain/organization.dart';
import 'package:the_helper/src/features/organization/presentation/my/cancel_join_request_dialog.dart';
import 'package:the_helper/src/features/organization/presentation/my/my_organization_controller.dart';
import 'package:the_helper/src/router/router.dart';

import 'org_card.dart';

class PendingOrgCard extends ConsumerStatefulWidget {
  final Organization organization;

  const PendingOrgCard({
    super.key,
    required this.organization,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PendingOrgCardState();
}

class _PendingOrgCardState extends ConsumerState<PendingOrgCard> {
  Future<dynamic> showCancelDialog() {
    final organization = widget.organization;
    final cancelJoinRequestController = ref.read(
      cancelJoinControllerProvider.notifier,
    );

    return showDialog(
      context: context,
      useRootNavigator: false,
      builder: (dialogContext) => CancelJoinRequestDialog(
        organization: organization,
        onConfirm: () async {
          context.pop();
          showLoadingDialog();
          final res = await cancelJoinRequestController.cancel(
            organization.id!,
          );
          if (context.mounted) {
            context.pop();
            if (res != null) {
              showCancelSuccessDialog();
            }
          }
        },
      ),
    );
  }

  void showCancelSuccessDialog() {
    showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => SuccessDialog(
        content: RichText(
          text: TextSpan(
            text: 'Your request to join ',
            children: [
              TextSpan(
                text: widget.organization.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: context.theme.primaryColor,
                ),
              ),
              const TextSpan(
                text: ' has been cancelled.',
              ),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => context.pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      useRootNavigator: false,
      builder: (context) => const LoadingDialog(
        titleText: 'Cancelling Join Request',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final organization = widget.organization;

    return OrgCard(
      organization: organization,
      footer: Row(
        children: [
          Expanded(
            flex: 1,
            child: FilledButton.tonal(
              onPressed: () {
                context.pushNamed(
                  AppRoute.organization.name,
                  params: {
                    'id': organization.id.toString(),
                  },
                );
              },
              child: const Text('Profile'),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            flex: 1,
            child: FilledButton(
              onPressed: () {
                showCancelDialog();
                //showCancelSuccessDialog();
              },
              child: const Text('Cancel'),
            ),
          ),
        ],
      ),
    );
  }
}
