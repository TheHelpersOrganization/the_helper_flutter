import 'package:freezed_annotation/freezed_annotation.dart';

part 'leave_chat_group.freezed.dart';
part 'leave_chat_group.g.dart';

@freezed
class LeaveChatGroup with _$LeaveChatGroup {
  @JsonSerializable(includeIfNull: false)
  factory LeaveChatGroup({
    required int chatId,
  }) = _LeaveChatGroup;

  factory LeaveChatGroup.fromJson(Map<String, dynamic> json) =>
      _$LeaveChatGroupFromJson(json);
}
