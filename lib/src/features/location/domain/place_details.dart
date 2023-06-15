import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/location/domain/address_component.dart';

part 'place_details.freezed.dart';
part 'place_details.g.dart';

@freezed
class PlaceDetails with _$PlaceDetails {
  @JsonSerializable(includeIfNull: false)
  factory PlaceDetails({
    String? formattedAddress,
    double? latitude,
    double? longitude,
    List<AddressComponent>? addressComponents,
  }) = _PlaceDetails;

  factory PlaceDetails.fromJson(Map<String, dynamic> json) =>
      _$PlaceDetailsFromJson(json);
}
