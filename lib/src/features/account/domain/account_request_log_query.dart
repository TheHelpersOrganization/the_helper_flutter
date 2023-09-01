import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/common/converter/comma_separated_strings_converter.dart';

import 'account_request_query.dart';

part 'account_request_log_query.freezed.dart';
part 'account_request_log_query.g.dart';

@freezed
class AccountRequestLogQuery with _$AccountRequestLogQuery {
  @JsonSerializable(includeIfNull: false)
  factory AccountRequestLogQuery({
    DateTime? startDate,
    DateTime? endDate,
    @CommaSeparatedStringsConverter() List<AccountRequestStatus>? status,
    bool? isVerified,
  }) = _AccountRequestLogQuery;

  factory AccountRequestLogQuery.fromJson(Map<String, dynamic> json) =>
      _$AccountRequestLogQueryFromJson(json);
}
