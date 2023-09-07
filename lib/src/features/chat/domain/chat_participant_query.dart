import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/common/converter/comma_separated_ints_converter.dart';

part 'chat_participant_query.freezed.dart';
part 'chat_participant_query.g.dart';

@freezed
class ChatParticipantQuery with _$ChatParticipantQuery {
  @JsonSerializable(includeIfNull: false)
  factory ChatParticipantQuery({
    String? search,
    @CommaSeparatedIntsConverter() List<int>? excludeId,
    int? limit,
    int? offset,
  }) = _ChatParticipantQuery;

  factory ChatParticipantQuery.fromJson(Map<String, dynamic> json) =>
      _$ChatParticipantQueryFromJson(json);
}
