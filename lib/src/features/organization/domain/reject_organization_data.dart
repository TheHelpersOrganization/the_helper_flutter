import 'package:freezed_annotation/freezed_annotation.dart';

part 'reject_organization_data.freezed.dart';
part 'reject_organization_data.g.dart';

@freezed
class RejectOrganizationData with _$RejectOrganizationData {
  @JsonSerializable(includeIfNull: false)
  const factory RejectOrganizationData({
    String? verifierComment,
  }) = _RejectOrganizationData;

  factory RejectOrganizationData.fromJson(Map<String, dynamic> json) =>
      _$RejectOrganizationDataFromJson(json);
}
