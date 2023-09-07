import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';
import 'package:the_helper/src/features/chat/data/chat_repository.dart';
import 'package:the_helper/src/features/chat/domain/chat.dart';
import 'package:the_helper/src/features/chat/domain/chat_message.dart';
import 'package:the_helper/src/features/chat/domain/chat_message_query.dart';
import 'package:the_helper/src/features/chat/domain/create_chat.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/async_value.dart';
import 'package:the_helper/src/utils/socket_provider.dart';

// Use change notifier provider to provide the controller
// When the controller text changes, riverpod will rebuild the widget
final chatMessageEditingControllerProvider =
    ChangeNotifierProvider.autoDispose<TextEditingController>(
  (ref) {
    return TextEditingController();
  },
);
final scrollControllerProvider =
    ChangeNotifierProvider.autoDispose<ScrollController>(
  (ref) => ScrollController(),
);

class ChatData {
  final Chat chat;
  final Socket socket;

  ChatData({
    required this.chat,
    required this.socket,
  });
}

class ChatNotifier extends AutoDisposeFamilyAsyncNotifier<Chat?, int> {
  late GoRouter _router;
  late int _myId;

  @override
  FutureOr<Chat?> build(int arg) async {
    _router = ref.watch(routerProvider);
    final repo = ref.watch(chatRepositoryProvider);
    final chat = await repo.getChatById(id: arg);
    _myId = (await ref.watch(authServiceProvider.future))!.account.id;
    return chat;
  }

  Future<void> setChat(Chat chat) async {
    if (chat.participantIds?.isEmpty == true ||
        chat.participantIds?.contains(_myId) != true) {
      if (_router.canPop()) {
        _router.pop();
      } else {
        _router.goNamed(AppRoute.chats.name);
      }
      return;
    }
    state = AsyncValue.data(chat);
  }
}

final chatProvider =
    AutoDisposeAsyncNotifierProviderFamily<ChatNotifier, Chat?, int>(
  () => ChatNotifier(),
);

final chatSocketProvider = FutureProvider.autoDispose.family<Socket?, int>(
  (ref, chatId) async {
    // Don't watch the chat provider here, because we don't want to rebuild
    final chat = await ref.read(chatProvider(chatId).future);
    if (chat == null) {
      return null;
    }
    final chatNotifier = ref.read(chatProvider(chatId).notifier);
    final messagesNotifier =
        ref.read(chatMessageListPagedNotifierProvider(chatId).notifier);
    final scrollController = ref.read(scrollControllerProvider);

    final socket = ref.watch(socketProvider);
    final router = ref.watch(routerProvider);

    final completer = Completer();
    socket.emitWithAck('join-chat', '', ack: (data) {
      completer.complete(data);
    });
    await completer.future;

    handleReceiveMessage(data) {
      final message = ChatMessage.fromJson(data);
      // Only add the message if it's from the same chat
      if (message.chatId != chatId) {
        return;
      }
      messagesNotifier.addMessage(message);
      // Scroll to bottom
      scrollController.jumpTo(scrollController.position.minScrollExtent);
      // Mark as read
      socket.emit('read-chat', chatId);
    }

    socket.on('receive-message', handleReceiveMessage);

    socket.on('chat-updated', (data) {
      final chat = Chat.fromJson(data);
      if (chat.id != chatId) {
        return;
      }
      chatNotifier.setChat(chat);
    });

    socket.on('chat-deleted', (data) {
      final chat = Chat.fromJson(data);
      if (chat.id != chatId) {
        return;
      }
      if (router.canPop()) {
        router.pop();
      } else {
        router.goNamed(AppRoute.chats.name);
      }
    });

    ref.onDispose(() {
      socket.off('receive-message', handleReceiveMessage);
    });

    return socket;
  },
);

class ChatMessageListPagedNotifier extends PagedNotifier<int, ChatMessage> {
  final int chatId;
  final ChatRepository chatRepository;

  ChatMessageListPagedNotifier({
    required this.chatId,
    required this.chatRepository,
  }) : super(
          load: (page, limit) {
            return chatRepository.getChatMessages(
              chatId: chatId,
              query: ChatMessageQuery(
                limit: limit,
                offset: page * limit,
              ),
            );
          },
          nextPageKeyBuilder: NextPageKeyBuilderDefault.mysqlPagination,
        );

