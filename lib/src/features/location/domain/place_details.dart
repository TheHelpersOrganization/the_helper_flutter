import 'package:collection/collection.dart';
import 'package:country_picker/country_picker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/location/domain/address_component.dart';
import 'package:the_helper/src/features/location/domain/location.dart';

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

extension PlaceDetailsX on PlaceDetails {
  Location toLocationFromFormattedAddress({int? maxComponents}) {
    var components = formattedAddress?.split(', ');
    if (components == null) {
      return Location(
        latitude: latitude,
        longitude: longitude,
      );
    }
    // Take last maxComponent components
    if (maxComponents != null && components.length > maxComponents) {
      components = components.sublist(components.length - maxComponents);
    }
    var country = components.lastOrNull;
    if (country != null && country.length != 2) {
      country = Country.tryParse(country)?.countryCode;
    }

    final region =
        components.length > 1 ? components[components.length - 2] : null;
    final locality =
        components.length > 2 ? components[components.length - 3] : null;
    // Join the rest
    final addressLine1 = components.length > 3
        ? components.sublist(0, components.length - 3).join(', ')
        : null;

    return Location(
      latitude: latitude,
      longitude: longitude,
      country: country,
      region: region,
      locality: locality,
      addressLine1: addressLine1,
    );
  }

  Location toLocationFromAddressComponents({int? maxComponents}) {
    if (addressComponents == null || addressComponents!.isEmpty) {
      return Location(
        latitude: latitude,
        longitude: longitude,
      );
    }
    var components = addressComponents!.toList();
    if (maxComponents != null && components.length > maxComponents) {
      components = components.sublist(components.length - maxComponents);
    }
    final countryComponent = components.lastOrNull;
    var country = countryComponent?.shortName;
    if (countryComponent != null && countryComponent.shortName.length != 2) {
      country = Country.tryParse(countryComponent.shortName)?.countryCode;
    }
    if (country == null) {
      country = countryComponent?.longName;
      if (countryComponent != null && countryComponent.longName.length != 2) {
        country = Country.tryParse(countryComponent.longName)?.countryCode;
      }
    }
    if (country == null) {
      return Location(
        latitude: latitude,
        longitude: longitude,
      );
    }
    final regionComponent =
        components.length > 1 ? components[components.length - 2] : null;
    final region = regionComponent?.shortName;
    final localityComponent =
        components.length > 2 ? components[components.length - 3] : null;
    final locality = localityComponent?.shortName;
    final addressLine1 = components.length > 3
        ? components
            .sublist(0, components.length - 3)
            .map((e) => e.shortName)
            .join(', ')
        : null;
    return Location(
      latitude: latitude,
      longitude: longitude,
      country: country,
      region: region,
      locality: locality,
      addressLine1: addressLine1,
    );
  }
}
