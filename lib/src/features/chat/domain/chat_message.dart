import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

@freezed
class ChatMessage with _$ChatMessage {
  @JsonSerializable(includeIfNull: false)
  factory ChatMessage({
    required int chatId,
    required int sender,
    required String message,
    required DateTime createdAt,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
}

@freezed
class CreateChatMessage with _$CreateChatMessage {
  @JsonSerializable(includeIfNull: false)
  factory CreateChatMessage({
    required int chatId,
    required String message,
  }) = _CreateChatMessage;

  factory CreateChatMessage.fromJson(Map<String, dynamic> json) =>
      _$CreateChatMessageFromJson(json);
}
