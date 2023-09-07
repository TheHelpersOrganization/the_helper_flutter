import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_chat_group.freezed.dart';
part 'update_chat_group.g.dart';

@freezed
class UpdateChatGroup with _$UpdateChatGroup {
  @JsonSerializable(includeIfNull: false)
  factory UpdateChatGroup({
    required int chatId,
    String? name,
    int? avatar,
  }) = _UpdateChatGroup;

  factory UpdateChatGroup.fromJson(Map<String, dynamic> json) =>
      _$UpdateChatGroupFromJson(json);
}
