import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/dialog/loading_dialog_content.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/common/widget/loading_overlay.dart';
import 'package:the_helper/src/features/chat/domain/chat.dart';
import 'package:the_helper/src/features/chat/domain/chat_participant.dart';
import 'package:the_helper/src/features/chat/presentation/chat/controller/chat_controller.dart';
import 'package:the_helper/src/features/chat/presentation/chat_group_participant/controller/chat_group_participants_controller.dart';
import 'package:the_helper/src/features/chat/presentation/chat_group_participant/screen/chat_group_participant_add_screen.dart';
import 'package:the_helper/src/features/chat/presentation/chat_group_participant/widget/chat_group_participant_bottom_sheet.dart';
import 'package:the_helper/src/utils/async_value_ui.dart';
import 'package:the_helper/src/utils/image.dart';
import 'package:the_helper/src/utils/profile.dart';

class ChatGroupParticipantScreen extends ConsumerWidget {
  final int chatId;
  final int myId;

  const ChatGroupParticipantScreen({
    super.key,
    required this.chatId,
    required this.myId,
  });

  String getChatParticipantRole(Chat chat, ChatParticipant participant) {
    String role = participant.id == myId ? 'You, ' : '';
    if (participant.id == chat.ownerId) {
      return '${role}Owner';
    }
    return '${role}Participant';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatDataState = ref.watch(chatProvider(chatId));

    final chatRemoveParticipantState =
        ref.watch(chatGroupParticipantRemoveControllerProvider);
    final chatGroupMakeOwnerState =
        ref.watch(chatGroupMakeOwnerControllerProvider);

    ref.listen(chatGroupParticipantRemoveControllerProvider, (previous, next) {
      next.showSnackbarOnError(
        context,
        name: chatGroupParticipantRemoveSnackbarName,
      );
      next.showSnackbarOnSuccess(
        context,
        name: chatGroupParticipantRemoveSnackbarName,
        content: const Text('Participant removed'),
      );
    });

    ref.listen(chatGroupMakeOwnerControllerProvider, (previous, next) {
      next.showSnackbarOnError(
        context,
        name: chatGroupMakeOwnerSnackbarName,
      );
      next.showSnackbarOnSuccess(
        context,
        name: chatGroupMakeOwnerSnackbarName,
        content: const Text('Owner changed'),
      );
    });

    return LoadingOverlay.customDarken(
      isLoading: chatRemoveParticipantState.isLoading ||
          chatGroupMakeOwnerState.isLoading,
      indicator: LoadingDialog(
        titleText: chatRemoveParticipantState.isLoading
            ? 'Removing participant'
            : 'Changing owner',
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Group Participants',
            style: context.theme.textTheme.titleMedium,
          ),
          actions: [
            if (chatDataState.valueOrNull?.ownerId == myId)
              TextButton.icon(
                onPressed: () => context.navigator.push(MaterialPageRoute(
                  builder: (context) => ChatGroupParticipantAddScreen(
                    chatId: chatId,
                  ),
                )),
                icon: const Icon(Icons.add),
                label: const Text('Add'),
              ),
          ],
        ),
        body: chatDataState.when(
          skipLoadingOnRefresh: false,
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => CustomErrorWidget(
            onRetry: () => ref.invalidate(chatProvider(chatId)),
          ),
          data: (chat) {
            if (chat == null) {
              return const SizedBox();
            }
            final meIsOwner = chat.ownerId == myId;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...chat.participants!.map(
                      (e) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading:
                            getBackendCircleAvatarOrCharacterFromChatParticipant(
                                e),
                        title: Text(getChatParticipantName(e)),
                        subtitle: Text(getChatParticipantRole(chat, e)),
                        onTap: e.id == chat.ownerId || !meIsOwner
                            ? null
                            : () {
                                showModalBottomSheet(
                                  showDragHandle: true,
                                  context: context,
                                  builder: (context) =>
                                      ChatGroupParticipantBottomSheet(
                                    participant: e,
                                  ),
                                );
                              },
                        trailing: e.id == chat.ownerId || !meIsOwner
                            ? null
                            : IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    showDragHandle: true,
                                    context: context,
                                    builder: (context) =>
                                        ChatGroupParticipantBottomSheet(
                                      participant: e,
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.more_vert_outlined),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
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
