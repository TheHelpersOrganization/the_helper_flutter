import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_participant.freezed.dart';
part 'chat_participant.g.dart';

@freezed
class ChatParticipant with _$ChatParticipant {
  @JsonSerializable(includeIfNull: false)
  factory ChatParticipant({
    required int id,
    required String email,
    String? username,
    String? phoneNumber,
    String? firstName,
    String? lastName,
    int? avatarId,
    required bool read,
  }) = _ChatParticipant;

  factory ChatParticipant.fromJson(Map<String, dynamic> json) =>
      _$ChatParticipantFromJson(json);
}
