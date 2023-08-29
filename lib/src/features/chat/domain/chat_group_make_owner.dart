import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_group_make_owner.freezed.dart';
part 'chat_group_make_owner.g.dart';

@freezed
class ChatGroupMakeOwner with _$ChatGroupMakeOwner {
  @JsonSerializable(includeIfNull: false)
  factory ChatGroupMakeOwner({
    required int chatId,
    required int accountId,
  }) = _ChatGroupMakeOwner;

  factory ChatGroupMakeOwner.fromJson(Map<String, dynamic> json) =>
      _$ChatGroupMakeOwnerFromJson(json);
}
