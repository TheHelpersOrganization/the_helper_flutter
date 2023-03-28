import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_model.freezed.dart';
part 'location_model.g.dart';

@freezed
class LocationModel with _$LocationModel {
  @JsonSerializable(includeIfNull: false)
  factory LocationModel({
    int? id,
    String? addressLine1,
    String? addressLine2,
    String? locality,
    String? region,
    String? country,
    double? longitude,
    double? latitude,
  }) = _LocationModel;

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);
}
