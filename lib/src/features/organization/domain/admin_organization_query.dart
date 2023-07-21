import 'package:freezed_annotation/freezed_annotation.dart';

import '../../organization_member/domain/organization_member_status.dart';
import 'organization_status.dart';

part 'admin_organization_query.freezed.dart';
part 'admin_organization_query.g.dart';

@freezed
class AdminOrganizationQuery with _$AdminOrganizationQuery {
  @JsonSerializable(includeIfNull: false)
  const factory AdminOrganizationQuery({
    @Default(100) int limit,
    @Default(0) int offset,
    String? name,
    OrganizationStatus? status,
    String? include,
    bool? isDisabled,
  }) = _OrganizationQuery;

  factory AdminOrganizationQuery.fromJson(Map<String, dynamic> json) =>
      _$AdminOrganizationQueryFromJson(json);
}
