import 'package:the_helper/src/features/location/domain/address_component.dart';
import 'package:the_helper/src/features/location/domain/location.dart';
import 'package:the_helper/src/features/location/domain/place_details.dart';

extension LocationX on PlaceDetails {
  Location toLocation() {
    final components = addressComponents == null
        ? <AddressComponent>[]
        : [...addressComponents!];
    String? country;
    if (components.isNotEmpty) {
      country = components.removeLast().shortName;
    }
    String? region;
    if (components.isNotEmpty) {
      region = components.removeLast().longName;
    }
    String? locality;
    if (components.isNotEmpty) {
      locality = components.removeLast().longName;
    }
    String? addressLine1;
    if (components.isNotEmpty) {
      addressLine1 = components.map((e) => e.longName).join(', ');
    }

    return Location(
      addressLine1: addressLine1,
      locality: locality,
      region: region,
      country: country,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
