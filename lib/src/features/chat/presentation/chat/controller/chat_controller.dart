import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:the_helper/src/features/chat/data/chat_repository.dart';
import 'package:the_helper/src/features/chat/domain/chat.dart';
import 'package:the_helper/src/features/chat/domain/chat_message.dart';
import 'package:the_helper/src/features/chat/domain/chat_message_query.dart';

final chatProvider =
    FutureProvider.family.autoDispose<Chat?, int>((ref, id) async {
  final repo = ref.watch(chatRepositoryProvider);
  return repo.getChatById(id: id);
});

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
}

final chatMessageListPagedNotifierProvider = StateNotifierProvider.family
    .autoDispose<ChatMessageListPagedNotifier, PagedState<int, ChatMessage>,
        int>(
  (ref, chatId) => ChatMessageListPagedNotifier(
    chatId: chatId,
    chatRepository: ref.watch(chatRepositoryProvider),
  ),
);
