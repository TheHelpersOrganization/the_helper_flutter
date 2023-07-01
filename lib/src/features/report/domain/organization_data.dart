
import 'package:freezed_annotation/freezed_annotation.dart';

part 'organization_data.freezed.dart';
part 'organization_data.g.dart';

@freezed
class OrganizationData with _$OrganizationData {
  factory OrganizationData({
    int? id,
    required String name,
    required String email,
    required String phoneNumber,
    required String description,
    required String website,
    int? logo,
    int? banner,
  }) = _OrganizationData;

  factory OrganizationData.fromJson(Map<String, dynamic> json) =>
      _$OrganizationDataFromJson(json);
}
