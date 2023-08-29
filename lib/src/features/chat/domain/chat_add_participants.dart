import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_add_participants.freezed.dart';
part 'chat_add_participants.g.dart';

@freezed
class ChatAddParticipants with _$ChatAddParticipants {
  @JsonSerializable(includeIfNull: false)
  factory ChatAddParticipants({
    required int chatId,
    required List<int> accountIds,
  }) = _ChatAddParticipants;

  factory ChatAddParticipants.fromJson(Map<String, dynamic> json) =>
      _$ChatAddParticipantsFromJson(json);
}
