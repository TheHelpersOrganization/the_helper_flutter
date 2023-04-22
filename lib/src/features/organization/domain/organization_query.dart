import 'package:freezed_annotation/freezed_annotation.dart';

import '../../organization_member/domain/organization_member_status.dart';
import 'organization_status.dart';

part 'organization_query.freezed.dart';
part 'organization_query.g.dart';

@freezed
class OrganizationQuery with _$OrganizationQuery {
  @JsonSerializable(includeIfNull: false)
  const factory OrganizationQuery({
    @Default(100) int limit,
    @Default(0) int offset,
    String? name,
    bool? joined,
    OrganizationStatus? status,
    OrganizationMemberStatus? memberStatus,
  }) = _OrganizationQuery;

  factory OrganizationQuery.fromJson(Map<String, dynamic> json) =>
      _$OrganizationQueryFromJson(json);
}
