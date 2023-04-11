import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_account_query.freezed.dart';
part 'get_account_query.g.dart';

@freezed
class GetAccountQuery with _$GetAccountQuery {
  @JsonSerializable(includeIfNull: false)
  factory GetAccountQuery({
    int? limit,
    int? offset,
    bool? isBanned,
    @IntListConverter() List<int>? ids,
  }) = _GetAccountQuery;

  factory GetAccountQuery.fromJson(Map<String, dynamic> json) =>
      _$GetAccountQueryFromJson(json);
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
