import 'package:freezed_annotation/freezed_annotation.dart';

import 'organization_status.dart';

part 'organization_log_query.freezed.dart';
part 'organization_log_query.g.dart';

@freezed
class OrganizationLogQuery with _$OrganizationLogQuery {
  @JsonSerializable(includeIfNull: false)
  factory OrganizationLogQuery({
    int? startTime,
    int? endTime,
    bool? isDisabled,
    OrganizationStatus? status,
  }) = _OrganizationLogQuery;

  factory OrganizationLogQuery.fromJson(Map<String, dynamic> json) =>
      _$OrganizationLogQueryFromJson(json);
}
