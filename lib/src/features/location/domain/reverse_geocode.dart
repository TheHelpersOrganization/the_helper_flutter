import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/location/domain/address_component.dart';

part 'reverse_geocode.freezed.dart';
part 'reverse_geocode.g.dart';

@freezed
class ReverseGeocode with _$ReverseGeocode {
  @JsonSerializable(includeIfNull: false)
  factory ReverseGeocode({
    String? formattedAddress,
    double? latitude,
    double? longitude,
    List<AddressComponent>? addressComponents,
  }) = _ReverseGeocode;

  factory ReverseGeocode.fromJson(Map<String, dynamic> json) =>
      _$ReverseGeocodeFromJson(json);
}
