import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:the_helper/src/features/chat/data/chat_repository.dart';
import 'package:the_helper/src/features/chat/domain/chat.dart';
import 'package:the_helper/src/features/chat/domain/chat_query.dart';
import 'package:the_helper/src/utils/socket_provider.dart';

final chatListSocketProvider = FutureProvider.autoDispose<Socket>(
  (ref) async {
    final socket = ref.watch(socketProvider);
    final chatListNotifier = ref.watch(chatListPagedNotifierProvider.notifier);

    final completer = Completer();
    socket.emitWithAck('join-chat', '', ack: (data) {
      completer.complete(data);
    });
    await completer.future;

    handleChatUpdated(data) {
      final chat = Chat.fromJson(data);
      chatListNotifier.setChat(chat);
    }

    socket.on('chat-updated', handleChatUpdated);

    ref.onDispose(() {
      socket.off('chat-updated', handleChatUpdated);
    });

    return socket;
  },
);

class ChatListPagedNotifier extends PagedNotifier<int, Chat> {
  final ChatRepository chatRepository;

  ChatListPagedNotifier({
    required this.chatRepository,
  }) : super(
          load: (page, limit) {
            return chatRepository.getChats(
              query: ChatQuery(
                limit: limit,
                offset: page * limit,
                sort: ChatQuerySort.updatedAtDesc,
                include: [ChatQueryInclude.message],
                messageLimit: 1,
              ),
            );
          },
          nextPageKeyBuilder: NextPageKeyBuilderDefault.mysqlPagination,
        );

  void setChat(Chat chat) {
    if (!mounted) {
      return;
    }
    final oldChats = state.records;
    if (oldChats == null) {
      return;
    }
    final chatIndex = oldChats.indexWhere((element) => element.id == chat.id);
    if (chatIndex < 0) {
      state = state.copyWith(records: [chat, ...oldChats]);
      return;
    }
    oldChats[chatIndex] = chat;
    state = state.copyWith(records: [...oldChats]);
  }
}

final chatListPagedNotifierProvider = StateNotifierProvider.autoDispose<
    ChatListPagedNotifier, PagedState<int, Chat>>(
  (ref) {
    return ChatListPagedNotifier(
      chatRepository: ref.watch(chatRepositoryProvider),
    );
  },
);
