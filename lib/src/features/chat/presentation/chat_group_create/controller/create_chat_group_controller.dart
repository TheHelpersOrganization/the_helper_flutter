import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';
import 'package:the_helper/src/features/chat/data/chat_repository.dart';
import 'package:the_helper/src/features/chat/domain/chat_participant_query.dart';
import 'package:the_helper/src/features/chat/domain/create_chat_group.dart';
import 'package:the_helper/src/features/profile/domain/profile.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/async_value.dart';

final chatNameTextEditingControllerProvider =
    ChangeNotifierProvider.autoDispose(
  (ref) => TextEditingController(),
);

final selectedProfilesProvider =
    StateProvider.autoDispose<Set<Profile>>((ref) => {});

final searchPatternProvider = StateProvider.autoDispose<String>((ref) => '');

final participantsProvider =
    FutureProvider.autoDispose<List<Profile>>((ref) async {
  final searchPattern = ref.watch(searchPatternProvider).trim();
  final selectedProfiles = ref.watch(selectedProfilesProvider);
  final myId = (await ref.watch(authServiceProvider.future))!.account.id;

  return ref.watch(chatRepositoryProvider).getChatParticipants(
        query: ChatParticipantQuery(
          search: searchPattern.isEmpty ? null : searchPattern,
          excludeId: [
            myId,
            ...selectedProfiles.map((e) => e.id!),
          ],
          limit: 10,
        ),
      );
});

class CreateChatGroupController extends AutoDisposeAsyncNotifier<dynamic> {
  late ChatRepository _chatRepository;
  late GoRouter _router;

  @override
  FutureOr build() {
    _chatRepository = ref.watch(chatRepositoryProvider);
    _router = ref.watch(routerProvider);
  }

  Future<void> createChatGroup(
    CreateChatGroup data,
  ) async {
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(seconds: 2));
    state = await guardAsyncValue(() => _chatRepository.createChatGroup(data));
    if (state.hasError) {
      return;
    }
    _router.goNamed(AppRoute.chats.name);
  }
}

final createChatGroupControllerProvider =
    AutoDisposeAsyncNotifierProvider(() => CreateChatGroupController());
