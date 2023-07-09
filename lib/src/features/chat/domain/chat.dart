import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/chat/domain/chat_message.dart';
import 'package:the_helper/src/features/profile/domain/profile.dart';

part 'chat.freezed.dart';
part 'chat.g.dart';

@freezed
class Chat with _$Chat {
  @JsonSerializable(includeIfNull: false)
  factory Chat({
    required int id,
    required int createdBy,
    int? blockedBy,
    List<int>? participantIds,
    List<Profile>? participants,
    List<ChatMessage>? messages,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Chat;

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
}
