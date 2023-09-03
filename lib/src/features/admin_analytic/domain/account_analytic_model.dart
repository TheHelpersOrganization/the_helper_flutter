import 'package:freezed_annotation/freezed_annotation.dart';


part 'account_analytic_model.g.dart';
part 'account_analytic_model.freezed.dart';

@freezed
class AccountAnalyticModel with _$AccountAnalyticModel {
  @JsonSerializable(includeIfNull: false)
  factory AccountAnalyticModel({
    int? id,
    String? email,
    String? username,
    String? phoneNumber,
    String? firstName,
    String? lastName,
    int? avatarId,
    @Default(0.0) double? hoursContributed,
  }) = _AccountAnalyticModel;
  factory AccountAnalyticModel.fromJson(Map<String, dynamic> json) =>
      _$AccountAnalyticModelFromJson(json);
}
