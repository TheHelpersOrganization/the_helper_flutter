import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_remove_participant.freezed.dart';
part 'chat_remove_participant.g.dart';

@freezed
class ChatRemoveParticipant with _$ChatRemoveParticipant {
  @JsonSerializable(includeIfNull: false)
  factory ChatRemoveParticipant({
    required int chatId,
    required int accountId,
  }) = _ChatRemoveParticipant;

  factory ChatRemoveParticipant.fromJson(Map<String, dynamic> json) =>
      _$ChatRemoveParticipantFromJson(json);
}
