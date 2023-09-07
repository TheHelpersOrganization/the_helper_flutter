import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/chat/domain/chat_message.dart';
import 'package:the_helper/src/features/chat/domain/chat_participant.dart';
import 'package:the_helper/src/utils/profile.dart';

part 'chat.freezed.dart';
part 'chat.g.dart';

@freezed
class Chat with _$Chat {
  @JsonSerializable(includeIfNull: false)
  factory Chat({
    required int id,
    String? name,
    required int createdBy,
    required int ownerId,
    required bool isBlocked,
    int? blockedBy,
    required bool isGroup,
    List<int>? participantIds,
    List<ChatParticipant>? participants,
    List<ChatMessage>? messages,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Chat;

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
}

extension ChatX on Chat {
  String getDisplayName({required int myId}) {
    if (name != null) return name!;
    final others = participants!.where((e) => e.id != myId);
    if (!isGroup) {
      return getChatParticipantName(others.firstOrNull);
    }
    // Take max 3 names and join them with comma, e.g. "A, B, C, and 2 others"
    const maxNames = 3;
    final othersLength = participants!.length;
    if (othersLength <= maxNames) {
      return participants!
          .map((e) => getChatParticipantName(e, singularName: true))
          .join(', ');
    }
    final firstNames = participants!
        .take(maxNames)
        .map((e) => getChatParticipantName(e, singularName: true))
        .join(', ');
    final remaining = othersLength - maxNames;
    return '$firstNames, and $remaining other(s)';
  }
}
