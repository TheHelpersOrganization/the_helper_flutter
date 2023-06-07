import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/common/converter/comma_separated_datetimes_converter.dart';

part 'account_query.freezed.dart';
part 'account_query.g.dart';

@freezed
class AccountQuery with _$AccountQuery {
  @JsonSerializable(includeIfNull: false)
  factory AccountQuery({
    String? email,
    bool? isBanned,
    bool? isVerified,
    @IntListConverter() List<int>? ids,
    @CommaSeparatedDateTimesConverter() List<DateTime>? ct,
    int? limit,
    int? offset,
  }) = _ActivityQuery;

  factory AccountQuery.fromJson(Map<String, dynamic> json) =>
      _$AccountQueryFromJson(json);
}

class IntListConverter implements JsonConverter<List<int>?, String?> {
  const IntListConverter();

  @override
  fromJson(String? json) {
    if (json == null) {
      return null;
    }
    return json.split(',').map((e) => int.parse(e)).toList();
  }

  @override
  toJson(List<int>? object) {
    if (object == null) {
      return null;
    }
    return object.join(',');
  }
}