  addMessage(ChatMessage message) {
    final newMessages = [message, ...(state.records ?? <ChatMessage>[])];
    state = state.copyWith(records: newMessages);
  }
}

final chatMessageListPagedNotifierProvider = StateNotifierProvider.family
    .autoDispose<ChatMessageListPagedNotifier, PagedState<int, ChatMessage>,
        int>(
  (ref, chatId) => ChatMessageListPagedNotifier(
    chatId: chatId,
    chatRepository: ref.watch(chatRepositoryProvider),
  ),
);

class ChatController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> sendMessage(
    CreateChatMessage message,
  ) async {
    if (state.isLoading) {
      return;
    }
    final socket = await ref.watch(chatSocketProvider(message.chatId).future);
    if (socket == null) {
      return;
    }

    Completer completer = Completer();
    socket.emitWithAck('send-message', message.toJson(), ack: (data) {
      completer.complete(data);
    });

    return completer.future;
  }
}

final chatControllerProvider =
    AutoDisposeAsyncNotifierProvider<ChatController, void>(
  () {
    return ChatController();
  },
);

class BlockChatController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() async {}

  Future<void> blockChat(int chatId) async {
    if (state.isLoading) {
      return;
    }
    final socket = await ref.watch(chatSocketProvider(chatId).future);
    if (socket == null) {
      return;
    }

    state = const AsyncValue.loading();

    Completer completer = Completer();
    socket.emitWithAck('block-chat', chatId, ack: (data) {
      state = const AsyncValue.data(null);
      completer.complete(data);
    });

    return completer.future;
  }
}

final blockChatControllerProvider =
    AutoDisposeAsyncNotifierProvider<BlockChatController, void>(
  () {
    return BlockChatController();
  },
);

class UnblockChatController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() async {}

  Future<void> unblockChat(int chatId) async {
    if (state.isLoading) {
      return;
    }
    final socket = await ref.watch(chatSocketProvider(chatId).future);
    if (socket == null) {
      return;
    }

    state = const AsyncValue.loading();

    Completer completer = Completer();
    socket.emitWithAck('unblock-chat', chatId, ack: (data) {
      state = const AsyncValue.data(null);
      completer.complete(data);
    });

    return completer.future;
  }
}

final unblockChatControllerProvider =
    AutoDisposeAsyncNotifierProvider<UnblockChatController, void>(
  () {
    return UnblockChatController();
  },
);

class ReadChatController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() async {}

  Future<void> readChat(int chatId) async {
    if (state.isLoading) {
      return;
    }
    final socket = await ref.watch(chatSocketProvider(chatId).future);
    if (socket == null) {
      return;
    }

    state = const AsyncValue.loading();

    Completer completer = Completer();
    socket.emitWithAck('read-chat', chatId, ack: (data) {
      state = const AsyncValue.data(null);
      completer.complete(data);
    });

    return completer.future;
  }
}

final readChatControllerProvider =
    AutoDisposeAsyncNotifierProvider<ReadChatController, void>(
  () {
    return ReadChatController();
  },
);

class CreateChatController extends AutoDisposeAsyncNotifier<void> {
  late Object? _key;

  @override
  FutureOr<void> build() async {
    _key = Object();
    ref.onDispose(() => _key = null);
  }

  Future<void> createChat(CreateChat data) async {
    if (state.isLoading) {
      return;
    }
    state = const AsyncValue.loading();
    final key = _key;
    final res = await guardAsyncValue(
      () => ref.read(chatRepositoryProvider).createChat(data),
    );
    if (key != _key) {
      return;
    }
    if (res.hasError) {
      state = AsyncValue.error(res.asError!.error, res.stackTrace!);
      return;
    }
    state = const AsyncValue.data(null);
    final chat = res.asData?.value;
    if (chat != null) {
      ref.watch(routerProvider).goNamed(AppRoute.chat.name, pathParameters: {
        'chatId': chat.id.toString(),
      });
    }
  }
}

final createChatControllerProvider =
    AutoDisposeAsyncNotifierProvider<CreateChatController, void>(
  () {
    return CreateChatController();
  },
);
