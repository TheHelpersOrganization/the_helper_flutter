import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/common/domain/file_info.dart';
import 'package:the_helper/src/features/organization_member/domain/organization_member.dart';

import '../../contact/domain/contact.dart';
import '../../location/domain/location.dart';
import 'organization_status.dart';

part 'organization.freezed.dart';
part 'organization.g.dart';

@freezed
class Organization with _$Organization {
  @JsonSerializable(includeIfNull: false)
  factory Organization({
    int? id,
    required OrganizationStatus status,
    @Default(false) bool isDisabled,
    required String name,
    required String email,
    required String phoneNumber,
    required String description,
    required String website,
    int? logo,
    int? banner,
    List<Location>? locations,
    List<Contact>? contacts,
    int? numberOfMembers,
    List<OrganizationMember>? myMembers,
    required bool hasJoined,
  }) = _Organization;

  factory Organization.fromJson(Map<String, dynamic> json) =>
      _$OrganizationFromJson(json);
}
