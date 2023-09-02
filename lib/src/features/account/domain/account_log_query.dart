import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_log_query.freezed.dart';
part 'account_log_query.g.dart';

@freezed
class AccountLogQuery with _$AccountLogQuery {
  @JsonSerializable(includeIfNull: false)
  factory AccountLogQuery({
    int? startTime,
    int? endTime,
    bool? isEmailVerified,
    bool? isAccountVerified,
    bool? isBanned,
  }) = _AccountLogQuery;

  factory AccountLogQuery.fromJson(Map<String, dynamic> json) =>
      _$AccountLogQueryFromJson(json);
}
