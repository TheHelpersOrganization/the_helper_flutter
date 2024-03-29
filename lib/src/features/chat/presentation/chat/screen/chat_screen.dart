import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/screens/screen404.dart';
import 'package:the_helper/src/common/widget/dialog/confirmation_dialog.dart';
import 'package:the_helper/src/common/widget/dialog/loading_dialog_content.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/common/widget/loading_overlay.dart';
import 'package:the_helper/src/common/widget/no_data_found.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';
import 'package:the_helper/src/features/chat/domain/chat.dart';
import 'package:the_helper/src/features/chat/domain/chat_message.dart';
import 'package:the_helper/src/features/chat/presentation/chat/controller/chat_controller.dart';
import 'package:the_helper/src/features/chat/presentation/chat/controller/group_chat_controller.dart';
import 'package:the_helper/src/features/chat/presentation/chat/widget/chat_block_alert.dart';
import 'package:the_helper/src/features/chat/presentation/chat/widget/chat_message_bar.dart';
import 'package:the_helper/src/features/chat/presentation/chat/widget/chat_message_card.dart';
import 'package:the_helper/src/features/chat/presentation/chat_group_edit/screen/chat_group_edit_screen.dart';
import 'package:the_helper/src/features/chat/presentation/chat_group_participant/screen/chat_group_participant_screen.dart';
import 'package:the_helper/src/features/chat/presentation/common/widget/chat_avatar.dart';
import 'package:the_helper/src/features/report/domain/report_query_parameter_classes.dart';
import 'package:the_helper/src/features/report/presentation/submit_report/screen/submit_report_screen.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/async_value_ui.dart';
import 'package:the_helper/src/utils/image.dart';
import 'package:the_helper/src/utils/profile.dart';

class ChatScreen extends ConsumerWidget {
  final int chatId;

  const ChatScreen({
    super.key,
    required this.chatId,
  });

