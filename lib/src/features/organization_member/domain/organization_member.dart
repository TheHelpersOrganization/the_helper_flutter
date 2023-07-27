import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/organization/domain/organization.dart';
import 'package:the_helper/src/features/organization/domain/organization_member_role.dart';
import 'package:the_helper/src/features/profile/domain/profile.dart';

part 'organization_member.freezed.dart';
part 'organization_member.g.dart';

@Freezed()
class OrganizationMember with _$OrganizationMember {
  factory OrganizationMember({
    required int id,
    required int accountId,
    required int organizationId,
    required String status,
    int? censorId,
    String? rejectionReason,
    DateTime? updatedAt,
    Profile? profile,
    Organization? organization,
    List<OrganizationMemberRole>? roles,
  }) = _OrganizationMember;

  factory OrganizationMember.fromJson(Map<String, dynamic> json) =>
      _$OrganizationMemberFromJson(json);
}

extension OrganizationMemberX on OrganizationMember {
  bool hasRole(OrganizationMemberRoleType role) {
    return roles?.any((element) => element.name.weight >= role.weight) ?? false;
  }
}
