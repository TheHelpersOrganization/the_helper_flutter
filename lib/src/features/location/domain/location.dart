import 'package:freezed_annotation/freezed_annotation.dart';

part 'location.freezed.dart';
part 'location.g.dart';

@freezed
class Location with _$Location {
  factory Location({
    int? id,
    String? addressLine1,
    String? addressLine2,
    String? locality,
    String? region,
    String? country,
    double? latitude,
    double? longitude,
  }) = _Location;
  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
}
