import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message_query.freezed.dart';
part 'chat_message_query.g.dart';

@freezed
class ChatMessageQuery with _$ChatMessageQuery {
  @JsonSerializable(includeIfNull: false)
  factory ChatMessageQuery({
    int? limit,
    int? offset,
  }) = _ChatMessageQuery;

  factory ChatMessageQuery.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageQueryFromJson(json);
}
