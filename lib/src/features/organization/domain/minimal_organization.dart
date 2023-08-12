import 'package:freezed_annotation/freezed_annotation.dart';

part 'minimal_organization.freezed.dart';
part 'minimal_organization.g.dart';

@freezed
class MinimalOrganization with _$MinimalOrganization {
  @JsonSerializable(includeIfNull: false)
  factory MinimalOrganization({
    required int id,
    required String name,
    int? logo,
  }) = _MinimalOrganization;

  factory MinimalOrganization.fromJson(Map<String, dynamic> json) =>
      _$MinimalOrganizationFromJson(json);
}
