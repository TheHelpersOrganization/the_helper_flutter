import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/chat/domain/chat.dart';
import 'package:the_helper/src/features/chat/domain/chat_add_participants.dart';
import 'package:the_helper/src/features/chat/domain/chat_group_make_owner.dart';
import 'package:the_helper/src/features/chat/domain/chat_message.dart';
import 'package:the_helper/src/features/chat/domain/chat_message_query.dart';
import 'package:the_helper/src/features/chat/domain/chat_participant_query.dart';
import 'package:the_helper/src/features/chat/domain/chat_query.dart';
import 'package:the_helper/src/features/chat/domain/chat_remove_participant.dart';
import 'package:the_helper/src/features/chat/domain/create_chat.dart';
import 'package:the_helper/src/features/chat/domain/create_chat_group.dart';
import 'package:the_helper/src/features/chat/domain/update_chat_group.dart';
import 'package:the_helper/src/features/profile/domain/profile.dart';
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
    if (data == null) {
      return null;
    }
    return Chat.fromJson(data);
  }

  Future<List<Profile>> getChatParticipants({
    ChatParticipantQuery? query,
  }) async {
    final res = await client.get(
      '/chats/participants',
      queryParameters: query?.toJson(),
    );
    final List<dynamic> resList = res.data['data'];
    return resList.map((e) => Profile.fromJson(e)).toList();
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

  Future<Chat?> getChatToAccount({
    required int accountId,
  }) async {
    final res = await client.get(
      '/chats/to/$accountId',
    );
    final dynamic data = res.data['data'];
    if (data == null) {
      return null;
    }
    return Chat.fromJson(data);
  }

  Future<Chat> createChat(
    CreateChat createChat,
  ) async {
    final res = await client.post(
      '/chats',
      data: createChat.toJson(),
    );
    final dynamic data = res.data['data'];
    return Chat.fromJson(data);
  }

  Future<Chat> createChatGroup(
    CreateChatGroup data,
  ) async {
    final res = await client.post(
      '/chats/groups',
      data: data.toJson(),
    );
    final dynamic resData = res.data['data'];
    return Chat.fromJson(resData);
  }

  Future<Chat> updateChatGroup(
    UpdateChatGroup data,
  ) async {
    final res = await client.put(
      '/chats',
      data: data.toJson(),
    );
    final dynamic resData = res.data['data'];
    return Chat.fromJson(resData);
  }

  Future<void> leaveChatGroup({
    required int chatId,
  }) async {
    await client.post('/chats/groups/leave', data: {
      'chatId': chatId,
    });
  }

  Future<Chat> addChatGroupParticipants(
    ChatAddParticipants data,
  ) async {
    final res = await client.post(
      '/chats/groups/participants',
      data: data.toJson(),
    );
    final resData = res.data['data'];
    return Chat.fromJson(resData);
  }

  Future<Chat> removeChatGroupParticipant(
    ChatRemoveParticipant data,
  ) async {
    final res = await client.delete(
      '/chats/groups/participants',
      data: data.toJson(),
    );
    final resData = res.data['data'];
    return Chat.fromJson(resData);
  }

  Future<Chat> makeOwner(
    ChatGroupMakeOwner data,
  ) async {
    final res = await client.post(
      '/chats/groups/make-owner',
      data: data.toJson(),
    );
    final resData = res.data['data'];
    return Chat.fromJson(resData);
  }
}

final chatRepositoryProvider = Provider.autoDispose<ChatRepository>((ref) {
  final client = ref.watch(dioProvider);
  return ChatRepository(client: client);
});
