import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/common/converter/converter.dart';
import 'package:the_helper/src/features/organization/domain/organization_member_role.dart';
import 'package:the_helper/src/features/organization_member/domain/converter/converter.dart';
import 'package:the_helper/src/features/organization_member/domain/get_organization_member_data.dart';
import 'package:the_helper/src/features/organization_member/domain/organization_member_status.dart';

part 'get_organization_member_query.freezed.dart';
part 'get_organization_member_query.g.dart';

class GetOrganizationMemberQueryInclude {
  static const String profile = 'profile';
  static const String role = 'role';
  static const String roleGranter = 'roleGranter';
}

@freezed
class GetOrganizationMemberQuery with _$GetOrganizationMemberQuery {
  @JsonSerializable(includeIfNull: false)
  factory GetOrganizationMemberQuery({
    @CommaSeparatedIntsConverter() List<int>? id,
    @CommaSeparatedIntsConverter() List<int>? notId,
    String? name,
    @OrganizationMemberStatusListConverter()
    List<OrganizationMemberStatus>? statuses,
    @OrganizationMemberRoleTypeConverter()
    List<OrganizationMemberRoleType>? role,
    @CommaSeparatedStringsConverter() List<String>? include,
    int? limit,
    int? offset,
  }) = _GetOrganizationMemberQuery;

  factory GetOrganizationMemberQuery.fromJson(Map<String, dynamic> json) =>
      _$GetOrganizationMemberQueryFromJson(json);
}
