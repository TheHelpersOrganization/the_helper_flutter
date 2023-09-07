import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:the_helper/src/common/riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';
import 'package:the_helper/src/features/chat/data/chat_repository.dart';
import 'package:the_helper/src/features/chat/domain/chat.dart';
import 'package:the_helper/src/features/chat/domain/chat_query.dart';
import 'package:the_helper/src/utils/socket_provider.dart';

final showSearchProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});

final searchPatternProvider = StateProvider.autoDispose<String>((ref) {
  return '';
});

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
      chatListNotifier.updateChat(chat);
    }

    socket.on('chat-updated', handleChatUpdated);

    handleChatCreated(data) {
      final chat = Chat.fromJson(data);
      chatListNotifier.updateChat(chat);
    }

    socket.on('chat-deleted', (data) {
      final chat = Chat.fromJson(data);
      chatListNotifier.removeChat(chat);
    });

    socket.on('chat-created', handleChatCreated);

    ref.onDispose(() {
      socket.off('chat-created', handleChatCreated);
      socket.off('chat-updated', handleChatUpdated);
    });

    return socket;
  },
);

class ChatListPagedNotifier extends PagedNotifier<int, Chat> {
  final AutoDisposeStateNotifierProviderRef ref;
  final ChatRepository chatRepository;
  final String searchPattern;

  ChatListPagedNotifier({
    required this.ref,
    required this.chatRepository,
    required this.searchPattern,
  }) : super(
          load: (page, limit) {
            return chatRepository.getChats(
              query: ChatQuery(
                limit: limit,
                offset: page * limit,
                sort: ChatQuerySort.updatedAtDesc,
                include: [ChatQueryInclude.message],
                name: searchPattern.trim() == '' ? null : searchPattern.trim(),
                messageLimit: 1,
              ),
            );
          },
          nextPageKeyBuilder: NextPageKeyBuilderDefault.mysqlPagination,
        );

  void updateChat(Chat chat) async {
    if (!mounted) {
      return;
    }
    final oldChats = state.records;
    if (oldChats == null) {
      return;
    }
    // If new chat does not contains my id, remove it from list
    final myId = (await ref.watch(authServiceProvider.future))!.account.id;
    if (chat.participantIds?.isEmpty == true ||
        chat.participantIds?.contains(myId) != true) {
      state = state.copyWith(
        records: oldChats.where((element) => element.id != chat.id).toList(),
      );
      return;
    }
    // If chat has no message, do not update
    if (!chat.isGroup && chat.messages!.isEmpty) {
      return;
    }
    final oldChatIndex =
        oldChats.indexWhere((element) => element.id == chat.id);
    if (oldChatIndex < 0) {
      // If chat is in search mode, do not update
      if (searchPattern.trim() != '') {
        return;
      }
      state = state.copyWith(records: [chat, ...oldChats]);
      return;
    }
    final oldChat = oldChats[oldChatIndex];
    if (oldChat.updatedAt.isAtSameMomentAs(chat.updatedAt)) {
      oldChats[oldChatIndex] = chat;
      state = state.copyWith(records: [...oldChats]);
    } else {
      oldChats.removeWhere((element) => element.id == chat.id);
      state = state.copyWith(records: [chat, ...oldChats]);
    }
  }

  void removeChat(Chat chat) async {
    if (!mounted) {
      return;
    }
    final oldChats = state.records;
    if (oldChats == null) {
      return;
    }
    final oldChatIndex =
        oldChats.indexWhere((element) => element.id == chat.id);
    if (oldChatIndex < 0) {
      return;
    }
    oldChats.removeAt(oldChatIndex);
    state = state.copyWith(records: [...oldChats]);
  }
}

final chatListPagedNotifierProvider = StateNotifierProvider.autoDispose<
    ChatListPagedNotifier, PagedState<int, Chat>>(
  (ref) {
    return ChatListPagedNotifier(
      ref: ref,
      searchPattern: ref.watch(searchPatternProvider),
      chatRepository: ref.watch(chatRepositoryProvider),
    );
  },
);
