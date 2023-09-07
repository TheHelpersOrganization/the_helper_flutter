import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/features/chat/data/chat_repository.dart';
import 'package:the_helper/src/features/chat/domain/chat.dart';
import 'package:the_helper/src/features/chat/domain/update_chat_group.dart';
import 'package:the_helper/src/features/chat/presentation/chat/controller/chat_controller.dart';
import 'package:the_helper/src/router/router.dart';

final chatProvider = FutureProvider.autoDispose.family<Chat?, int>(
  (ref, id) => ref.watch(chatRepositoryProvider).getChatById(id: id),
);

final chatNameProvider = StateProvider.autoDispose<String?>((ref) => null);

class UpdateChatGroupController extends AutoDisposeAsyncNotifier {
  late GoRouter _router;

  @override
  FutureOr build() {
    _router = ref.watch(routerProvider);
  }

  Future<void> updateChatGroup({
    required UpdateChatGroup data,
  }) async {
    if (state.isLoading) {
      return;
    }
    final socket = await ref.watch(chatSocketProvider(data.chatId).future);
    if (socket == null) {
      return;
    }

    state = const AsyncValue.loading();

    Completer completer = Completer();
    socket.emitWithAck(
      'update-chat-group',
      data.toJson(),
      ack: (data) {
        state = const AsyncValue.data(null);
        if (_router.canPop()) {
          _router.pop();
        } else {
          _router.goNamed(AppRoute.chat.name, pathParameters: {
            AppRouteParameter.chatId: data.chatId,
          });
        }
        completer.complete(data);
      },
    );

    return completer.future;
  }
}

final updateChatGroupControllerProvider = AutoDisposeAsyncNotifierProvider(
  () => UpdateChatGroupController(),
);
