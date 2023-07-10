import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:the_helper/src/features/chat/data/chat_repository.dart';
import 'package:the_helper/src/features/chat/domain/chat.dart';
import 'package:the_helper/src/features/chat/domain/chat_query.dart';

final chatsProvider = FutureProvider.autoDispose<List<Chat>>((ref) async {
  final repo = ref.watch(chatRepositoryProvider);
  return repo.getChats();
});

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
}

final chatListPagedNotifierProvider = StateNotifierProvider.autoDispose<
    ChatListPagedNotifier, PagedState<int, Chat>>(
  (ref) => ChatListPagedNotifier(
    chatRepository: ref.watch(chatRepositoryProvider),
  ),
);
