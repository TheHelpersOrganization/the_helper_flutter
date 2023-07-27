import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/organization/domain/organization_member_role.dart';

class OrganizationMemberRoleTypeConverter
    extends JsonConverter<List<OrganizationMemberRoleType>?, String?> {
  const OrganizationMemberRoleTypeConverter();

  @override
  List<OrganizationMemberRoleType>? fromJson(String? json) {
    if (json == null) {
      return null;
    }
    return json
        .split(',')
        .map(
          (e) => OrganizationMemberRoleType.values.firstWhere(
            (element) => element.name == e,
          ),
        )
        .toList();
  }

  @override
  String? toJson(List<OrganizationMemberRoleType>? object) {
    if (object == null) {
      return null;
    }
    return object.map((e) => e.name).join(',');
  }
}
