import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/account/domain/account.dart';
import 'package:the_helper/src/features/organization/domain/organization.dart';
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
    AccountModel? account,
    Profile? profile,
    Organization? organization,
  }) = _OrganizationMember;

  factory OrganizationMember.fromJson(Map<String, dynamic> json) =>
      _$OrganizationMemberFromJson(json);
}
