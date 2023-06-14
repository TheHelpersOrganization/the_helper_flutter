import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/common/converter/comma_separated_datetimes_converter.dart';

part 'account_request_query.freezed.dart';
part 'account_request_query.g.dart';

@freezed
class AccountRequestQuery with _$AccountRequestQuery {
  @JsonSerializable(includeIfNull: false)
  factory AccountRequestQuery({
    String? include,
    required String status,
    int? limit,
    int? offset,
  }) = _AccountRequestQuery;

  factory AccountRequestQuery.fromJson(Map<String, dynamic> json) =>
      _$AccountRequestQueryFromJson(json);
}