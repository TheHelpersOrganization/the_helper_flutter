import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/chat/data/chat_repository.dart';
import 'package:the_helper/src/features/chat/domain/chat_group_make_owner.dart';
import 'package:the_helper/src/features/chat/domain/chat_remove_participant.dart';
import 'package:the_helper/src/utils/async_value.dart';

class ChatGroupParticipantRemoveController extends AutoDisposeAsyncNotifier {
  late ChatRepository _chatRepository;

  @override
  FutureOr build() {
    _chatRepository = ref.watch(chatRepositoryProvider);
  }

  Future<void> removeParticipant(ChatRemoveParticipant data) async {
    state = const AsyncValue.loading();
    state = await guardAsyncValue(
      () => _chatRepository.removeChatGroupParticipant(data),
    );
  }
}

final chatGroupParticipantRemoveControllerProvider =
    AutoDisposeAsyncNotifierProvider(
  () => ChatGroupParticipantRemoveController(),
);

class ChatGroupMakeOwnerController extends AutoDisposeAsyncNotifier {
  late ChatRepository _chatRepository;

  @override
  FutureOr build() {
    _chatRepository = ref.watch(chatRepositoryProvider);
  }

  Future<void> makeOwner(ChatGroupMakeOwner data) async {
    state = const AsyncValue.loading();
    state = await guardAsyncValue(
      () => _chatRepository.makeOwner(data),
    );
  }
}

final chatGroupMakeOwnerControllerProvider = AutoDisposeAsyncNotifierProvider(
  () => ChatGroupMakeOwnerController(),
);
