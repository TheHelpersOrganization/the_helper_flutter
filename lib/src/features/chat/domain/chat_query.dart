import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/common/converter/comma_separated_strings_converter.dart';

part 'chat_query.freezed.dart';
part 'chat_query.g.dart';

class ChatQuerySort {
  static const updatedAtAsc = 'updatedAt';
  static const updatedAtDesc = '-updatedAt';
}

class ChatQueryInclude {
  static const message = 'message';
}

@freezed
class ChatQuery with _$ChatQuery {
  @JsonSerializable(includeIfNull: false)
  factory ChatQuery({
    bool? isBlocked,
    bool? isGroup,
    @CommaSeparatedStringsConverter() List<String>? include,
    String? sort,
    int? limit,
    int? offset,
    int? messageLimit,
    int? messageOffset,
  }) = _ChatQuery;

  factory ChatQuery.fromJson(Map<String, dynamic> json) =>
      _$ChatQueryFromJson(json);
}
