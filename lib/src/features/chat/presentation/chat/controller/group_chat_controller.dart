import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/chat/domain/leave_chat_group.dart';
import 'package:the_helper/src/features/chat/presentation/chat/controller/chat_controller.dart';

class LeaveGroupChatController extends AutoDisposeAsyncNotifier {
  @override
  FutureOr build() {}

  Future<void> leaveGroupChat({required int chatId}) async {
    if (state.isLoading) {
      return;
    }
    final socket = await ref.watch(chatSocketProvider(chatId).future);
    if (socket == null) {
      return;
    }

    state = const AsyncValue.loading();

    Completer completer = Completer();
    socket.emitWithAck(
      'leave-chat-group',
      LeaveChatGroup(chatId: chatId).toJson(),
      ack: (data) {
        state = const AsyncValue.data(null);
        completer.complete(data);
      },
    );

    return completer.future;
  }
}

final leaveGroupChatControllerProvider = AutoDisposeAsyncNotifierProvider(
  () => LeaveGroupChatController(),
);

class DeleteChatGroupController extends AutoDisposeAsyncNotifier {
  @override
  FutureOr build() {}

  Future<void> deleteChatGroup({required int chatId}) async {
    if (state.isLoading) {
      return;
    }
    final socket = await ref.watch(chatSocketProvider(chatId).future);
    if (socket == null) {
      return;
    }

    state = const AsyncValue.loading();

    Completer completer = Completer();
    socket.emitWithAck(
      'delete-chat-group',
      {
        'chatId': chatId,
      },
      ack: (data) {
        state = const AsyncValue.data(null);
        completer.complete(data);
      },
    );

    return completer.future;
  }
}

final deleteChatGroupControllerProvider = AutoDisposeAsyncNotifierProvider(
  () => DeleteChatGroupController(),
);
