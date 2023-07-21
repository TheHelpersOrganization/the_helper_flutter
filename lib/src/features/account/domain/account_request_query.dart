import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/common/converter/comma_separated_strings_converter.dart';

part 'account_request_query.freezed.dart';
part 'account_request_query.g.dart';

enum AccountRequestStatus {
  pending, 
  completed, 
  blocked
}

class AccountRequestInclude {
  static const file = 'file';
  static const history = 'history';
}

@freezed
class AccountRequestQuery with _$AccountRequestQuery {
  @JsonSerializable(includeIfNull: false)
  factory AccountRequestQuery({
    int? accountId,
    @CommaSeparatedStringsConverter() List<String>? include,
    AccountRequestStatus? status,
    int? limit,
    int? offset,
  }) = _AccountRequestQuery;

  factory AccountRequestQuery.fromJson(Map<String, dynamic> json) =>
      _$AccountRequestQueryFromJson(json);
}