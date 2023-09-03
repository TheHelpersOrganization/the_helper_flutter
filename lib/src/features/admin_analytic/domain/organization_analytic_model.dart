import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/organization/domain/organization_status.dart';

part 'organization_analytic_model.g.dart';
part 'organization_analytic_model.freezed.dart';

@freezed
class OrganizationAnalyticModel with _$OrganizationAnalyticModel {
  @JsonSerializable(includeIfNull: false)
  factory OrganizationAnalyticModel({
    required int id,
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
    @Default(0.0) double? hoursContributed,
  }) = _OrganizationAnalyticModel;

  factory OrganizationAnalyticModel.fromJson(Map<String, dynamic> json) =>
      _$OrganizationAnalyticModelFromJson(json);
}
