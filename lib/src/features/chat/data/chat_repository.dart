import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/chat/domain/chat.dart';
import 'package:the_helper/src/features/chat/domain/chat_message.dart';
import 'package:the_helper/src/features/chat/domain/chat_message_query.dart';
import 'package:the_helper/src/features/chat/domain/chat_query.dart';
import 'package:the_helper/src/utils/dio.dart';

class ChatRepository {
  final Dio client;

  ChatRepository({
    required this.client,
  });

  Future<List<Chat>> getChats({
    ChatQuery? query,
  }) async {
    final res = await client.get(
      '/chats',
      queryParameters: query?.toJson(),
    );
    final List<dynamic> resList = res.data['data'];
    return resList.map((e) => Chat.fromJson(e)).toList();
  }

  Future<Chat?> getChatById({
    required int id,
    ChatQuery? query,
  }) async {
    final res = await client.get(
      '/chats/$id',
      queryParameters: query?.toJson(),
    );
    final dynamic data = res.data['data'];
    return Chat.fromJson(data);
  }

  Future<List<ChatMessage>> getChatMessages({
    required int chatId,
    ChatMessageQuery? query,
  }) async {
    final res = await client.get(
      '/chats/$chatId/messages',
      queryParameters: query?.toJson(),
    );
    final List<dynamic> resList = res.data['data'];
    return resList.map((e) => ChatMessage.fromJson(e)).toList();
  }
}

final chatRepositoryProvider = Provider.autoDispose<ChatRepository>((ref) {
  final client = ref.watch(dioProvider);
  return ChatRepository(client: client);
});
