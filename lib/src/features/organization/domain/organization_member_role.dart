import 'package:freezed_annotation/freezed_annotation.dart';

part 'organization_member_role.freezed.dart';
part 'organization_member_role.g.dart';

enum OrganizationMemberRoleType {
  organizationOwner(100000),
  organizationManager(10000),
  organizationMemberManager(1000),
  organizationActivityManager(100),
  ;

  final int weight;

  const OrganizationMemberRoleType(this.weight);
}

@freezed
class OrganizationMemberRole with _$OrganizationMemberRole {
  factory OrganizationMemberRole({
    required OrganizationMemberRoleType name,
    String? displayName,
    String? description,
    DateTime? createdAt,
  }) = _OrganizationMemberRole;

  factory OrganizationMemberRole.fromJson(Map<String, dynamic> json) =>
      _$OrganizationMemberRoleFromJson(json);
}

@freezed
class MemberRoleInfo with _$MemberRoleInfo {
  factory MemberRoleInfo({
    required List<OrganizationMemberRole> assignedRoles,
    required List<OrganizationMemberRole> availableRoles,
    required List<OrganizationMemberRole> canGrantRoles,
    required List<OrganizationMemberRole> canRevokeRoles,
  }) = _MemberRoleInfo;

  factory MemberRoleInfo.fromJson(Map<String, dynamic> json) =>
      _$MemberRoleInfoFromJson(json);
}
