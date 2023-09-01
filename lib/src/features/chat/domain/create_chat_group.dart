import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_chat_group.freezed.dart';
part 'create_chat_group.g.dart';

@freezed
class CreateChatGroup with _$CreateChatGroup {
  @JsonSerializable(includeIfNull: false)
  factory CreateChatGroup({
    String? name,
    required List<int> to,
    String? initialMessage,
  }) = _CreateChatGroup;

  factory CreateChatGroup.fromJson(Map<String, dynamic> json) =>
      _$CreateChatGroupFromJson(json);
}
