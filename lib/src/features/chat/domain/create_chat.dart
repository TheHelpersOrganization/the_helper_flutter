import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_chat.freezed.dart';
part 'create_chat.g.dart';

@freezed
class CreateChat with _$CreateChat {
  @JsonSerializable(includeIfNull: false)
  factory CreateChat({
    required int to,
    int? avatar,
    String? initialMessage,
  }) = _CreateChat;

  factory CreateChat.fromJson(Map<String, dynamic> json) =>
      _$CreateChatFromJson(json);
}
