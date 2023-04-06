import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/organization_member/domain/organization_member.dart';

import '../../contact/domain/contact.dart';
import '../../location/domain/location.dart';

part 'organization.freezed.dart';
part 'organization.g.dart';

@freezed
class Organization with _$Organization {
  @JsonSerializable(includeIfNull: false)
  factory Organization({
    int? id,
    required String name,
    required String email,
    required String phoneNumber,
    required String description,
    required String website,
    int? logo,
    int? banner,
    List<Location>? locations,
    List<int>? files,
    List<Contact>? contacts,
    int? numberOfMembers,
    List<OrganizationMember>? myMembers,
  }) = _Organization;

  factory Organization.fromJson(Map<String, dynamic> json) =>
      _$OrganizationFromJson(json);
}
