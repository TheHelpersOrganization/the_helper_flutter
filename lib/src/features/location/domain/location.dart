import 'package:freezed_annotation/freezed_annotation.dart';

part 'location.g.dart';
part 'location.freezed.dart';

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
    double? longtitude,
  }) = _Location;
  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
}
