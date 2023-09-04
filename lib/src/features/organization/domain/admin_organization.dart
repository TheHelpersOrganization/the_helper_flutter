import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/common/domain/file_info.dart';
import 'package:the_helper/src/features/organization_member/domain/organization_member.dart';

import '../../contact/domain/contact.dart';
import '../../location/domain/location.dart';
import 'organization_status.dart';

part 'admin_organization.freezed.dart';
part 'admin_organization.g.dart';

@freezed
class AdminOrganization with _$AdminOrganization {
  @JsonSerializable(includeIfNull: false)
  factory AdminOrganization({
    int? id,
    required int ownerId,
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
    @Default([]) List<FileInfoModel> files,
    List<Contact>? contacts,
    int? numberOfMembers,
    List<OrganizationMember>? myMembers,
    bool? hasJoined,
  }) = _AdminOrganization;

  factory AdminOrganization.fromJson(Map<String, dynamic> json) =>
      _$AdminOrganizationFromJson(json);
}
