import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';
import 'package:the_helper/src/features/chat/data/chat_repository.dart';
import 'package:the_helper/src/features/chat/domain/chat_add_participants.dart';
import 'package:the_helper/src/features/chat/domain/chat_participant_query.dart';
import 'package:the_helper/src/features/chat/presentation/chat/controller/chat_controller.dart';
import 'package:the_helper/src/features/profile/domain/profile.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/async_value.dart';

final selectedProfilesProvider =
    StateProvider.autoDispose<Set<Profile>>((ref) => {});

final searchPatternProvider = StateProvider.autoDispose<String>((ref) => '');

final availableParticipantsProvider =
    FutureProvider.autoDispose.family<List<Profile>, int>((ref, chatId) async {
  final searchPattern = ref.watch(searchPatternProvider).trim();
  final chatParticipants =
      (await ref.watch(chatProvider(chatId).future))!.participantIds!;
  final selectedProfiles = ref.watch(selectedProfilesProvider);
  final myId = (await ref.watch(authServiceProvider.future))!.account.id;

  return ref.watch(chatRepositoryProvider).getChatParticipants(
        query: ChatParticipantQuery(
          excludeId: [
            ...selectedProfiles.map((e) => e.id!),
            ...chatParticipants,
            myId,
          ],
          search: searchPattern,
          limit: 5,
        ),
      );
});

class ChatGroupParticipantAddController
    extends AutoDisposeAsyncNotifier<dynamic> {
  late ChatRepository _chatRepository;
  late GoRouter _router;

  @override
  FutureOr build() {
    _chatRepository = ref.watch(chatRepositoryProvider);
    _router = ref.watch(routerProvider);
  }

  Future<void> addParticipants(ChatAddParticipants data) async {
    state = const AsyncValue.loading();
    state = await guardAsyncValue(
        () => _chatRepository.addChatGroupParticipants(data));
    if (state.hasError) {
      return;
    }
    _router.pop();
  }
}

final chatGroupParticipantAddControllerProvider =
    AutoDisposeAsyncNotifierProvider(
  () => ChatGroupParticipantAddController(),
);
