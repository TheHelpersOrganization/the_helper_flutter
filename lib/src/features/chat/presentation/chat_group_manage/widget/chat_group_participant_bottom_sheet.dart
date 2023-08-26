import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/dialog/confirmation_dialog.dart';
import 'package:the_helper/src/features/chat/domain/chat_group_make_owner.dart';
import 'package:the_helper/src/features/chat/domain/chat_participant.dart';
import 'package:the_helper/src/features/chat/domain/chat_remove_participant.dart';
import 'package:the_helper/src/features/chat/presentation/chat_group_manage/controller/chat_group_participants_controller.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/profile.dart';

class ChatGroupParticipantBottomSheet extends ConsumerWidget {
  final ChatParticipant participant;

  const ChatGroupParticipantBottomSheet({
    super.key,
    required this.participant,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            getChatParticipantName(participant),
            style: context.theme.textTheme.titleMedium,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.person_outlined),
          title: const Text('View profile'),
          onTap: () {
            context.pop();
            context.pushNamed(AppRoute.otherProfile.name, pathParameters: {
              AppRouteParameter.profileId: participant.id.toString(),
            });
          },
        ),
        ListTile(
          leading: const Icon(Icons.admin_panel_settings_outlined),
          title: const Text('Make owner'),
          onTap: () {
            context.pop();
            ref.read(chatGroupMakeOwnerControllerProvider.notifier).makeOwner(
                  ChatGroupMakeOwner(
                    chatId: participant.chatId,
                    accountId: participant.id,
                  ),
                );
          },
        ),
        ListTile(
          leading: const Icon(Icons.delete_outline),
          title: const Text('Remove participant'),
          textColor: Colors.red,
          iconColor: Colors.red,
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => ConfirmationDialog(
                titleText: 'Remove participants',
                content: Text(
                  'Are you sure you want to '
                  'remove ${getChatParticipantName(participant)} '
                  'from this group?',
                ),
                onConfirm: () {
                  context.pop();
                  context.pop();
                  ref
                      .read(
                          chatGroupParticipantRemoveControllerProvider.notifier)
                      .removeParticipant(
                        ChatRemoveParticipant(
                          chatId: participant.chatId,
                          accountId: participant.id,
                        ),
                      );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
