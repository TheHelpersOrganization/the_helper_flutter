import 'package:freezed_annotation/freezed_annotation.dart';

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
  }) = _OrganizationMember;

  factory OrganizationMember.fromJson(Map<String, dynamic> json) =>
      _$OrganizationMemberFromJson(json);
}
