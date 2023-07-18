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
import 'package:the_helper/src/features/chat/domain/chat_message.dart';
import 'package:the_helper/src/features/chat/presentation/chat/controller/chat_controller.dart';
import 'package:the_helper/src/features/chat/presentation/chat/widget/chat_message_bar.dart';
import 'package:the_helper/src/features/report/domain/report_type.dart';
import 'package:the_helper/src/features/report/presentation/submit_report/screen/submit_report_screen.dart';
import 'package:the_helper/src/router/router.dart';
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

    return LoadingOverlay.customDarken(
      isLoading: blockChatControllerState.isLoading ||
          unblockChatControllerState.isLoading,
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
                    getBackendCircleAvatarOrCharacter(
                      otherProfile.avatarId,
                      getChatParticipantName(otherProfile),
                      radius: 16,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      getChatParticipantName(otherProfile),
                      style: context.theme.textTheme.titleMedium,
                    ),
                  ],
                ),
                actions: [
                  PopupMenuButton(
                    position: PopupMenuPosition.under,
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 'profile') {
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
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'profile',
                        child: Row(
                          children: [
                            Icon(
                              Icons.account_circle_outlined,
                            ),
                            SizedBox(width: 8),
                            Text('View user profile'),
                          ],
                        ),
                      ),
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
                      if (!chat.isBlocked)
                        const PopupMenuItem(
                          value: 'block',
                          child: Row(
                            children: [
                              Icon(Icons.block),
                              SizedBox(width: 8),
                              Text('Block'),
                            ],
                          ),
                        )
                      else
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
                    ],
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                ],
              );
            },
            orElse: () => null),
        body: chatDataState.when(
          skipLoadingOnRefresh: false,
          data: (chat) {
            if (chat == null) {
              return const DevelopingScreen();
            }

            final otherProfile =
                chat.participants?.firstWhere((e) => e.id != myId);
            final myProfile =
                chat.participants?.firstWhere((e) => e.id == myId);

            return Padding(
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
                  final isMe = chatMessage.sender == myId;
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
                            )
                          else
                            const SizedBox(width: 48),
                        Card(
                          color: isMe ? context.theme.primaryColor : null,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.6,
                              ),
                              child: SelectableText(
                                chatMessage.message,
                                //overflow: TextOverflow.visible,
                                style: TextStyle(
                                  color: isMe ? Colors.white : null,
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (isMe)
                          if (previousIsNotMe)
                            getBackendCircleAvatarOrCharacter(
                              myProfile?.avatarId,
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
                    contentSubtitle: 'Send the first message to start the chat',
                  ),
                ),
              ),
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
        bottomNavigationBar: chatControllerState.maybeWhen(
          orElse: () => null,
          data: (_) {
            final chat = chatDataState.asData?.value;
            final socket = chatSocketState.asData?.value;
            if (chat == null || socket == null) {
              return null;
            }
            final otherProfile =
                chat.participants!.firstWhere((e) => e.id != myId);
            final otherName = getChatParticipantName(otherProfile);
            if (chat.isBlocked) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      chat.blockedBy == myId
                          ? 'You have blocked this user. Unblock to send messages.'
                          : 'You have been blocked. You cannot send messages to this user.',
                      style: TextStyle(
                        color: context.theme.colorScheme.error,
                      ),
                    ),
                  ),
                  if (chat.blockedBy == myId)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 12,
                        right: 12,
                        bottom: 12,
                      ),
                      child: OutlinedButton(
                        onPressed: () {
                          showUnblockDialog(
                            context: context,
                            targetName: otherName,
                            controller: ref.read(
                              unblockChatControllerProvider.notifier,
                            ),
                          );
                        },
                        child: const Text('Unblock'),
                      ),
                    ),
                ],
              );
            }
            return ChatMessageBar(chatId: chatId);
          },
        ),
      ),
    );
  }
}