  showUnblockDialog({
    required BuildContext context,
    required String targetName,
    required UnblockChatController controller,
  }) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        titleText: 'Unblock $targetName?',
        content: const Text(
          'You will receive messages from this user.',
        ),
        confirmText: 'Unblock',
        onConfirm: () {
          context.pop();
          controller.unblockChat(chatId);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatDataState = ref.watch(chatProvider(chatId));
    final myId = ref.watch(authServiceProvider).asData!.value!.account.id;
    final chatListState =
        ref.watch(chatMessageListPagedNotifierProvider(chatId));
    final chatSocketState = ref.watch(chatSocketProvider(chatId));
    final chatControllerState = ref.watch(chatControllerProvider);

    final scrollController = ref.watch(scrollControllerProvider);

    final blockChatControllerState = ref.watch(blockChatControllerProvider);
    final unblockChatControllerState = ref.watch(unblockChatControllerProvider);

    final leaveGroupChatControllerState = ref.watch(
      leaveGroupChatControllerProvider,
    );
    ref.listen(leaveGroupChatControllerProvider, (previous, next) {
      next.showSnackbarOnSuccess(context,
          content: const Text('Left chat successfully'),
          name: chatGroupLeaveSnackbarName);
      next.showSnackbarOnError(context, name: chatGroupLeaveSnackbarName);
    });

    final deleteChatGroupControllerState =
        ref.watch(deleteChatGroupControllerProvider);
    ref.listen(deleteChatGroupControllerProvider, (previous, next) {
      next.showSnackbarOnSuccess(
        context,
        content: const Text('Chat deleted successfully'),
        name: chatGroupDeleteSnackbarName,
      );
      next.showSnackbarOnError(context, name: chatGroupDeleteSnackbarName);
    });

    return LoadingOverlay.customDarken(
      isLoading: blockChatControllerState.isLoading ||
          unblockChatControllerState.isLoading ||
          leaveGroupChatControllerState.isLoading ||
          deleteChatGroupControllerState.isLoading,
      indicator: const LoadingDialog(
        titleText: 'Please wait',
      ),
      child: Scaffold(
        appBar: chatDataState.maybeWhen(
          data: (chat) {
            if (chat == null) {
              return null;
            }
            final otherProfile =
                chat.participants!.firstWhere((e) => e.id != myId);
            final otherName = getChatParticipantName(otherProfile);
            return AppBar(
              title: Row(
                children: [
                  ChatAvatar(chat: chat, myId: myId),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      chat.getDisplayName(myId: myId),
                      style: context.theme.textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              actions: [
                PopupMenuButton(
                  position: PopupMenuPosition.under,
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    if (value == 'participant') {
                      context.navigator.push(
                        MaterialPageRoute(
                          builder: (context) => ChatGroupParticipantScreen(
                            chatId: chat.id,
                            myId: myId,
                          ),
                        ),
                      );
                    } else if (value == 'profile') {
                      context.pushNamed(
                        AppRoute.otherProfile.name,
                        pathParameters: {
                          'userId': otherProfile.id.toString(),
                        },
                      );
                    } else if (value == 'report') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return SubmitReportScreen(
                              id: otherProfile.id,
                              name: otherProfile.username.toString(),
                              entityType: ReportType.account,
                              avatarId: otherProfile.avatarId,
                              subText: otherProfile.email,
                            );
                          },
                        ),
                      );
                    } else if (value == 'block') {
                      showDialog(
                        context: context,
                        builder: (context) => ConfirmationDialog(
                          titleText: 'Block $otherName?',
                          content: const Text(
                            'You will no longer receive messages from this user.',
                          ),
                          confirmText: 'Block',
                          onConfirm: () {
                            context.pop();
                            ref
                                .read(blockChatControllerProvider.notifier)
                                .blockChat(chatId);
                          },
                        ),
                      );
                    } else if (value == 'unblock') {
                      showUnblockDialog(
                        context: context,
                        targetName: otherName,
                        controller: ref.read(
                          unblockChatControllerProvider.notifier,
                        ),
                      );
                    } else if (value == 'edit') {
                      context.navigator.push(
                        MaterialPageRoute(
                          builder: (context) => ChatGroupEditScreen(
                            chatId: chat.id,
                          ),
                        ),
                      );
                    } else if (value == 'leave') {
                      showDialog(
                        context: context,
                        builder: (context) => ConfirmationDialog(
                          titleText: 'Leave chat?',
                          content: const Text(
                            'Are you sure you want to leave this chat? You will not be able to rejoin unless being added again.',
                          ),
                          onConfirm: () {
                            context.pop();
                            ref
                                .read(leaveGroupChatControllerProvider.notifier)
                                .leaveGroupChat(chatId: chatId);
                          },
                        ),
                      );
                    } else if (value == 'delete') {
                      showDialog(
                        context: context,
                        builder: (context) => ConfirmationDialog(
                          titleText: 'Delete chat?',
                          content: const Text(
                            'Are you sure you want to delete this chat?',
                          ),
                          showActionCanNotBeUndoneText: true,
                          onConfirm: () {
                            context.pop();
                            ref
                                .read(
                                    deleteChatGroupControllerProvider.notifier)
                                .deleteChatGroup(chatId: chatId);
                          },
                        ),
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    if (chat.isGroup) ...[
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'participant',
                        child: Row(
                          children: [
                            Icon(
                              Icons.group_outlined,
                            ),
                            SizedBox(width: 8),
                            Text('Participants'),
                          ],
                        ),
                      ),
                    ] else
                      const PopupMenuItem(
                        value: 'profile',
                        child: Row(
                          children: [
                            Icon(
                              Icons.account_circle_outlined,
                            ),
                            SizedBox(width: 8),
                            Text('Profile'),
                          ],
                        ),
                      ),
                    if (!chat.isGroup)
                      const PopupMenuItem(
                        value: 'report',
                        child: Row(
                          children: [
                            Icon(Icons.report),
                            SizedBox(width: 8),
                            Text('Report'),
                          ],
                        ),
                      ),
                    if (!chat.isGroup && !chat.isBlocked)
                      const PopupMenuItem(
                        value: 'block',
                        child: Row(
                          children: [
                            Icon(Icons.block),
                            SizedBox(width: 8),
                            Text('Block'),
                          ],
                        ),
                      ),
                    if (!chat.isGroup && chat.isBlocked)
                      const PopupMenuItem(
                        value: 'unblock',
                        child: Row(
                          children: [
                            Icon(Icons.block),
                            SizedBox(width: 8),
                            Text('Unblock'),
                          ],
                        ),
                      ),
                    if (chat.isGroup) ...[
                      const PopupMenuItem(
                        value: 'leave',
                        child: Row(
                          children: [
                            Icon(Icons.exit_to_app_outlined),
                            SizedBox(width: 8),
                            Text('Leave'),
                          ],
                        ),
                      ),
                      if (chat.ownerId == myId)
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline),
                              SizedBox(width: 8),
                              Text('Delete'),
                            ],
                          ),
                        ),
                    ],
                  ],
                )
              ],
            );
          },
          orElse: () => null,
        ),
        body: chatDataState.when(
          skipLoadingOnRefresh: false,
          data: (chat) {
            if (chat == null) {
              return const DevelopingScreen();
            }
            //return ChatGroupParticipantScreen(chatId: chat.id, myId: myId);
            final otherProfile =
                chat.participants?.firstWhere((e) => e.id != myId);
            final myProfile =
                chat.participants?.firstWhere((e) => e.id == myId);

            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: RiverPagedBuilder<int, ChatMessage>.autoDispose(
                      firstPageKey: 0,
                      provider: chatMessageListPagedNotifierProvider(chatId),
                      pagedBuilder: (controller, builder) => PagedListView(
                        reverse: true,
                        pagingController: controller,
                        builderDelegate: builder,
                        scrollController: scrollController,
                      ),
                      itemBuilder: (context, chatMessage, index) {
                        final isMe =
                            chatMessage.sender == myProfile!.participantId;
                        final previous = index == 0
                            ? null
                            : chatListState.records?.elementAtOrNull(index - 1);
                        final previousIsNotMe =
                            previous?.sender != chatMessage.sender;

                        final widget = Padding(
                          padding: EdgeInsets.only(
                            bottom: previousIsNotMe ? 36 : 4,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: isMe
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (!isMe)
                                if (previousIsNotMe)
                                  getBackendCircleAvatarOrCharacter(
                                    otherProfile?.avatarId,
                                    getChatParticipantName(otherProfile),
                                    radius: 18,
                                  )
                                else
                                  const SizedBox(width: 36),
                              ChatMessageCard(
                                chatMessage: chatMessage,
                                color: isMe ? context.theme.primaryColor : null,
                                textColor: isMe ? Colors.white : null,
                              ),
                              if (isMe)
                                if (previousIsNotMe)
                                  getBackendCircleAvatarOrCharacter(
                                    myProfile.avatarId,
                                    getChatParticipantName(myProfile),
                                    radius: 18,
                                  )
                                else
                                  const SizedBox(width: 36),
                            ],
                          ),
                        );

                        return widget;
                      },
                      limit: 20,
                      pullToRefresh: true,
                      firstPageErrorIndicatorBuilder: (context, controller) =>
                          CustomErrorWidget(
                        onRetry: () => controller.retryLastFailedRequest(),
                      ),
                      newPageErrorIndicatorBuilder: (context, controller) =>
                          CustomErrorWidget(
                        onRetry: () => controller.retryLastFailedRequest(),
                      ),
                      noItemsFoundIndicatorBuilder: (context, _) => const Align(
                        alignment: Alignment.bottomCenter,
                        child: NoDataFound.simple(
                          contentSubtitle:
                              'Send the first message to start the chat',
                        ),
                      ),
                    ),
                  ),
                ),
                chatControllerState.maybeWhen(
                  orElse: () => const SizedBox.shrink(),
                  data: (_) {
                    final chat = chatDataState.asData?.value;
                    final socket = chatSocketState.asData?.value;
                    if (chat == null || socket == null) {
                      return const SizedBox.shrink();
                    }
                    final otherProfile =
                        chat.participants!.firstWhere((e) => e.id != myId);
                    final otherName = getChatParticipantName(otherProfile);
                    if (chat.isBlocked) {
                      return ChatBlockAlert(
                        chat: chat,
                        myId: myId,
                        onUnblock: () {
                          showUnblockDialog(
                            context: context,
                            targetName: otherName,
                            controller: ref.read(
                              unblockChatControllerProvider.notifier,
                            ),
                          );
                        },
                      );
                    }
                    return ChatMessageBar(chatId: chatId);
                  },
                ),
              ],
            );
          },
          error: (_, __) => Center(
            child: CustomErrorWidget(
              onRetry: () => ref.invalidate(chatProvider),
            ),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
