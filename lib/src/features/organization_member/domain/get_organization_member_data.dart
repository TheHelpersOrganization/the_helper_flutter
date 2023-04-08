import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/organization_member/domain/organization_member_status.dart';

part 'get_organization_member_data.freezed.dart';
part 'get_organization_member_data.g.dart';

@freezed
class GetOrganizationMemberData with _$GetOrganizationMemberData {
  @JsonSerializable(includeIfNull: false)
  factory GetOrganizationMemberData({
    @OrganizationMemberStatusListConverter()
        List<OrganizationMemberStatus>? statuses,
  }) = _GetOrganizationMemberData;

  factory GetOrganizationMemberData.fromJson(Map<String, dynamic> json) =>
      _$GetOrganizationMemberDataFromJson(json);
}

class OrganizationMemberStatusListConverter
    implements JsonConverter<List<OrganizationMemberStatus>?, String?> {
  const OrganizationMemberStatusListConverter();

  @override
  fromJson(String? json) {
    if (json == null) {
      return null;
    }
    return json
        .split(',')
        .map((e) => OrganizationMemberStatus.values
            .firstWhere((element) => element.toString() == e))
        .toList();
  }

  @override
  toJson(List<OrganizationMemberStatus>? object) {
    if (object == null) {
      return null;
    }
    return object.map((e) => e.name).join(',');
  }
}
