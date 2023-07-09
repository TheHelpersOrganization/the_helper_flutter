import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:the_helper/src/common/screens/screen404.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/common/widget/no_data_found.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';
import 'package:the_helper/src/features/chat/domain/chat_message.dart';
import 'package:the_helper/src/features/chat/presentation/chat/controller/chat_controller.dart';
import 'package:the_helper/src/utils/image.dart';
import 'package:the_helper/src/utils/profile.dart';

class ChatScreen extends ConsumerWidget {
  final int chatId;

  const ChatScreen({
    super.key,
    required this.chatId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatProvider(chatId));
    final yourId = ref.watch(authServiceProvider).asData!.value!.account.id;
    final chatListState =
        ref.watch(chatMessageListPagedNotifierProvider(chatId));

    return Scaffold(
      body: chatState.when(
        skipLoadingOnRefresh: false,
        data: (chat) {
          if (chat == null) {
            return const DevelopingScreen();
          }

          final otherProfile =
              chat.participants?.firstWhere((e) => e.id != yourId);
          final yourProfile =
              chat.participants?.firstWhere((e) => e.id == yourId);

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                title: Text(getProfileName(otherProfile)),
                floating: true,
              )
            ],
            body: Padding(
              padding: const EdgeInsets.all(12),
              child: RiverPagedBuilder<int, ChatMessage>.autoDispose(
                firstPageKey: 0,
                provider: chatMessageListPagedNotifierProvider(chatId),
                pagedBuilder: (controller, builder) => PagedListView(
                  pagingController: controller,
                  builderDelegate: builder,
                ),
                itemBuilder: (context, chatMessage, index) {
                  final isYou = chatMessage.sender == yourId;
                  final previous = index == 0
                      ? null
                      : chatListState.records?.elementAtOrNull(index - 1);
                  final showAvatar = previous?.sender != chatMessage.sender;
                  final widget = Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment:
                        isYou ? MainAxisAlignment.end : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (!isYou)
                        if (showAvatar)
                          getBackendCircleAvatarOrCharacter(
                            otherProfile?.avatarId,
                            getProfileName(otherProfile),
                          )
                        else
                          const SizedBox(width: 48),
                      Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 16,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
                            ),
                            child: Text(
                              chatMessage.message,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ),
                      ),
                      if (isYou)
                        if (showAvatar)
                          getBackendCircleAvatarOrCharacter(
                            yourProfile?.avatarId,
                            getProfileName(yourProfile),
                            radius: 18,
                          )
                        else
                          const SizedBox(width: 36),
                    ],
                  );

                  return widget;
                },
                limit: 5,
                pullToRefresh: true,
                firstPageErrorIndicatorBuilder: (context, controller) =>
                    CustomErrorWidget(
                  onRetry: () => controller.retryLastFailedRequest(),
                ),
                newPageErrorIndicatorBuilder: (context, controller) =>
                    CustomErrorWidget(
                  onRetry: () => controller.retryLastFailedRequest(),
                ),
                noItemsFoundIndicatorBuilder: (context, _) =>
                    const NoDataFound.simple(
                  contentTitle: 'Send the first message to start the chat',
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
      bottomNavigationBar: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Type a message',
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
